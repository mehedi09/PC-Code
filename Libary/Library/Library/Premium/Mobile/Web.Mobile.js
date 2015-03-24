/// <reference path="jquery-1.10.2.js"/>
/// <reference name="MicrosoftAjax.debug.js" />
/// <reference path="Web.DataViewResources.js"/>
/// <reference path="Web.DataView.js"/>
/// <reference path="Web.Menu.js"/>
/// <reference path="../Mobile/jquery.mobile-1.4.0-rc.1.js"/>
(function () {

    var userAgent = navigator.userAgent,
        platform = navigator.platform,
        iOS = /iPhone|iPad|iPod/.test(platform) && userAgent.indexOf("AppleWebKit") > -1,
        chrome = /chrom(e|ium)/i.test(userAgent),
        safari = /safari/i.test(userAgent),
        isDesktopClient = platform.match(/Win\d+|Mac/i) != null,
        activatorRegex = /^s*(\w+)\s*\|s*(.+)$/,
        filterDetailsRegex = /(<(\/*(a|span).*?>)|(&nbsp;)|onclick=\".+?\")/g,
        filterDetailsRegex2 = /(<(\/*(b).*?>))/g,
        phoneFieldRegex = /phone/i,
        sortByRegex = /^\s*(\w+)(\s+(\w+)\s*)?$/,
        body, verticalScrollbarWidth,
        membership,
        resources = Web.DataViewResources,
        resourcesViews = resources.Views,
        resourcesMenu = resources.Menu,
        resourcesData = resources.Data,
        resourcesPager = resources.Pager,
        resourcesModalPopup = resources.ModalPopup,
        resourcesHeaderFilter = resources.HeaderFilter,
        resourcesMobile = resources.Mobile,
        resourcesGrid = resources.Grid,
        resourcesForm = resources.Form,
        resourcesMembershipBar = Web.MembershipResources && Web.MembershipResources.Bar,
        resourcesInfoBar = resources.InfoBar,
        toolbarStandardControls,
        toolbarSearchControls,
        scrollInterval,
        popupOpenCallback,
        popupCloseCallback,
        touchMovePrevented,
        panelIsBusy,
        menuActionOnClose, skipMenuActionOnClose, contextActionOnClose, skipContextActionOnClose,
        contextSidebarRefreshTimeout, sidebarIsUndocked, sidebarElement,
        skipTap,
        contextPanelScrolling = {},
        currentContext,
        newSortExpression,
        _userVars, _focusedInput;

    function notImplemented() {
        $appfactory.alert('This feature is expected to be available in release scheduled to go out on December 23, 2013');
    }

    function activeLink(link) {
        $appfactory.mobile.activeLink(link);
    }

    function halt() {
        body.find('> *').hide();
    }

    function userActivity() {
        if (membership)
            membership._updateLastActivity();
    }

    function documentIsScrollable() {
        return $(document).height() > $(window).height();
    }

    function contextSidebar() {
        if (!sidebarElement)
            sidebarElement = $('#app-sidebar-right');
        return sidebarElement;
    }

    function contextSidebarIsVisible() {
        return contextSidebar().is(':visible');
    }

    function executeContextAction(item) {
        if (item.callback)
            item.callback(item.context);
        else if (item.href)
            window.location.href = item.href;
    }

    function contextSidebarIsScrollable() {
        var sidebar = contextSidebar(),
            inner = sidebar.find('.ui-panel-inner'),
            list = inner.find('.ui-listview'),
            footer = inner.find('.app-menu-footer');
        return $(window).height() < list.outerHeight() + footer.outerHeight();
    }

    function getActivePageId() {
        var activePage = $.mobile.activePage;
        return activePage ? activePage.attr('id') : '_';
    }

    function savePanelScrollTop(panel) {
        if (panel.length) {
            var activePageId = getActivePageId(),
                pageId = activePageId,
                lastPageId = contextPanelScrolling._lastPageId;
            if (panel.is('.app-sidebar-right')) {
                if (lastPageId && lastPageId != activePageId)
                    pageId = lastPageId;
                contextPanelScrolling._lastPageId = activePageId;
            }
            contextPanelScrolling[pageId + '_' + panel.attr('id')] = panel.find('.ui-panel-inner').scrollTop();
        }
    }

    function restorePanelScrollTop(panel) {
        if (panel.length)
            panel.find('.ui-panel-inner').scrollTop(contextPanelScrolling[getActivePageId() + '_' + panel.attr('id')] || 0);
    }

    function touchMoveIsCanceled() {
        var result = touchMovePrevented == true;
        return result;
    }

    function tapIsCanceled() {
        var result = skipTap;
        skipTap = false;
        return result == true;
    }

    function closeActivePanel(animation) {
        setTimeout(function () { $('div.ui-panel-open').panel('close', animation != true); }, 200);
    }

    function refreshContextSidebar(cancel) {
        if (contextSidebarRefreshTimeout) {
            clearTimeout(contextSidebarRefreshTimeout)
            contextSidebarRefreshTimeout = null;
        }
        if (!cancel)
            contextSidebarRefreshTimeout = setTimeout(function () {
                var sidebar = contextSidebar();
                savePanelScrollTop(sidebar);
                $appfactory.mobile.refreshContext(sidebar);
                contextSidebarRefreshTimeout = null;
                if (isDesktopClient) {
                    var sidebarIsVisible = contextSidebarIsVisible();
                    if (sidebarIsVisible) {
                        contextSidebar().trigger('vmouseover').trigger('vmouseout');
                        if (safari)
                            contextSidebar().find('ul').css('margin-bottom', '-1.1em');
                    }
                    //alert(documentIsScrollable());
                    //if (!contextSidebarIsScrollable())
                    //    alert(contextSidebarIsScrollable());
                    $('html').css('overflow-y', documentIsScrollable() ? '' : (sidebarIsVisible && contextSidebarIsScrollable() ? '' : 'scroll'));
                }
            }, 250);
    }

    function userVariable(name, value) {
        var token = 'AppFactoryUserVars';

        function persistVars() {
            var s = encodeURIComponent(JSON.stringify(_userVars)),
                futureDate = new Date().getDate() + 7,
                expires = new Date();
            expires.setDate(futureDate);
            s = String.format('{0}={1}; expires={2}; path=/', token, s, expires.toUTCString());
            document.cookie = s;
        }

        if (_userVars == null) {
            $(document.cookie.split(';')).each(function () {
                var cookie = this.trim();
                if (cookie.startsWith(token)) {
                    _userVars = decodeURIComponent(cookie.substring(token.length + 1));
                    try {
                        _userVars = JSON.parse(_userVars);
                        persistVars();
                    }
                    catch (ex) {
                    }
                }
            });
            if (!_userVars)
                _userVars = {};
        }
        if (value != null) {
            _userVars[name] = value;
            persistVars();
        }
        else
            return _userVars[name];
    }

    function toggleContextSidebar() {
        body.toggleClass('app-sidebar-undocked');
        sidebarIsUndocked = !sidebarIsUndocked;
        userVariable('sidebarIsUndocked', sidebarIsUndocked);
    }

    function parseActivator(elem, defaultText) {
        var activator = { text: defaultText, resolved: true, description: null, type: null },
            s = elem.attr('data-activator');
        if (!s) {
            var closestElem = elem.closest('div[data-activator]');
            s = closestElem.attr('data-activator');
            if (s)
                elem = closestElem;
        }
        if (!s)
            s = $(elem).prev('.DataViewHeader').text();
        if (s) {
            var m = activatorRegex.exec(s);
            if (m) {
                activator.text = m[2];
                activator.type = m[1];
            }
            else
                activator.text = s;
        }
        else
            activator.resolved = false;
        activator.description = elem.attr('data-activator-description');
        return activator;
    }

    function isPhoneField(field) {
        return field.tagged('mobile-action-call') || field.Name.match(phoneFieldRegex);
    }

    function isLookupField(field) {
        var itemsStyle = field.ItemsStyle;
        return !String.isNullOrEmpty(itemsStyle) && itemsStyle != 'CheckBoxList';
    }

    function animatedScroll(scrollTop, callback) {
        if (scrollTop < 0)
            scrollTop = 0;
        var iterations = 10,
            wnd = $(window),
            windowScrollTop = wnd.scrollTop(),
            delta = (scrollTop - windowScrollTop) / 2,
            targetScrollTop = scrollTop;
        scrollTop = windowScrollTop;
        function doScroll() {
            scrollTop += delta;
            delta = delta / 2;
            iterations--;
            wnd.scrollTop(iterations == 0 ? targetScrollTop : scrollTop);
            if (iterations > 0)
                setTimeout(doScroll, 25);
            else if (callback)
                callback();
        }
        doScroll();
    }

    function getContextPanel(selector, beforeOpenCallback) {
        var contextPanel = $(selector),
            mobile = $appfactory.mobile;
        blurFocusedInput();
        contextActionOnClose = null;
        if (contextPanel.length == 0) {
            contextPanel = $('<div data-position-fixed="true" data-role="panel" data-theme="a" data-position="right" data-display="overlay"><ul/><div class="app-menu-footer"/></div>').appendTo(body)
                .panel({
                    beforeopen: function () {
                        panelIsBusy = true;
                        mobile.pageScrolling(false);
                        if (beforeOpenCallback)
                            beforeOpenCallback();
                        if (contextSidebarIsVisible()) {
                            contextSidebar().addClass('app-inactive');
                            if (isDesktopClient) {
                                var w = contextSidebar().trigger('vmouseout').width();
                                contextPanel.width(w).next().css('right', w); // make sure that 'dismiss' does not cover the panel
                            }
                        }
                        else {
                            if (isDesktopClient)
                                contextPanel.width('');
                        }
                    },
                    open: function () {
                        panelIsBusy = false;
                        activeLink();
                    },
                    beforeclose: function () {
                        panelIsBusy = true;
                        savePanelScrollTop(contextPanel);
                    },
                    close: function (event) {
                        panelIsBusy = false;
                        if (contextActionOnClose)
                            contextActionOnClose();
                        contextActionOnClose = null;
                        if (contextSidebarIsVisible())
                            contextSidebar().removeClass('app-inactive');
                        mobile.pageScrolling(true);
                    }
                });
            if (selector.match(/^#/))
                contextPanel.attr('id', selector.substring(1));
            contextPanel.find('ul').listview().on('vclick', function (event) {
                var link = $(event.target).closest('a'),
                    linkIcon = link.closest('li').attr('data-icon');
                if (touchMoveIsCanceled() || panelIsBusy)
                    return false;
                var action = link.data('context-action');
                if (action && !skipContextActionOnClose) {
                    activeLink(link);
                    if (action.dataRel)
                        return true;
                    setTimeout(function () {
                        activeLink();
                        contextPanel.panel('close', linkIcon != 'bars' && linkIcon != 'back');
                        contextActionOnClose = function () {
                            setTimeout(function () {
                                executeContextAction(action);
                            }, 10);
                        }
                    }, 200);
                }
                skipContextActionOnClose = false;
                event.preventDefault();
                event.stopPropagation();
                return false;
            }).on('swipe', function () {
                //skipContextActionOnClose = true;
            });
        }
        //contextPanel.panel('toggle');
        return contextPanel;
    }

    function backToContextPanel() {
        if (contextSidebarIsVisible())
            contextSidebar().trigger('vmouseover');
        else
            $('#app-panel-context').panel('toggle');
    }

    function blurFocusedInput() {
        if (_focusedInput)
            $(_focusedInput).blur();
    }

    function showContextPanel(panelSelector) {
        return getContextPanel(panelSelector, function () {
            $appfactory.mobile.refreshContext(panelSelector, currentContext);
        }).panel('toggle');
    }

    function sortExpressionToText(dataView) {
        var sb = new Sys.StringBuilder(),
            fields = dataView._fields,
            f, i, sortOrder;
        if (dataView.get_sortExpression()) {
            for (i = 0; i < fields.length; i++) {
                f = dataView._allFields[fields[i].AliasIndex];
                if (f.AllowSorting) {
                    sortOrder = sortExpression(f.Name);
                    if (sortOrder) {
                        if (!sb.isEmpty())
                            sb.append(', ');
                        sb.appendFormat('{1} | {0}', f.HeaderText, fieldSortOrderText(f, sortOrder));
                    }
                }
            }
        }
        return sb.toString();
    }

    function updateSortExpressionIfChanged() {
        var dataView = $appfactory.mobile.dataView(),
            sb = new Sys.StringBuilder();
        if (newSortExpression != null) {
            $(dataView._fields).each(function () {
                var f = dataView._allFields[this.AliasIndex],
                    sortOrder = sortExpression(f.Name);
                if (sortOrder) {
                    if (!sb.isEmpty())
                        sb.append(',');
                    sb.appendFormat('{0} {1}', f.Name, sortOrder);
                }
            });
            dataView._sortExpression = sb.toString();
            dataView.sync();
        }
    }

    function sortExpression(fieldName, value) {
        var sortExpression = newSortExpression == null ? $appfactory.mobile.dataView().get_sortExpression() || '' : newSortExpression,
            list = sortExpression.split($appfactory._simpleListRegex),
            i, m;
        if (value == null) {
            if (sortExpression)
                for (i = 0; i < list.length; i++) {
                    m = list[i].match(sortByRegex);
                    if (m[1] == fieldName)
                        return m[3] || 'asc';
                }
            return null;
        }
        else {
            newSortExpression = value ? String.format('{0} {1}', fieldName, value) : '';
            /*var sortBy = String.format('{0} {1}', fieldName, value),
            found = false;
            if (sortExpression)
            for (i = 0; i < list.length; i++) {
            m = list[i].match(sortByRegex);
            if (m[1] == fieldName) {
            found = true;
            if (!value)
            list = list.splice(i, i);
            else
            list[i] = sortBy;
            break;
            }
            }
            if (!found)
            if (sortExpression)
            list.push(sortBy);
            else
            list[0] = sortBy;
            newSortExpression = list.join();*/
        }

    }


    function fieldSortOrderText(field, sortOrder) {
        var ascending = resourcesHeaderFilter.GenericSortAscending,
            descending = resourcesHeaderFilter.GenericSortDescending;
        switch (field.FilterType) {
            case 'Text':
                ascending = resourcesHeaderFilter.StringSortAscending;
                descending = resourcesHeaderFilter.StringSortDescending;
                break;
            case 'Date':
                ascending = resourcesHeaderFilter.DateSortAscending;
                descending = resourcesHeaderFilter.DateSortDescending;
                break;
        }
        return sortOrder == 'asc' ? ascending : descending;
    }

    function configureSort() {

        newSortExpression = null;

        var dataView = $appfactory.mobile.dataView(),
            viewLabel = dataView.get_view().Label,
            fields = dataView._fields,
            allFields = dataView._allFields,
            i, f,
            context = [
                { text: resourcesMobile.Back, icon: 'back', callback: backToContextPanel },
                { text: String.format(resourcesMobile.SortByField, viewLabel)}],
             sorted;

        for (i = 0; i < fields.length; i++) {
            f = fields[i];
            f = allFields[f.AliasIndex];
            if (f.AllowSorting) {
                var fieldSortOrder = sortExpression(f.Name);
                if (fieldSortOrder)
                    sorted = true;
                context.push({
                    text: f.HeaderText,
                    context: f,
                    icon: fieldSortOrder ? (fieldSortOrder == 'asc' ? 'arrow-u' : 'arrow-d') : null,
                    desc: fieldSortOrder ? fieldSortOrderText(f, fieldSortOrder) : null,
                    callback: function (contextField) {
                        var oldContext = currentContext,
                            sortBy = sortExpression(contextField.Name);

                        function backToListOfFields() {
                            currentContext = oldContext;
                            $('#app-panel-sort-fields').panel('toggle');
                        }

                        function updateSortExpression(field, sortOrder) {
                            if (sortExpression(field.Name) == sortOrder)
                                backToListOfFields();
                            else {
                                sortExpression(field.Name, sortOrder);
                                updateSortExpressionIfChanged();
                            }
                        }

                        currentContext = [{ text: resourcesMobile.Back, icon: 'back', callback: backToListOfFields}];
                        currentContext.push({ text: String.format(resourcesMobile.SortByOptions, viewLabel, contextField.HeaderText) });
                        currentContext.push({
                            text: fieldSortOrderText(contextField, 'asc'), callback: function () {
                                updateSortExpression(contextField, 'asc');
                            }, icon: sortBy == 'asc' ? 'check' : false
                        });
                        currentContext.push({
                            text: fieldSortOrderText(contextField, 'desc'), callback: function () {
                                updateSortExpression(contextField, 'desc');
                            }, icon: sortBy == 'desc' ? 'check' : false
                        });
                        currentContext.push({
                            text: resourcesMobile.DefaultOption, callback: function () {
                                updateSortExpression(contextField, false);
                            }, icon: sortBy ? false : 'check'
                        });
                        showContextPanel('#app-panel-sort-options');
                    }
                });
            }
        }
        for (i = 2; i < context.length; i++)
            if (sorted && !context[i].icon)
                context[i].icon = false;
        currentContext = context;
        showContextPanel('#app-panel-sort-fields'); //.addClass('app-causes-sort-on-close');
    }

    function configureFilter() {
        var dataView = $appfactory.mobile.dataView(),
            context = [
                { text: resourcesMobile.Back, icon: 'back', callback: backToContextPanel },
                { text: 'Filters are not available at this time.'}];
        currentContext = context;
        showContextPanel('#app-panel-view-options');
    }


    function configureView() {
        var pageInfo = $appfactory.mobile.pageInfo(),
            dataView = pageInfo.dataView,
            currentView = dataView.get_view(),
            views = dataView.get_views(),
            countOfViews = 0,
            context = [
                { text: resourcesMobile.Back, icon: 'back', callback: backToContextPanel },
                { text: resourcesMobile.AlternativeView}];

        $(views).each(function () {
            var view = this,
                selected = view.Label == currentView.Label;
            if (view.Type != 'Form' && view.ShowInSelector || view.Id == currentView.Id) {
                context.push({
                    text: view.Label, icon: selected ? 'check' : false, callback: function () {
                        dataView._forceSync();
                        dataView.extension()._commandRow = null;
                        dataView.executeCommand({ 'commandName': 'Select', 'commandArgument': view.Id });
                        pageInfo.text = view.Label;
                        pageInfo.resolved = false;
                    }
                });
                countOfViews++;
            }
        });
        if (countOfViews == 1)
            context.splice(context.length - 2, 2);
        if (dataView.get_isGrid()) {
            context.push({ text: resourcesMobile.PresentationStyle });
            context.push({
                text: resourcesMobile.List, icon: 'check', callback: function () {

                }
            });
            context.push({
                text: resourcesMobile.Grid, disabled: true, icon: false, callback: function () {
                }
            });
        }
        context.push({});
        context.push({
            text: resourcesPager.Refresh, icon: 'refresh', callback: function () {
                dataView.sync();
            }
        });
        currentContext = context;
        showContextPanel('#app-panel-view-options');
    }

    function addSelectAction(dataView, list, row) {
        var isModal = dataView._parentDataViewId && !dataView._lookupInfo,
            itemMap = dataView.extension().itemMap(),
            field = dataView._allFields[itemMap.heading];
        if (row && row.length)
            list.push({
                text: field.text(row[field.Index]), theme: 'b', toolbar: false, icon: 'eye', toolbar: !isModal, callback: function () {
                    if (isModal) {
                        function scrollFormToTop() {
                            animatedScroll(0, function () {
                                $appfactory.mobile
                                    .headingOnDemand()
                                    .blink($.mobile.activePage.find('.ui-collapsible-heading:first a'))
                            });
                        }
                        var navbarTab = $.mobile.activePage.find('div[data-role="navbar"] a:first');
                        if (navbarTab.length && !navbarTab.is('.app-tab-active')) {
                            navbarTab.trigger('vclick');
                            setTimeout(scrollFormToTop, 200);
                        }
                        else
                            scrollFormToTop();
                    }
                    else {
                        var pageInfo = $appfactory.mobile.pageInfo(),
                            item = $appfactory.mobile.content(pageInfo.id).parent().find('ul[data-role="listview"] a.ui-btn-b'),
                            screen = $appfactory.mobile.screen();
                        if (item.length) {
                            var itemY = item.offset().top,
                                itemHeight = item.outerHeight();
                            function blinkItem(callback) {
                                $appfactory.mobile.blink(item, callback);
                            }
                            if (itemY >= screen.top - 5 && itemY + itemHeight < screen.bottom)
                                blinkItem(function () {
                                    $appfactory.mobile.infoView(pageInfo.dataView, contextSidebarIsVisible());
                                });
                            else {
                                //animatedScroll(itemY - screen.height / 2, blinkItem);
                                $(window).scrollTop(itemY - screen.height / 2);
                                blinkItem();
                            }
                        }
                    }
                }
            });
    }

    function enumeratePhoneContextOptions(dataView, list, row) {
        if (row)
            $(dataView._fields).each(function () {
                var field = dataView._allFields[this.AliasIndex];
                if (isPhoneField(field)) {
                    var v = row[field.Index];
                    if (v != null)
                        list.push({
                            text: field.text(v), desc: field.HeaderText, icon: 'phone', href: 'tel:' + v
                        });
                }
            });

    }

    function actionToIcon(action) {
        var icon = null;
        switch (action.CommandName) {
            case 'Delete':
                icon = 'delete';
                break;
            //case 'Duplicate':                 
            case 'New':
                icon = 'plus';
                break;
            case 'Edit':
                icon = 'edit';
                break;
            case 'Insert':
            case 'Update':
                icon = 'check';
                break;
            case 'Cancel':
                icon = 'back';
                break;
        }
        return icon;
    }

    function enumerateActions(scope, dataView, list, row) {
        var rowIsSelected = dataView.rowIsSelected(row),
            item,
            listedActions = [],
            rowGroups,
            viewId = dataView.get_viewId(),
            isGrid = dataView.get_isGrid(),
            skippedActions = {},
            isSpecialAction, specialActionPlaceholder,
            callback;
        $(dataView.actionGroups(scope)).each(function (groupIndex) {
            var group = this;
            if (group.Scope == 'ActionBar' && !group.Flat && group.Id != scope) {
                list.push({
                    'text': group.HeaderText, 'icon': 'bars', 'context': group, 'callback': function (contextGroup) {
                        currentContext = [{
                            text: resourcesMobile.Back, icon: 'back', callback: backToContextPanel
                        }, {}];
                        enumerateActions(contextGroup.Id, dataView, currentContext, row);
                        showContextPanel('#app-panel-group-actions');
                    }
                });
            }
            else if (!group.Scope.match(/Grid|ActionColumn/) || rowIsSelected && isGrid)
                $(this.Actions).each(function (actionIndex) {
                    var action = this,
                        signature = action.CommandName + '/' + action.CommandArgument,
                        allowInList = listedActions.indexOf(signature) == -1 && (!action.CommandName || !action.CommandName.match(/^(DataSheet|Grid|Export(Rowset|Rss)|Import|BatchEdit)$/));
                    callback = action.CommandName ?
                        function () {
                            if (action.CommandName == 'Cancel')
                                window.history.go(-1);
                            else {
                                function executeCommand() {
                                    dataView.extension().command(row, action.CommandName, action.CommandArgument, action.CausesValidation, action.Path);
                                }
                                if (!String.isNullOrEmpty(action.Confirmation)) {
                                    dataView._confirm({ action: action }, function (text) {
                                        $appfactory.confirm(text, function () {
                                            executeCommand();
                                        });
                                    });
                                }
                                else
                                    executeCommand();
                            }
                        } :
                        null;
                    specialActionPlaceholder = null;
                    if (allowInList) {
                        isSpecialAction = action.CommandName && action.CommandName.match(/^(Select|Edit|New|Duplicate)$/);
                        if (isSpecialAction && isGrid && (action.CommandArgument == viewId || String.isNullOrEmpty(action.CommandArgument))) {
                            skippedActions[action.CommandName] = list[list.length - 1];
                            allowInList = false;
                        }
                        else if (isSpecialAction)
                            specialActionPlaceholder = skippedActions[action.CommandName];
                    }
                    if (allowInList && !callback && group.Scope.match(/Grid|ActionColumn/))
                        allowInList = false;
                    if (allowInList) {
                        listedActions.push(signature);
                        item = { 'text': action.HeaderText, 'callback': callback, 'icon': actionToIcon(action), 'command': action.CommandName, 'argument': action.CommandArgument };
                        if (specialActionPlaceholder)
                            Array.insert(list, list.indexOf(specialActionPlaceholder) + 1, item);
                        else
                            list.push(item);
                    }

                });
        });

    }

    function resolvePageText(dataView) {
        var pageInfo = $appfactory.mobile.pageInfo(dataView._id);
        if (!pageInfo.resolved) {
            pageInfo.text = dataView.get_view().Label;
            pageInfo.resolved = true;
            $appfactory.mobile.toolbar($appfactory.mobile.title());
        }
    }

    function createItemMap(dataView) {
        var fields = dataView._fields,
            allFields = dataView._allFields,
            map = { heading: null, thumb: null, aside: null, count: null, desc: [], descLabels: [], descPara: [] },
            tagged = false;
        $(allFields).each(function (index) {
            var field = allFields[index],
                    fieldIndex = field.AliasIndex,
                    aliasField = allFields[fieldIndex];
            if (field.tagged('mobile-')) {
                tagged = true;
                var labeled = field.tagged('mobile-item-label');
                if (field.tagged('mobile-item-heading'))
                    map.heading = fieldIndex;
                if (field.tagged('mobile-item-desc')) {
                    map.desc.push(fieldIndex);
                    if (labeled)
                        map.descLabels[map.desc.length - 1] = true;
                    if (field.tagged('mobile-item-para'))
                        map.descPara[map.desc.length - 1] = true;
                }
                if (field.tagged('mobile-item-count')) {
                    map.count = fieldIndex;
                    map.countLabel = labeled;
                }
                if (field.tagged('mobile-item-aside')) {
                    map.aside = fieldIndex;
                    map.asideLabel = labeled;
                }
                if (field.tagged('mobile-item-thumb'))
                    map.thumb = fieldIndex;
            }
        });
        if (tagged) {
            if (map.heading == null)
                map.heading = fields[0].AliasIndex;
        }
        else {
            var summaryOnly = true;
            function MapField(index) {
                if (!this.Hidden)
                    if (this.OnDemand) {
                        if (map.thumb == null && this.OnDemandStyle == 0) {
                            map.thumb = index;
                        }
                    }
                    else if (!summaryOnly || this.ShowInSummary) {
                        index = this.AliasIndex;
                        var field = allFields[index],
                            isDate = field.Type.match(/^Date/),
                            isSimpleType = field.Type != 'String' && !field.OnDemand;
                        if (map.heading == null)
                            map.heading = index;
                        else if (map.aside == null && isDate)
                            map.aside = index;
                        else if (map.count == null && isSimpleType && !isDate)
                            map.count = index;
                        else {
                            map.desc.push(index);
                            if (isSimpleType)
                                map.descLabels[map.desc.length - 1] = index;
                        }
                        tagged = true;
                    }
            }
            $(fields).each(MapField);
            if (!tagged) {
                summaryOnly = false;
                $(fields).each(MapField);
            }
        }
        return map;
    }

    function defaultPopupOptions(transition) {
        return {
            transition: transition || 'pop',
            positionTo: 'window',
            afteropen: function () {
                $.mobile.loading('hide');
                $appfactory.mobile.pageScrolling(false);
                var callback = popupOpenCallback;
                if (callback)
                    setTimeout(function () {
                        callback();
                    }, 200);
                popupOpenCallback = null;
            },
            afterclose: function () {
                $appfactory.mobile.pageScrolling(true);
                var callback = popupCloseCallback;
                if (callback)
                    setTimeout(function () {
                        callback();
                    }, 200);
                popupCloseCallback = null;
            }
        };
    }

    if (typeof Web == 'undefined') Web = { DataView: {} }

    Web.DataView.MobileBase = function () {
        Web.DataView.MobileBase.initializeBase(this);
    }

    Web.DataView.MobileBase.prototype = {
        initialize: function () {
        },
        show: function () {

        },
        hide: function () {

        },
        systemFilter: function () {
            return null;
        },
        reset: function (full) {

        },
        wait: function () {

        },
        dataView: function (owner) {
            if (owner == null)
                return this._dataView;
            else
                this._dataView = owner;
        },
        inserting: function () {
            return this.dataView().get_isInserting();
        },
        editing: function () {
            return this.dataView().get_isEditing();
        },
        content: function () {
            return $appfactory.mobile.content(this._dataView._id);
        },
        commandRow: function (value) {
            if (value == null)
                return this._commandRow;
            else {
                var row = this._commandRow = value.slice(0);
                this.dataView()._rows = [value];
                return row;
            }
        },
        command: function (row, commandName, argument, causesValidation, path) {
            this.commandRow(row);
            var dataView = this.dataView();
            dataView.executeRowCommand(0, commandName, argument, causesValidation, path);
        },
        action: function (row, scope, actionIndex, rowIndex, groupIndex, confirmed) {
            this.commandRow(row);
            var dataView = this.dataView();
            dataView.executeAction(0, scope, actionIndex, rowIndex, groupIndex, confirmed);
        },
        itemMap: function () {
            return createItemMap(this.dataView());
        },
        stateChanged: function () {
            refreshContextSidebar();
        },
        lookupInfo: function (value) {
            var dataView = this.dataView();
            if (arguments.length) {
                dataView._lookupInfo = value;
            }
            else
                return dataView._lookupInfo;
        },
        viewDescription: function () {
            var dataView = this.dataView(),
                viewDescription = dataView.get_view().HeaderText;
            viewDescription = dataView._formatViewText(resourcesViews.DefaultDescriptions[viewDescription], true, viewDescription);
            return viewDescription;
        },
        executeInContext: function (command, argument, ignoreLookup) {
            var oldLookupInfo = this.lookupInfo(),
                context = [];
            if (ignoreLookup)
                this.lookupInfo(null);
            this.context(context);
            $(context).each(function () {
                var item = this,
                    itemCommand = item.command;
                if (itemCommand && itemCommand == command && (argument == null || item.argument == argument)) {
                    executeContextAction(item);
                    return false;
                }
            });
            if (ignoreLookup)
                this.lookupInfo(oldLookupInfo);
        }
    }

    /* implementation of extensions */

    Web.DataView.Extensions = {}

    /* dataview */
    Web.DataView.prototype.mobileUpdated = function () {
        var activator = parseActivator($(this._element), document.title);
        if (this._pageSize < 25)
            this._pageSize = 25;
        var info = { id: this.get_id(), text: activator.text, dataView: this };
        $appfactory.mobile.pageInfo(info);
        if (!this._hidden && !this._filterSource && !$appfactory.mobile._appLoaded)
            var pageButton = $('<a class="app-action-navigate" ></a>')
                .attr('href', '#' + info.id)
                .appendTo($('<li>').appendTo($appfactory.mobile.pageMenu())).text(activator.text);
    }

    /* grid view */

    Web.DataView.Extensions.Grid = function (dataView) {
        return new Web.DataView.MobileGrid(dataView);
    }

    Web.DataView.Extensions.DataSheet = function (dataView) {
        return new Web.DataView.MobileGrid(dataView);
    }

    Web.DataView.MobileGrid = function (dataView) {
        Web.DataView.MobileGrid.initializeBase(this);
        this.dataView(dataView);
    }

    Web.DataView.MobileGrid.prototype = {
        options: function () {
            var dataView = this.dataView();
            return { quickFind: dataView.get_isGrid() && dataView.get_showQuickFind(), filterDetails: true };
        },
        tap: function (row, action) {
            var dataView = this.dataView();
            if (dataView._busy()) return;
            if (dataView._hasKey()) {
                this.command(row, 'Select');
                if (action)
                    $.mobile.activePage.find('ul[data-role="listview"] li a').each(function () {
                        var link = $(this),
                            dataContext = link.data('data-context');
                        if (dataContext && dataView.rowIsSelected(dataContext.row)) {
                            link.addClass('ui-btn-b');
                            return false;
                        }
                    });
                if (!action || action == 'select') {
                    if (this.lookupInfo())
                        this.executeInContext('Select');
                    else {
                        var context = [];
                        $appfactory.mobile.navContext(context);
                        $(context).each(function () {
                            var action = this;
                            if (action.text && action.icon != 'phone' && action.icon != 'bars' && action.icon != 'eye') {
                                executeContextAction(action);
                                return false;
                            }
                        });
                    }
                }
            }
            refreshContextSidebar();
        },
        clearSelection: function (updateUI) {
            if (updateUI)
                $.mobile.activePage.find('ul[data-role="listview"] a.ui-btn-b').removeClass('ui-btn-b');
            var dataView = this.dataView();
            dataView._clearSelectedKey();
            dataView._forgetSelectedRow(true);
            delete this._commandRow;
            refreshContextSidebar();
        },
        quickFind: function (value) {
            var dataView = this.dataView();
            if (value != null) {
                dataView.set_quickFindText(value);
                dataView._executeQuickFind(value);
            }
            else
                return dataView._quickFindText ? dataView._quickFindText : '';
        },
        dispose: function () {
            var listview = this.content().next('ul[data-role="listview"]');
            listview.find('a').data('data-context', null);
            listview.listview('destroy').remove();
        },
        refresh: function () {
            var that = this,
                pageIndex = that.pageIndex(),
                dataView = that.dataView(),
                fields = dataView._fields,
                allFields = dataView._allFields,
                content = that.content(),
                rows = that.visibleDataRows(pageIndex),
                listview = content.next('ul[data-role="listview"]'),
                pageSize = this.pageSize(),
                allowLoadAtTop = pageIndex > 0,
                allowLoadAtBottom = pageIndex < that.pageCount() - 1,
                scrollCount,
                skipClick,
                map = that.itemMap(),
                showRowNumber = dataView.get_showRowNumber() == true,
                requiresReset = that._reset;

            function clearListView() {
                listview.find('a').data('data-context', null);
                listview.find('li').remove();
                $(window).scrollTop(0);
            }

            if (!rows) {
                if (requiresReset)
                    clearListView();
                dataView.goToPage(pageIndex, true);
                return;
            }

            if (!this._loaded) {
                this._loaded = true;
                $appfactory.mobile.search({ 'allow': this.options().quickFind });
            }

            if (!listview.length) {
                content.hide();
                listview = $('<ul data-role="listview" class="app-listview"/>').insertAfter(content).listview()
                    .bind('taphold', function (event) {
                        if (tapIsCanceled())
                            return false;
                        if (dataView._busy()) return;
                        var link = $(event.target).closest('a'),
                            dataContext = link.data('data-context'),
                            multiSelect = dataView.multiSelect();
                        if (link.closest('li').is('.dv-item')) {
                            if (link.is('.ui-btn-b')) {
                                link.removeClass('ui-btn-b');
                                if (multiSelect) {
                                }
                                else {
                                    that.clearSelection();
                                    if (that.lookupInfo()) {
                                        activeLink(link);
                                        setTimeout(function () {
                                            activeLink();
                                            that.executeInContext('Clear');
                                        }, 200);
                                    }
                                    else {
                                        activeLink(link);
                                        setTimeout(function () { activeLink(); }, 200);
                                    }
                                }
                            }
                            else if (dataView._hasKey()) {
                                if (multiSelect) {
                                }
                                else
                                    listview.find('a.ui-btn-b').removeClass('ui-btn-b');
                                link.addClass('ui-btn-b');
                                that.tap(dataContext.row, 'none');
                                activeLink(link);
                                setTimeout(function () { activeLink(); }, 200);
                            }
                            skipClick = true;
                        }
                        return false;
                    })
                    .on('vclick', function (event) {
                        if (tapIsCanceled())
                            return false;
                        var link = $(event.target).closest('a');
                        if (link.length) {
                            var pageCount = that.pageCount();
                            function loadData(below) {
                                if (!dataView._busy()) {
                                    that._loadAtTop = !below;
                                    that.pageIndex(that.pageIndex(below ? 'bottom' : 'top') + (below ? 1 : -1));
                                    that.refresh();
                                    if (dataView._busy())
                                        $.mobile.loading('hide');
                                }
                            }
                            if (link.is('.dv-load-at-bottom'))
                                loadData(true);
                            else if (link.is('.dv-load-at-top:visible'))
                                loadData(false);
                            else {
                                if (skipClick) {
                                    skipClick = false;
                                    return;
                                }
                                if (dataView.multiSelect()) {
                                    if (listview.find('a.ui-btn-b:first').length) {
                                        if (link.is('.ui-btn-b'))
                                            link.removeClass('ui-btn-b');
                                        else
                                            link.addClass('ui-btn-b');
                                    }
                                }
                                else {
                                    activeLink(link);
                                    setTimeout(function () {
                                        activeLink();
                                        if (dataView.multiSelect()) {
                                        }
                                        else {
                                            var dataContext = link.data('data-context')
                                            if (dataContext) {
                                                if (dataView._hasKey()) {
                                                    listview.find('a.ui-btn-b').removeClass('ui-btn-b');
                                                    link.addClass('ui-btn-b');
                                                }
                                                that.tap(dataContext.row);
                                            }
                                            else if (link.is('.dv-action-refresh'))
                                                dataView.sync();
                                            //alert('Select is not implemented');
                                        }
                                    }, 200);
                                }
                            }
                        }
                        return false;
                    });
            }

            if (requiresReset)
                clearListView();

            var loadAtBottomItem = listview.find('li:last'),
                loadAtTopItem, loadAtTopVisibleHeight,
                topRowIndex = pageIndex * pageSize;
            if (!loadAtBottomItem.length)
                resolvePageText(dataView);
            if (allowLoadAtTop && loadAtBottomItem.length == 0)
                item = $(String.format('<li data-icon="refresh"><a class="dv-load-at-top"><p>{0}</p></a></li>', resourcesHeaderFilter.Loading)).appendTo(listview);

            if (that._loadAtTop) {
                loadAtTopItem = listview.find('li:first');
                loadAtTopVisibleHeight = loadAtTopItem.offset().top + loadAtTopItem.height() - $appfactory.mobile.screen().top;
                rows = rows.reverse();
            }
            else
                loadAtBottomItem.remove();
            $(rows).each(function (index) {
                var row = this, v,
                    item = $('<li class="dv-item"/>');
                if (that._loadAtTop)
                    item.insertAfter(loadAtTopItem);
                else
                    item.appendTo(listview);
                var link = $('<a>').appendTo(item).data('data-context', { row: this.slice(0), pageIndex: pageIndex });
                if (dataView.rowIsSelected(row)) {
                    item.attr('data-theme', 'b');
                    if (!that.commandRow()) {
                        dataView._forgetSelectedRow(true);
                        that.command(row, 'Select');
                    }
                }
                // thumb
                if (map.thumb != null) {
                    v = row[map.thumb];
                    var blobHref = dataView.resolveClientUrl(dataView.get_appRootPath());
                    var blobField = allFields[map.thumb];
                    var thumb = $('<img class="ui-li-thumb"/>').appendTo(link).attr({
                        src: String.format('{0}blob.ashx?{1}=t|{2}', blobHref, blobField.OnDemandHandler, v)
                    });
                }
                // aside
                if (map.aside != null) {
                    var aside = $('<p class="ui-li-aside"/>').appendTo(link);
                    var asideField = allFields[map.aside];
                    v = row[map.aside];
                    v = asideField.text(v);
                    if (asideField.HtmlEncode)
                        aside.text(v);
                    else
                        aside.html(v);
                    if (map.asideLabel)
                        $('<span class="app-item-label"/>').insertBefore(aside.contents()).text(asideField.HeaderText + ':');
                }
                // heading
                var heading = $('<h3>').appendTo(link);
                var headingField = allFields[map.heading];
                v = row[map.heading];
                v = headingField.text(v);
                if (showRowNumber)
                    v = String.format('{0}. {1}', that._loadAtTop ? topRowIndex + pageSize - index : topRowIndex + index + 1, v);
                if (headingField.HtmlEncode)
                    heading.text(v);
                else
                    heading.html(v);
                // count
                if (map.count != null && (aside == null || map.desc.length)) {
                    var count = $('<span class="ui-li-count"/>').appendTo(link);
                    var countField = allFields[map.count];
                    v = row[map.count];
                    v = countField.text(v);
                    if (countField.HtmlEncode)
                        count.text(v);
                    else
                        count.html(v);
                    if (map.countLabel)
                        $('<span class="app-item-label"/>').insertBefore(count.contents()).text(countField.HeaderText + ':');

                }
                // descriptive fields
                if (map.desc.length) {
                    var desc = $('<p>').appendTo(link),
                        firstDescItem = true;
                    $(map.desc).each(function (index) {
                        var fieldIndex = this,
                            field = allFields[fieldIndex],
                            label = map.descLabels[index],
                            para = map.descPara[index];
                        if (para) {
                            firstDescItem = true;
                            desc = $('<p>').appendTo(link).insertAfter(desc);
                        }
                        if (firstDescItem)
                            firstDescItem = false;
                        else
                            $('<span class="app-item-desc-divider"/>').appendTo(desc);
                        v = row[fieldIndex];
                        var span = $('<span>').appendTo(desc);
                        v = field.text(row[fieldIndex]);
                        if (field.HtmlEncode)
                            span.text(v);
                        else
                            span.html(v);
                        if (label)
                            $('<span class="app-item-label"/>').insertBefore(span.contents()).text(field.HeaderText + ':');

                    });
                }
            });
            if (allowLoadAtBottom && !that._loadAtTop)
                item = $(String.format('<li data-icon="none"><a href="#" class="dv-load-at-bottom"><p>{0}</p></a></li>', resourcesHeaderFilter.Loading)).appendTo(listview);
            if (that._loadAtTop) {
                if (pageIndex == 0) {
                    loadAtTopItem.remove();
                }
            }

            if (topRowIndex == 0 && dataView._showDescription != false && (!that.lookupInfo() || !contextSidebarIsVisible())) {
                var instruction = that.instruction();
                if (instruction)
                    $('<li data-role="list-divider" class="app-list-instruction"/>').insertBefore(listview.find('li:first')).html(instruction);
            }

            if (!dataView._totalRowCount)
                $('<li data-icon="refresh"><a class="dv-action-refresh"><p/></a></li>').appendTo(listview)
                    .find('p').text(resourcesData.NoRecords);
            listview.listview('refresh');
            if (that._loadAtTop) {
                var item = listview.find('li.dv-item:eq(' + (pageSize) + ')');
                $(window).scrollTop(item.offset().top - loadAtTopVisibleHeight - $appfactory.mobile.toolbar().outerHeight());
            }
            if (requiresReset || !that._synced) {
                var selectedItem = listview.find('a.ui-btn-b:first'),
                    loadAboveButton = listview.find('a.dv-load-at-top'),
                    loadAboveButtonHeight = loadAboveButton.length ? loadAboveButton.outerHeight() : 0,
                    screen = $appfactory.mobile.screen();
                if (selectedItem.length) {
                    var itemTop = selectedItem.offset().top,
                        delta = Math.floor((screen.height - selectedItem.outerHeight()) / 2),
                        scrollTop = itemTop - delta - loadAboveButtonHeight + 2;
                    $(window).scrollTop(scrollTop > 0 ? scrollTop : loadAboveButtonHeight);
                    if (requiresReset) {
                        that.tap(selectedItem.data('data-context').row, 'none');
                        dataView.raiseSelected();
                    }
                    setTimeout(function () {
                        $appfactory.mobile.fetchOnDemand();
                    }, 10);
                }
                else
                    if (!that._synced && dataView.get_selectedKey().length) {
                        setTimeout(function () {
                            dataView.sync();
                        }, 10);
                    }
                    else
                        that.clearSelection();
                that._synced = true;
            }
            that._reset = false;
            that._loadAtTop = null;
            if (!that._loadAtTop)
                that.stateChanged();
        },
        reset: function (full) {
            this._reset = true;
        },
        visibleDataRows: function (pageIndex) {
            var dataView = this._dataView,
              currentPage = null,
              pageCount = this.pageCount(),
              cachedPages = dataView._cachedPages;
            if (cachedPages)
                for (var i = 0; i < cachedPages.length; i++) {
                    var p = cachedPages[i];
                    if (p.index == pageIndex)
                        return p.rows;
                }
            return null;
        },
        pageIndex: function (value) {
            var dataView = this._dataView;
            if (typeof value == 'string') {
                if (value == 'bottom') {
                    var bottomItemData = this.content().parent().find('ul li.dv-item:last a').data('data-context');
                    if (bottomItemData)
                        return bottomItemData.pageIndex;
                }
                if (value == 'top') {
                    var topItemData = this.content().parent().find('ul li.dv-item:first a').data('data-context');
                    if (topItemData)
                        return topItemData.pageIndex;
                }
                return dataView.get_pageIndex();
            }
            else if (value == null)
                return dataView.get_pageIndex();
            else
                dataView.set_pageIndex(value);
        },
        pageCount: function () {
            var dataView = this._dataView;
            return dataView.get_pageCount();
        },
        pageSize: function () {
            var dataView = this._dataView;
            return dataView.get_pageSize();
        },
        instruction: function () {
            var lookupInfo = this.lookupInfo(),
                instruction = this.viewDescription();
            if (lookupInfo) {
                instruction = String.format(lookupInfo.field.ItemsDescription || resourcesMobile.LookupInstruction, lookupInfo.aliasField.HeaderText);
                if (lookupInfo.value)
                    instruction += String.format(resourcesMobile.LookupOriginalSelection, lookupInfo.text);
            }
            return instruction;
        },
        context: function (list) {
            var that = this,
                dataView = that.dataView(),
                totalRowCount = dataView._totalRowCount,
                viewLabel = dataView.get_view().Label,
                sortExpression = dataView.get_sortExpression(),
                row = that.commandRow() || [],
                lookupInfo = this.lookupInfo(),
                existingRow = row && row.length;

            if (totalRowCount != -1) {
                list.push({ text: viewLabel, count: totalRowCount, theme: 'b', icon: 'bars', callback: configureView });
                list.push({ text: resourcesMobile.Sort, icon: 'bars', desc: sortExpressionToText(dataView), callback: configureSort });
                list.push({ text: resourcesMobile.Filter, icon: 'bars', callback: configureFilter });
                if (!lookupInfo || lookupInfo.value != null)
                    list.push({});
                addSelectAction(dataView, list, row);
                if (lookupInfo)
                    list.push({ text: existingRow ? that.instruction() : null });
                else
                    enumeratePhoneContextOptions(dataView, list, row);
                if (lookupInfo) {

                    function changeLookup(value, text) {
                        var fieldInput = $('#' + lookupInfo.pageId + ' .app-field-' + lookupInfo.field.Name);
                        lookupInfo.value = value;
                        lookupInfo.text = text;
                        fieldInput.val(value);
                        fieldInput.prev().text(lookupInfo.text);
                        history.back();
                        setTimeout(function () {
                            fieldInput.siblings('input:text').focus();
                        }, 200);
                    }

                    if (existingRow)
                        list.push({
                            text: resourcesMobile.LookupSelectAction, icon: 'check', command: 'Select', callback: function () {
                                var dataValueField = lookupInfo.field.ItemsDataValueField,
                                    dataTextField = lookupInfo.field.ItemsDataTextField,
                                    lookupPageInfo = $appfactory.mobile.pageInfo(),
                                    lookupDataView = lookupPageInfo.dataView,
                                    valueField, textField;
                                if (!dataValueField)
                                    $(lookupDataView._allFields).each(function () {
                                        if (this.IsPrimaryKey) {
                                            dataValueField = this.Name;
                                            return false;
                                        }
                                    });
                                if (!dataTextField)
                                    $(lookupDataView._allFields).each(function () {
                                        var field = this;
                                        if (!field.Hidden && !field.OnDemand) {
                                            dataTextField = field.Name;
                                            return false;
                                        }
                                    });
                                valueField = lookupDataView.findField(dataValueField);
                                textField = lookupDataView.findField(dataTextField);
                                changeLookup(row[valueField.Index], row[textField.Index]);
                            }
                        });
                    if (lookupInfo.value)
                        list.push({
                            text: resourcesMobile.LookupClearAction, icon: 'forbidden', command: 'Clear', callback: function () {
                                changeLookup(null, resourcesData.NullValueInForms);
                            }
                        });
                    if (!String.isNullOrEmpty(lookupInfo.field.ItemsNewDataView))
                        list.push({
                            text: resourcesMobile.LookupNewAction, icon: 'plus', callback: function () {
                                that.executeInContext('New', lookupInfo.field.ItemsNewDataView, true);
                            }
                        });
                    list.push({});
                    if (existingRow && !lookupInfo.field.tagged('lookup-details-hidden'))
                        list.push({
                            text: resourcesMobile.LookupViewAction, callback: function () {
                                Web.DataView._defaultUseCase = 'ObjectRef';
                                that.executeInContext('Select', 'editForm1', true);
                            }
                        });
                    enumeratePhoneContextOptions(dataView, list, row);
                }
                else
                    enumerateActions(['ActionColumn', 'Grid', 'ActionBar'], dataView, list, row);
            }
        }
    }

    /* form view */

    Web.DataView.Extensions.Form = function (dataView) {
        return new Web.DataView.MobileForm(dataView);
    }

    Web.DataView.MobileForm = function (dataView) {
        Web.DataView.MobileForm.initializeBase(this);
        this.dataView(dataView);
    }

    Web.DataView.MobileForm.prototype = {
        initialize: function () {
            this._editors = {};
            this._initRow();
        },
        _initRow: function () {
            var dataView = this.dataView(),
                row = this.inserting() ? dataView._newRow : dataView._rows[0];
            dataView._mergeRowUpdates(row);
            return this.commandRow(row);
        },
        reset: function (full) {
            this._reset = true;
            this._initRow();
        },
        options: function () {
            return { quickFind: false, filterDetails: false };
        },
        dispose: function () {
            this._dispose();
        },
        _dispose: function () {
            var content = this.content();
            content.find('a').data('data-context', null);
            content.find('select').selectmenu('destroy');
            for (var fieldName in this._editors) {
                var f = this._editors[fieldName];
                f.field = null;
                f.originalField = null;
                $(f.item).remove();
                delete f.item;
                $(f.label).remove();
                delete f.label;
                $(f.readers).remove();
                delete f.readers;
                $(f.writers).remove();
                delete f.writers;
            }
            this._editors = {};
            content.find('div.app-status-bar').remove();
            content.find('div[data-role="navbar"]').navbar('destroy').remove();
            content.find('ul[data-role="listview"]').listview('destroy').remove();
            content.find('div[data-role="collapsible"]').collapsible('destroy').remove();
            content.find('div[data-role="collapsible-set"]').collapsibleset('destroy').remove();
        },
        refresh: function () {
            var that = this,
                dataView = that.dataView(),
                fields = dataView._fields,
                allFields = dataView._allFields,
                categories = dataView._categories,
                content = that.content(),
                row,
                tabs = [],
                tabsScroll = [],
                activeTab,
                currentTab = '_',
                objectIdentifier,
                context = [],
                map = that.itemMap(),
                statusBarDef,
                inserting = this.inserting(),
                requiresReset = this._reset,
                editors;

            $appfactory.mobile.toolbar(dataView.get_view().Label);
            $.mobile.activePage.addClass('app-form-page');

            if (requiresReset) {
                that._dispose();
                that._commandRow = null;
                $(window).scrollTop(0);
            }
            editors = that._editors;
            row = that.commandRow() || that._initRow() || [];

            $(categories).each(function () {
                var tab = this.Tab;
                if (!String.isNullOrEmpty(tab) && tabs.indexOf(tab) == -1)
                    tabs.push(this.Tab);
            });

            if (tabs.length) {
                var footer = $('<div data-role="footer" data-position="fixed"></div>').insertAfter(content).toolbar({ tapToggle: false }),
                    navbar = $('<div data-role="navbar"><ul/></div>').appendTo(footer),
                    tabList = navbar.find('ul');
                $(tabs).each(function () {
                    var link = $('<a>').appendTo($('<li>').appendTo(tabList)).text(this);
                    if (!activeTab) {
                        activeTab = this;
                        link.addClass('ui-btn-active app-tab-active');
                    }
                });
                navbar.navbar().on('vclick', function (event) {
                    blurFocusedInput();
                    var link = $(event.target).closest('a'),
                        activeTabLink = tabList.find('.app-tab-active'),
                        activeTab = activeTabLink.text(),
                        selectedTab = link.text(),
                        selectedCollapsibleSet;

                    activeTabLink.removeClass('app-tab-active');
                    link.addClass('app-tab-active');
                    tabsScroll[tabs.indexOf(activeTab)] = selectedTab == activeTab ? 0 : $(window).scrollTop();
                    content.find('div[data-role="collapsible-set"]').each(function (index) {
                        var selected = categories[index].Tab == selectedTab,
                            category = $(this).css('display', selected ? '' : 'none');
                        if (selected)
                            category.find('textarea').textinput('refresh');

                    });
                    if (selectedTab == activeTab)
                        animatedScroll(0);
                    else
                        $(window).scrollTop(tabsScroll[tabs.indexOf(selectedTab)] || 0);
                    return false;
                });
            }

            statusBarDef = dataView.statusBar();
            if (statusBarDef) {
                var statusBar = $('<div class="app-status-bar"/>').html(statusBarDef).appendTo(content),
                    currentStatus = statusBar.find('.Current'),
                    statusWidth, statusLeft, clientWidth;
                if (currentStatus.length) {
                    statusWidth = currentStatus.outerWidth();
                    statusLeft = currentStatus.offset().left;
                    clientWidth = $(window).width();
                    if (contextSidebarIsVisible())
                        clientWidth -= $('#app-sidebar-right').outerWidth();
                    if (statusLeft + statusWidth + 20 > clientWidth) {
                        statusBar.find('ul').css('margin-left', currentStatus.is('.Last') ? -(statusLeft + statusWidth - clientWidth) - 20 : -(statusLeft - (clientWidth - statusWidth) / 2));
                    }
                }
            }

            if (dataView._showDescription != false) {
                var instruction = that.viewDescription();
                if (instruction) {
                    var descList = $('<ul data-role="listview" class="app-list-instruction"/>').appendTo(content);
                    $('<li data-role="list-divider" class="app-list-instruction"/>').appendTo(descList).html(instruction);
                    descList.listview();
                }
            }

            $(categories).each(function () {
                collapsibleSet = $('<div data-role="collapsible-set" data-content-theme="a" data-inset="false" data-mini="false"></div>').appendTo(content);
                var thatCategory = this,
                    collapsible = $('<div data-role="collapsible" data-theme="b" data-expanded-icon="carat-d" data-collapsed-icon="carat-r"></div>').appendTo(collapsibleSet),
                    description = dataView._processTemplatedText(row, thatCategory.Description),
                    descriptionText = dataView._formatViewText(resourcesViews.DefaultCategoryDescriptions[description], true, description),
                    listview,
                    firstField = true;
                if (!this.Collapsed)
                    collapsible.attr('data-collapsed', 'false');
                var collapsibleHeading = $('<h3>').appendTo(collapsible).text(thatCategory.HeaderText);
                listview = $('<ul data-role="listview" data-theme="a" data-inset="false"/>').appendTo(collapsible);
                if (!String.isNullOrEmpty(descriptionText))
                    $('<li data-role="list-divider" class="app-list-instruction"></li>').appendTo(listview).text(descriptionText);
                $(fields).each(function () {
                    var field = this,
                        originalField = field,
                        v, t;
                    if (field.CategoryIndex == thatCategory.Index) {
                        field = allFields[field.AliasIndex];
                        v = row[field.Index];
                        t = field.text(v);
                        if (currentTab != thatCategory.Tab && firstField) {
                            if (!objectIdentifier)
                                objectIdentifier = t;
                            $('<span class="dv-object-identifier"/>').text(' - ' + objectIdentifier).appendTo(collapsibleHeading).hide();
                            currentTab = thatCategory.Tab;
                            firstField = false;
                        }
                        var item = $('<li class="ui-field-contain"/>').appendTo(listview),
                            fieldLabel = $('<label class="app-static-label"/>').appendTo(item).text(field.HeaderText + (field.AllowNulls ? '' : ' *'));
                        editors[field.Name] = { field: field, originalField: originalField, item: item, label: fieldLabel, value: v, originalValue: row[originalField.Index], text: t, readers: [], writers: [] };
                    }
                });
                collapsibleSet.collapsibleset().find('ul').listview();
                if (activeTab)
                    collapsibleSet.css('display', activeTab == thatCategory.Tab ? '' : 'none');
                collapsibleSet.find('div[data-role="collapsible"]').collapsible().collapsible('option', {
                    'expand': function (event) {
                        $(event.target).find('.dv-object-identifier').hide();
                    },
                    'collapse': function (event) {
                        $(event.target).find('.dv-object-identifier').show();
                    }
                });
            });
            // render context links
            if (!inserting && !dataView.get_useCase()) {
                $appfactory.mobile.navContext(context, true);
                if (context.length) {
                    if (context[0].icon == 'back')
                        context = context.splice(1);
                    if (context) {
                        var navList = $('<ul data-role="listview" data-inset="true"/>').appendTo(content);
                        $(context).each(function () {
                            $('<a href="#"/>').appendTo($('<li>').appendTo(navList)).text(this.text).data('nav-context', this);
                        });
                        navList.listview().on('vclick', function (event) {
                            var link = $(event.target).closest('a').andSelf('a'),
                                data = link.data('nav-context');
                            activeLink(link);
                            setTimeout(function () {
                                activeLink();
                                if (data && data.callback)
                                    data.callback();
                            }, 200);
                            return false;
                        });
                    }
                }
            }
            that.stateChanged();
            that._reset = false;
        },
        collect: function () {
            var that = this,
                values = [], v,
                dataView = that.dataView(),
                allFields = dataView._allFields,
                originalRow = this.commandRow(),
                inserting = that.inserting(),
                originalValue,
                activeEditors = that._editors,
                fieldInfo;
            if (!originalRow)
                return values;
            $(allFields).each(function () {
                var field = this,
                    fieldInput = $.mobile.activePage.find('*.app-field-' + field.Name + ':input');
                if (field.OnDemand) return;
                originalValue = originalRow[field.Index];
                v = { Name: field.Name, OldValue: originalValue, NewValue: originalValue, Modified: false };
                v.ReadOnly = field.ReadOnly && !(field.IsPrimaryKey && inserting);
                /*fieldInfo = activeEditors[field.Name];
                if (fieldInfo && fieldInfo.writers.length) {
                var fieldInput = fieldInfo.writers[0];
                v.NewValue = fieldInput.is('select') ? fieldInput.find('option:selected').data('value') : fieldInput.val().trim();
                v.Modified = true;
                }
                */
                if (fieldInput.length) {
                    v.NewValue = fieldInput.is('select') ? fieldInput.find('option:selected').data('value') : fieldInput.val().trim();
                    v.Modified = true;
                }
                values.push(v);
            });
            return values;
        },
        stateChanged: function () {
            var that = this,
                dataView = that.dataView(),
                viewId = dataView._id,
                editing = that.editing(),
                inserting = that.inserting(),
                editors = that._editors,
                fieldName, v, t,
                fieldInfo, field, originalField, aliasField, fieldLabel, item,
                map = that.itemMap(), itemsStyle,
                fieldInput, inputId, inputContainer,
                fieldClass;

            function showHide(elements, show) {
                $(elements).each(function () {
                    if (show)
                        this.appendTo(fieldInfo.item);
                    else
                        this.detach();
                });
            }

            function initFieldInput() {
                inputId = viewId + '_' + field.Name + '_Input';
                fieldLabel.attr('for', inputId);
                fieldInput.appendTo(item).attr('id', inputId).addClass(fieldClass);
                if (field.Len)
                    fieldInput.attr('maxlength', field.Len);
                if (field.Watermark)
                    fieldInput.attr('placeholder', field.Watermark);
            }

            for (fieldName in editors) {
                fieldInfo = editors[fieldName];
                field = fieldInfo.field;
                originalField = fieldInfo.originalField,
                fieldLabel = fieldInfo.label;
                item = fieldInfo.item;
                v = fieldInfo.value;
                t = fieldInfo.text;
                fieldClass = 'app-field-' + field.Name;
                itemsStyle = originalField.ItemsStyle;
                if (editing && !originalField.ReadOnly && !field.OnDemand && !(itemsStyle || '').match(/CheckBoxList/)) {
                    showHide(fieldInfo.readers, false);
                    if (fieldInfo.writers.length) {
                        showHide(fieldInfo.writers, true);
                    }
                    else {
                        if (!String.isNullOrEmpty(itemsStyle)) {
                            aliasField = field;
                            field = originalField;
                            fieldClass = 'app-field-' + field.Name;
                            v = fieldInfo.originalValue;
                            if (itemsStyle == 'Lookup' || itemsStyle == 'AutoComplete') {
                                fieldInput = $('<input type="hidden"/>').val(v);
                                initFieldInput();
                                inputContainer = $('<div>').appendTo(item);
                                fieldInput.appendTo(inputContainer);
                                var dummy = $('<input type="text" class="app-lookup-input"/>').insertBefore(fieldInput)/*.appendTo($('<form>').insertBefore(fieldInput))*/.attr('id', inputId),
                                    link = $('<a href="#app-lookup" class="ui-btn ui-icon-bullets ui-btn-icon-right ui-corner-all ui-shadow app-lookup"/>').insertBefore(fieldInput)
                                    .text(t).data('data-context', { field: originalField, aliasField: aliasField, value: v, text: t, pageId: getActivePageId() });
                                if (isDesktopClient)
                                    link.attr('tabindex', -1);
                            }
                            else {
                                fieldInput = $('<select>').addClass('app-lookup');
                                $(originalField.Items).each(function () {
                                    var value = this[0],
                                        text = this[1],
                                        option = $('<option>').attr('value', value != null ? value.toString() : '').data('value', value).text(text).appendTo(fieldInput);
                                });
                                initFieldInput();
                                fieldInput.val(v != null ? v.toString() : '');
                                inputContainer = fieldInput.selectmenu();
                            }
                        }
                        else {
                            var isTextArea = field.Rows > 1;
                            fieldInput = isTextArea ? $('<textarea data-autogrow="true"/>') : $('<input type="text"/>');
                            initFieldInput();
                            fieldInput.val(v == null ? '' : t);
                            inputContainer = fieldInput.textinput();
                            if (isTextArea)
                                inputContainer.textinput('refresh');
                        }
                        fieldInfo.writers.push(inputContainer);
                    }
                }
                else {
                    fieldLabel.attr('for', '');
                    showHide(fieldInfo.writers, false);
                    if (fieldInfo.readers.length) {
                        showHide(fieldInfo.readers, true);
                    }
                    else {
                        inputContainer = $('<div class="ui-input-text ui-body-inherit ui-corner-all app-static-text"/>').appendTo(item);
                        fieldText = $('<div>').appendTo(inputContainer).addClass(fieldClass);
                        fieldInfo.readers.push(inputContainer);
                        if (field.Index == map.heading)
                            item.addClass('dv-heading');
                        if (field.OnDemand) {
                            if (!v || v.match(/^null/))
                                fieldText.text(resourcesData.NullValueInForms);
                            else {
                                var blobHref = dataView.resolveClientUrl(dataView.get_appRootPath()),
                                    blobLink = $('<a rel="external"/>').appendTo(fieldText).attr('href', String.format('{0}blob.ashx?{1}=o|{2}', blobHref, field.OnDemandHandler, t));
                                if (field.OnDemandStyle == 0) {
                                    $('<img class="app-image-thumb">').appendTo(blobLink).attr('src', String.format('{0}blob.ashx?{1}=t|{2}', blobHref, field.OnDemandHandler, t))
                                    blobLink.attr('data-content-type', 'image');
                                }
                                else {
                                    blobLink.text(resourcesData.BlobDownloadLink).addClass('ui-link ui-btn ui-btn-icon-left ui-icon-arrow-d ui-btn-inline ui-mini ui-shadow ui-corner-all').appendTo(fieldText.parent());
                                    fieldText.remove();
                                }
                            }
                        }
                        else {
                            if (field.HtmlEncode)
                                fieldText.text(t);
                            else
                                fieldText.html(t);
                            if (isPhoneField(field) && v)
                                $('<a class="ui-btn-right ui-link ui-btn ui-icon-phone ui-btn-icon-notext ui-shadow ui-corner-all app-btn" rel="external"></a>').appendTo(fieldText).attr('href', 'tel:' + v);
                            else if (isLookupField(originalField) && originalField.ItemsDataController && v && !originalField.tagged('lookup-details-hidden'))
                                $('<a href="#app-details" class="ui-btn-right ui-link ui-btn ui-icon-carat-r ui-btn-icon-notext ui-shadow ui-corner-all app-btn"></a>').appendTo(fieldText).attr('data-field-name', originalField.Name);
                        }
                    }
                    showHide(fieldInfo.writers, false);
                }
            }
            refreshContextSidebar();
        },
        context: function (list) {
            var that = this,
                dataView = that.dataView(),
                row = that.commandRow(),
                editing = that.editing();
            addSelectAction(dataView, list, row);
            if (!editing)
                enumeratePhoneContextOptions(dataView, list, row);
            enumerateActions(['Form', 'ActionBar'], dataView, list, row);
            if (editing)
                list.push({ text: resourcesForm.RequiredFiledMarkerFootnote });
        }
    }

    /* mobile alerts and confirmations */
    var alertCallback, confirmTrueCallback, confirmFalseCallback;
    Web.DataView.alert = function (message, callback) {
        alertCallback = callback;
        var alertBar = $('#app-popup-alert'),
            activePageId = getActivePageId(),
            activePopup = $('div.ui-popup-active div:first');
        if (alertBar.length == 0) {
            alertBar = $(String.format(
                '<div id="app-popup-alert" class="app-popup app-popup-alert" data-theme="a" data-overlay-theme="a" data-dismissible="false" data-history="false">' +
                '<div class="ui-header ui-bar-a" role="banner"><h1 class="ui-title" role="heading" aria-level="1">{0}</h1></div>' +
                '<div role="main" class="ui-content">' +
                '<div class="message"/><a href="#" class="ui-btn ui-corner-all ui-shadow ui-btn-b">{1}</a>' +
                '</div>' +
                '</div>',
                $appfactory.mobile.appName(), resourcesModalPopup.Close)).appendTo(body).popup(defaultPopupOptions());
            alertBar.find('a').on('vclick', function (e) {
                if (activePopup.length) {
                    popupCloseCallback = function () {
                        activePopup.popup('open');
                    }
                    popupOpenCallback = alertCallback;
                }
                else
                    popupCloseCallback = alertCallback;
                activeLink(this);
                setTimeout(function () {
                    alertBar.popup('close');
                }, 200);
                return false;
            });
        }
        var messageElem = alertBar.find('.message');
        if (message.match(/<\w+/))
            messageElem.html(message);
        else
            messageElem.text(message);
        function showAlert() {
            alertBar.popup('open');
        }
        if (activePopup.length) {
            popupCloseCallback = showAlert;
            activePopup.popup('close');
        }
        else
            showAlert();
    }

    Web.DataView.confirm = function (message, trueCallback, falseCallback) {
        confirmTrueCallback = trueCallback;
        confirmFalseCallback = falseCallback;
        var confirmBar = $('#app-popup-confirm'),
            activePageId = getActivePageId(),
            activePopup = $('div.ui-popup-active div:first');
        if (confirmBar.length == 0) {
            confirmBar = $(String.format(
                '<div id="app-popup-confirm" class="app-popup app-popup-confirm" data-role="popup" data-theme="a" data-overlay-theme="a" data-dismissible="false" data-history="false">' +
                '<div class="ui-header ui-bar-a" role="banner"><h1 class="ui-title" role="heading" arial-level="1">{0}</h1></div>' +
                '<div role="main" class="ui-content"><div class="message"/><div class="ui-grid-a"><div class="ui-block-a"><a href="#" class="confirm-button ui-btn ui-corner-all ui-shadow ui-btn-b">{1}</a></div><div class="ui-block-b"><a href="#" class="ui-btn ui-corner-all ui-shadow ui-btn-b">{2}</a></div></div></div>' +
                '</div>',
                $appfactory.mobile.appName(), resourcesModalPopup.OkButton, resourcesModalPopup.CancelButton)).appendTo(body).popup(defaultPopupOptions());
            confirmBar.find('a').on('vclick', function (event) {
                var confirmed = $(event.target).is('.confirm-button');
                if (activePopup.length) {
                    popupCloseCallback = function () {
                        activePopup.popup('open');
                        popupOpenCallback = confirmed ? confirmTrueCallback : confirmFalseCallback;
                    }
                }
                else
                    popupCloseCallback = confirmed ? confirmTrueCallback : confirmFalseCallback;
                activeLink(this);
                setTimeout(function () {
                    activeLink();
                    confirmBar.popup('close');
                }, 200);
                return false;
            });
        }
        var messageElem = confirmBar.find('.message');
        if (message.match(/<\w+/))
            messageElem.html(message);
        else
            messageElem.text(message);
        function showConfirm() {
            confirmBar.popup('open');
        }
        if (activePopup.length) {
            popupCloseCallback = showConfirm;
            activePopup.popup('close');
        }
        else
            showConfirm();
    }

    $appfactory.showMessage = function (message) {
        if (message)
            this.alert(message);
    }


    /* menu */

    Web.Menu.headerIterators = [];
    Web.Menu.footerIterators = [];

    Web.Menu.prototype.initialize = function () {
        Web.Menu.callBaseMethod(this, 'initialize');
    };

    Web.Menu.prototype.dispose = function () {
    };

    Web.Menu.prototype.updated = function () {
        Web.Menu.callBaseMethod(this, 'updated');
        if ($appfactory.mobile)
            this.mobileUpdated();
    };

    Web.Menu.prototype.mobileUpdated = function () {
        if (!Web.Menu.MainMenuId) {
            Web.Menu.MainMenuId = this.get_id();
            Web.Menu.MainMenuElemId = this._element.id;
        }
        var nodes = this.get_nodes(),
            mobile = $appfactory.mobile;
        if (!nodes) return;

        var contextButton = $('a#app-btn-context').on('vclick', function () {
            activeLink(contextButton);
            setTimeout(function () {
                getContextPanel('#app-panel-context', function () {
                    mobile.refreshContext('#app-panel-context');
                }).panel('toggle');
            }, 200);
            return false;
        });


        var menuButton = $('a#app-btn-menu'),
            menuPanel,
            activePanel;
        menuButton.on('vclick', function (e) {
            activeLink(menuButton);
            blurFocusedInput();
            if (menuButton.attr('href') == '#app-back') {
                e.preventDefault();
                e.stopPropagation();
                setTimeout(function () {
                    history.back();
                    activeLink();
                }, 200);
                return false;
            }

            function toggleActivePanel(delay) {
                setTimeout(function () {
                    activeLink();
                    activePanel.panel('toggle');
                }, delay);
            }

            if (!menuPanel) {
                setTimeout(function () {
                    activeLink();
                    var page = $('div[data-role="page"]');
                    var panelList = $();
                    menuPanel = $('<div id="AppMenuPanel" data-role="panel" data-position="left" data-position-fixed="true" data-display="overlay" data-theme="b" class="app-nav-panel"/>').appendTo(body);
                    var leftList = $('<ul data-role="listview"><li data-icon="delete" data-theme="b"><a href="#"></a></li><li data-role="list-divider" data-theme="a" class="app-info"><i><h5 class="appname"></h5></i><p class="welcome"></p></li></ul>').appendTo(menuPanel);
                    $('<div class="app-menu-footer"/>').appendTo(menuPanel);
                    var closeButton = leftList.find('a:first').html(resourcesModalPopup.Close).on('vclick', function () {
                        activeLink(closeButton);
                        setTimeout(function () {
                            menuPanel.panel('close');
                        }, 200);
                    });
                    var appInfo = menuPanel.find('li[data-role="list-divider"]')
                    appInfo.find('.appname').text(mobile.appName());
                    var headerIterators = Web.Menu.headerIterators;
                    var footerIterators = Web.Menu.footerIterators;
                    if (headerIterators.length == 0)
                        appInfo.find('.welcome').hide();
                    else
                        $(headerIterators).each(function () {
                            this.call(appInfo);
                        });

                    var nodes = $find(Web.Menu.MainMenuId).get_nodes();
                    (function populateMenuLevel(nodes, parentNode, panel, list, depth) {
                        var levelClass = 'level' + depth;
                        panel.addClass(levelClass);
                        list.addClass(levelClass);
                        panelList = panelList.add(panel);
                        $(nodes).each(function (index) {
                            var url = this.url;
                            if (this.children) {
                                var parentPanelId = panel.attr('id');
                                var childPanelId = parentPanelId + '-' + index;
                                var originalUrl = url;
                                url = '#' + childPanelId;
                                var childPanel = $('<div data-role="panel" data-position="left" data-position-fixed="true" data-theme="b" data-display="overlay" class="app-nav-panel"/>').appendTo(body).attr('id', childPanelId);
                                var childList = $('<ul data-role="listview" data-theme="b"/>').appendTo(childPanel);
                                $('<div class="app-menu-footer"/>').appendTo(childPanel);
                                $('<a>').appendTo($('<li data-icon="arrow-u" data-theme="b"/>').appendTo(childList)).attr('href', '#' + parentPanelId).text(resourcesMobile.UpOneLevel);
                                $('<a rel="external"/>').appendTo(
                                    $('<li>').appendTo(childList).attr('data-theme', this.selected ? 'a' : 'b')
                                    ).attr('href', originalUrl).text(this.title);
                                $('<li data-role="list-divider" data-theme="b"></li>').appendTo(childList);
                                if (this.selected && !activePanel)
                                    activePanel = childPanel;
                                populateMenuLevel(this.children, this, childPanel, childList, depth + 1);
                            }
                            if (this.selected && !activePanel)
                                activePanel = panel;
                            if (parentNode && this.selected)
                                parentNode.selected = true;
                            var link = $('<a rel="external"/>').appendTo(
                                $('<li>').appendTo(list).attr({
                                    'data-icon': this.children ? 'bars' : '',
                                    'class': this.children ? 'menu-item menu-parent' : 'menu-item',
                                    'data-theme': this.selected ? 'a' : 'b'
                                })
                                ).attr({ href: url, title: this.description }).text(this.title);

                        });
                    })(nodes, null, menuPanel, leftList, 0);
                    var lists = panelList.find('ul').each(function () {
                        var ul = this;
                        $(footerIterators).each(function () {
                            this.call(ul);
                        });
                    });
                    lists.listview().on('vclick', 'a[rel="external"]', function (event) {
                        if (touchMoveIsCanceled())
                            return false;
                        var link = $(event.target),
                            href = link.attr('href');
                        if (href && href.match(/#/))
                            return;
                        if (!skipMenuActionOnClose)
                            activeLink(link);
                        menuActionOnClose = function () {
                            setTimeout(function () {
                                window.location.href = href;
                            }, 200);
                        }
                        closeActivePanel();
                        return false;
                    }).on('swipe', function () {
                        skipMenuActionOnClose = true;
                    }).on('vmousescroll', function () {
                    });
                    var sidebarOverflow;
                    menuPanel = panelList.panel({
                        beforeopen: function (event, ui) {
                            mobile.pageScrolling(false);
                        },
                        open: function () {
                            activePanel = $(this);
                        },
                        beforeclose: function () {
                        },
                        close: function () {
                            mobile.pageScrolling(true);
                            if (!skipMenuActionOnClose && menuActionOnClose)
                                menuActionOnClose();
                            menuActionOnClose = null;
                            skipMenuActionOnClose = false;
                        }
                    });
                    if (!activePanel)
                        activePanel = panelList.slice(0, 1);
                    toggleActivePanel(100);
                }, 200);
            }
            else
                toggleActivePanel(200);
            return false;
        });

        $('div[data-app-role="sitemap"]').attr('class', 'app-site-map').each(function () {
            var siteMap = $(this),
                list = $('<ul>').appendTo(siteMap).attr('data-inset', 'false'),
                isLoggedIn = membership && membership.loggedIn();
            function addLoginStatus() {
                var link = $('<li><a href="#"/></li>').appendTo(list).find('a');
                if ($('#app-welcome').length && !isLoggedIn)
                    link.attr('href', '#app-welcome').text(resourcesMembershipBar.LoginButton);
                else
                    membership.loginStatus(link);
            }
            if (membership && !isLoggedIn)
                addLoginStatus();
            (function BuildHierarchy(level, list, depth) {
                $(level).each(function () {
                    var item = $('<li>').appendTo(list).addClass('depth' + depth);
                    if (this.url)
                        $('<a>').appendTo(item).attr({ 'href': this.url, 'rel': 'external' }).text(this.title);
                    else
                        $('<span>').appendTo(item).text(this.title);
                    if (this.children)
                        BuildHierarchy(this.children, list/* $('<ul>').appendTo(item)*/, depth + 1);

                });
            })(nodes, list, 1);
            if (membership && isLoggedIn)
                addLoginStatus();
            list.listview().on('vclick', 'a[rel="external"]', function (event) {
                var link = $(event.target);
                activeLink(link);
                setTimeout(function () {
                    window.location.href = link.attr('href');
                }, 200);
                return false;
            });
        });
    }

    /* membership bar */

    if (typeof Web.Membership != 'undefined') {

        Web.Membership.prototype.initialize = function () {
            var that = this;
            var authenticationEnabled = that.get_authenticationEnabled();
            var displayMyAccount = that.get_displayMyAccount();
            var loggedIn = that.loggedIn();
            Web.Menu.headerIterators.push(function () {
                var parentList = $(this).closest('ul');
                // initialize the language selector
                var cultures = that.get_cultures();
                if (!String.isNullOrEmpty(cultures) && !(__tf != 4)) {
                    var selectedCulture = { value: 'Detect,Detect', text: resourcesMembershipBar.AutoDetectLanguageOption, selected: false };
                    var cultureList = [selectedCulture];
                    var selected = null;
                    $(cultures.split(/;/)).each(function () {
                        if (this.length) {
                            var info = this.split('|');
                            var culture = { value: info[0], text: info[1], selected: info[2] == 'True' };
                            cultureList.push(culture);
                            if (culture.selected)
                                selectedCulture = culture;
                        }
                    });
                    var languageItem = $(String.format('<li data-icon="location" data-theme="b"><a href="#" rel="external">{0}</a></li>', selectedCulture.text)).appendTo(parentList)
                        .on('vclick', function () {
                            if (touchMoveIsCanceled())
                                return false;
                            if (!skipMenuActionOnClose)
                                activeLink(languageItem);
                            menuActionOnClose = function () {
                                var languagePage = $('#LanguageSelectorPage');
                                if (languagePage.length == 0) {
                                    languagePage = $(String.format(
                                        '<div id="LanguageSelectorPage" data-role="page" data-app-toolbar="false"><div data-role="header" data-position="fixed"><a href="#app-back" data-icon="back" data-iconpos="notext"></a><h1>{0}</h1></div><div data-role="content"><ul data-role="listview" data-inset="false"></ul></div></div>',
                                        resourcesMembershipBar.ChangeLanguageToolTip)).appendTo(body);
                                    var list = languagePage.find('ul');
                                    $(cultureList).each(function () {
                                        var culture = this;
                                        var cultureItem = $(String.format('<li{1}><a href="#">{0}</a></li>', culture.text, culture.selected ? ' data-theme="b"' : '')).appendTo(list);
                                        cultureItem.on('vclick', function () {
                                            activeLink(cultureItem);
                                            setTimeout(function () {
                                                that.changeCulture(culture.value);
                                            }, 200);
                                        });
                                    });
                                }
                                $.mobile.changePage('#LanguageSelectorPage', { changeHash: true });
                            }
                            closeActivePanel();
                            return false;
                        });
                }
                // update the welcome message and create Login link when needed
                var welcomePlacehoder = this.find('.welcome');
                if (loggedIn) {
                    var welcome = that.get_welcome();
                    if (String.isNullOrEmpty(welcome))
                        welcomePlacehoder.hide();
                    else
                        welcomePlacehoder.html(String.localeFormat(welcome, that.get_user(), new Date()));
                }
                else {
                    welcomePlacehoder.hide();
                    var loginItem = $(String.format('<li data-icon="lock" data-theme="b"><a>{0}</a></li>', resourcesMembershipBar.LoginLink)).appendTo(parentList);
                    loginItem.on('vclick', function () {
                        if (!skipMenuActionOnClose)
                            activeLink(loginItem);
                        menuActionOnClose = function () {
                            that.showLogin();
                        }
                        closeActivePanel();
                    });
                    $('<li data-role="list-divider" data-theme="b"></li>').appendTo(parentList);
                }
            });
            if (loggedIn && (displayMyAccount || authenticationEnabled))
                Web.Menu.footerIterators.push(function (depth) {
                    $('<li data-role="list-divider" data-theme="b"/>').appendTo(this);
                    if (displayMyAccount && $(this).is('.level0'))
                        $(String.format('<li>{0}</li>', resourcesMembershipBar.MyAccount)).appendTo(this);
                    if (authenticationEnabled) {
                        var logoutItem = $(String.format('<li data-icon="power" data-theme="b"><a>{0}</a></li>', resourcesMembershipBar.LogoutLink)).appendTo(this);
                        logoutItem.on('vclick', function () {
                            if (touchMoveIsCanceled())
                                return false;
                            if (!skipMenuActionOnClose)
                                activeLink(logoutItem);
                            menuActionOnClose = function () {
                                $.mobile.loading('show');
                                halt();
                                that.logout();
                            }
                            closeActivePanel();
                        });
                    }
                });
        };

        Web.Membership.prototype.dispose = function () {
        };

        Web.Membership.prototype.updated = function () {
            membership = this;
            userActivity();
            if (this.get_idleTimeout())
                $(document).on('appawake', function (event) {
                    return !membership.idle();
                });
            this.idleInterval(true);
            if ($appfactory.mobile)
                this.mobileUpdated();
        };

        Web.Membership.prototype._idle = function () {
            blurFocusedInput();
            var that = this;
            that.idleInterval(false);
            $appfactory.alert(resourcesMembershipBar.UserIdle, function () {
                halt();
                that.logout();
            });
        };

        Web.Membership.prototype.loginStatus = function (selector) {
            var that = this,
                loggedIn = that.loggedIn(),
                loginStatus = $(selector).text(loggedIn ? resourcesMembershipBar.LogoutLink : resourcesMembershipBar.LoginLink).on('vclick', function (e) {
                    activeLink(loginStatus);
                    setTimeout(function () {
                        activeLink();
                        if (loggedIn) {
                            halt();
                            that.logout();
                        }
                        else
                            that.showLogin();
                    }, 200);
                    e.preventDefault();
                    return false;
                });
        }

        Web.Membership.prototype.mobileUpdated = function () {
            // alert('updated');
            var that = this,
                loggedIn = that.loggedIn();
            if (!loggedIn && location.href.match(/(\?|&)ReturnUrl=/))
                setTimeout(function () {
                    that.showLogin()
                }, 500);
            this.loginStatus('a[data-app-role="loginstatus"]');
        };
        Web.Membership.prototype.showLogin = function () {
            var loginDialog = this._loginDialog;
            if (!loginDialog) {
                this._login_CompletedHandler = Function.createDelegate(this, this._login_Completed);
                this._method_FailureHandler = Function.createDelegate(this, this._method_Failure);
                loginDialog = this._loginDialog = $(String.format(
                    '<div id="app-popup-login" data-role="popup" data-theme="a" data-overlay-theme="a" class="app-popup app-popup-login">' +
                    '<div role="banner" class="ui-header ui-bar-a"><h1 class="ui-title" role="heading" aria-level="1">{6}</h1></div>' +
                    '<div role="main" class="ui-content">' +
                    '<div>{1} {2}</div><input type="text" id="UserName" placeholder="{3}"/><input type="password" id="Password" placeholder="{4}"/>{5}' +
                    '<a href="#" class="login-button ui-btn ui-corner-all ui-shadow ui-btn-b">{7}</a>' +
                    '</div></div>',
                        resourcesMembershipBar.HelpCloseButton, resourcesMembershipBar.LoginLink, resourcesMembershipBar.LoginText, resourcesMembershipBar.UserName.replace(/:/, ''), resourcesMembershipBar.Password.replace(/:/, ''),
                        this.get_displayRememberMe() ? String.format('<label for="RememberMe"><input type="checkbox" id="RememberMe" />{0}</label>', resourcesMembershipBar.RememberMe) : '',
                        $appfactory.mobile.appName(), resourcesMembershipBar.LoginButton)
                       ).appendTo(body).popup(defaultPopupOptions());
                var that = this;
                this._userName = loginDialog.find('input:text').textinput().get(0);
                this._password = loginDialog.find('input:password').textinput().get(0);
                this._rememberMe = loginDialog.find('input:checkbox').checkboxradio().get(0);
                var loginButton = loginDialog.find('a.login-button').on('vclick', function () {
                    activeLink(loginButton);
                    setTimeout(function () {
                        that.login();
                    }, 200);
                    return false;
                });
                loginDialog.find('input').on('keydown', function (event) {
                    if (event.which == 13) {
                        loginButton.trigger('vclick');
                        return false;
                    }
                });
            }
            loginDialog.popup('open');
        };

    };

    Web.Mobile = function () {
        this._pageMap = {};
        this._pages = [];
        this._toolbar = $('#app-bar-tools');
        this._title = this._toolbar.find('h1');
        this._infoBar = $('#app-bar-info');
        this._filterBar = $('#app-bar-filter');
        this._headingBar = $('#app-bar-heading');
        this._modalDataViews = [];
        this._modalStack = [];
    }

    Web.Mobile.prototype = {
        appName: function () {
            return $('#PageHeaderBar').text();
        },
        height: function () {
            var height = $(window).height();
            if (navigator.userAgent.match(/Mobile.+Safari/) && !navigator.userAgent.match(/Chrome/))
                height += 60;
            return height;
        },
        page: function (id) {
            if (!id)
                id = 'Main';
            var p = $('#' + id);
            if (p.length == 0)
                p = $(String.format('<div data-role="page" id="{0}"><div data-role="content"></div></div>', id)).appendTo(body).page();
            return p;
        },
        activeLink: function (elem, autoRemove) {
            $.mobile.removeActiveLinkClass(true);
            if (elem) {
                elem = $(elem);
                if (!elem.is('a'))
                    elem = elem.find('a:first');
                elem.addClass('ui-btn-active');
                if (autoRemove == null || autoRemove)
                    $.mobile.activeClickedLink = elem;
            }
        },
        blink: function (elem, callback) {
            activeLink(elem);
            setTimeout(function () {
                activeLink();
                setTimeout(function () {
                    activeLink(elem);
                    setTimeout(function () {
                        activeLink();
                        if (callback)
                            callback();
                    }, 200);
                }, 200);
            }, 200);
        },
        content: function (id) {
            var p = this.page(id);
            return p.find('div[data-role="content"]');
        },
        dataView: function () {
            var pageInfo = this.pageInfo();
            return pageInfo ? pageInfo.dataView : null;
        },
        pageInfo: function (value) {
            if (!value)
                value = getActivePageId();
            else
                if (value.selector != null && value.length != null)
                    value = value.attr('id') || '';
            if (typeof value == 'string')
                return this._pageMap[value];
            else {
                this._pageMap[value.id] = value;
                this._pages.push(value);
            }
        },
        toolbar: function (value) {
            if (typeof value == 'boolean') {
                if (value)
                    this._toolbar.show();
                else
                    this._toolbar.hide();
                $.mobile.resetActivePageHeight();
            }
            else if (typeof value == 'string')
                this._title.text(value);
            return this._toolbar;
        },
        search: function (value) {
            var searchText = this._searchText;
            if (!searchText || !searchText.length)
                searchText = this._searchText = $('#app-text-search');
            if (value != null) {
                if (typeof value == 'object') {
                    if (value.placeholder)
                        searchText.attr('placeholder', value.placeholder);
                    if (value.text != null) {
                        searchText.val(value.text);
                        var cancelButton = searchText.parent().find('a');
                        if (value.text)
                            cancelButton.removeClass('ui-input-clear-hidden');
                        else
                            cancelButton.addClass('ui-input-clear-hidden');
                    }
                    if (value.focus)
                        searchText.focus();
                }
                else if (typeof value == 'string')
                    searchText.val(value);
            }
            else
                return searchText.val();

        },
        infoBar: function () {
            return this._infoBar;
        },
        headingBar: function () {
            return this._headingBar;
        },
        filterBar: function () {
            return this._filterBar;
        },
        infoView: function (dataView, standalone) {
            var context = [{ text: standalone ? resourcesModalPopup.Close : resourcesMobile.Back, callback: standalone ? function () { } : backToContextPanel, icon: standalone ? 'delete' : 'back'}];
            while (dataView) {
                var row = dataView.extension().commandRow();
                context.push({ text: dataView.get_view().Label, theme: 'b', 'static': true });
                $(dataView._fields).each(function () {
                    var field = dataView._allFields[this.AliasIndex];
                    if (!field.Hidden && !field.OnDemand) {
                        v = field.text(row[field.Index]);
                        if (isPhoneField(field))
                            context.push({ text: v, desc: field.HeaderText, href: 'tel:' + v, icon: 'phone' });
                        else
                            context.push({ text: v, desc: field.HeaderText, 'static': true });
                    }
                });
                dataView = $appfactory.find(dataView._filterSource);
            }
            currentContext = context;
            showContextPanel('#app-panel-info-view');
        },
        modalDataView: function (id) {
            var that = this;
            if (!id) {
                $(that._modalStack).each(function (index) {
                    var pageInfo = this,
                        page = $('#' + pageInfo.id),
                        dataView = pageInfo.dataView;
                    dataView.dispose();
                    page.page('destroy').remove();
                    var index = that._modalDataViews.indexOf(pageInfo.id);
                    that._modalDataViews.splice(index, 1);
                    index = that._pages.indexOf(pageInfo);
                    that._pages.splice(index, 1);

                });
                that._modalStack = [];
            }
            else {
                var pageInfo = that.pageInfo(id),
                    page = that.page(id);
                if (!pageInfo.dataView._lookupInfo) {
                    if (!page.is('app-modal-page'))
                        page.addClass('app-modal-page app-form-page');
                    pageInfo.dataView._isModal = true;
                }
                that._modalDataViews.push(id);
                that.changePage(id);
            }
        },
        unloadPage: function (page, activePage) {
            var pageInfo = this.pageInfo(page),
                index;
            if (pageInfo) {
                index = this._modalDataViews.indexOf(pageInfo.id);
                if (index >= 0) {
                    var dataView = pageInfo.dataView,
                        masterView = $appfactory.find(dataView._parentDataViewId),
                        activePageInfo = this.pageInfo(activePage);
                    if (activePageInfo && masterView == activePageInfo.dataView || activePage.attr('id') == 'Main') {
                        if (this._modalStack.indexOf(pageInfo) == -1)
                            this._modalStack.push(pageInfo);
                    }
                }
            }
        },
        changePage: function (id, changeHash) {
            var activePageInfo = $appfactory.mobile.pageInfo();
            if (activePageInfo)
                activePageInfo.scrollTop = $(window).scrollTop();
            this.page(id)
            $.mobile.changePage('#' + id, {
                'changeHash': !(changeHash == false), transition: 'none'
            });
        },
        title: function () {
            var id = getActivePageId(),
                pageInfo = this.pageInfo(id),
                dataView = pageInfo && pageInfo.dataView,
                title = document.title;
            if (pageInfo && pageInfo.text != title)
                title = String.format('{0} - {1}', pageInfo.text, title);
            return title;
        },
        pageScrolling: function (enable) {
            var scrollLock = this._scrollLock || 0,
                sidebar = contextSidebar(),
                lastAdjustment = sidebar.data('lastAdjustment');
            scrollLock += enable ? -1 : 1;
            this._scrollLock = scrollLock;
            if (!(enable && scrollLock == 0 || !enable && scrollLock == 1)) return;

            if (isDesktopClient && !enable && !verticalScrollbarWidth)
                verticalScrollbarWidth = -$(window).width();
            body.css('overflow', enable ? 'auto' : 'hidden')
            if (isDesktopClient && !enable && verticalScrollbarWidth < 0)
                verticalScrollbarWidth += $(window).width();
            if (isDesktopClient) {
                var barSelector = '.ui-header.ui-header-fixed,.ui-footer.ui-footer-fixed,.app-bar-heading',
                    contentSelector = '.ui-content,.app-listview',
                    docIsScrollable = documentIsScrollable();
                if (contextSidebarIsVisible()) {
                    var sidebarWidthAdjustment = docIsScrollable ? verticalScrollbarWidth : 0;
                    if (enable) {
                        if (lastAdjustment)
                            sidebar.width(sidebar.width() - lastAdjustment).data('lastAdjustment', null);
                        sidebar.css('overflow-y', '');
                        $.mobile.activePage.find(contentSelector).css('margin-right', '');
                        body.find(barSelector).css('right', '').width('auto');
                        if (!docIsScrollable) {
                            $('html').css('overflow-y', contextSidebarIsScrollable() ? 'hidden' : 'scroll');
                        }
                    }
                    else {
                        if (lastAdjustment)
                            sidebar.width(sidebar.width() - lastAdjustment);
                        if (!docIsScrollable) {
                            $('html').css('overflow-y', 'hidden');
                        }
                        var newSidebarWidth = sidebar.width() + sidebarWidthAdjustment;
                        if (docIsScrollable)
                            sidebar.width(newSidebarWidth).data('lastAdjustment', sidebarWidthAdjustment).css('margin-right', '');
                        $.mobile.activePage.find(contentSelector).css('margin-right', newSidebarWidth);
                        body.find(barSelector).css('right', newSidebarWidth).width('auto');
                    }
                }
                else {
                    if (enable) {
                        $.mobile.activePage.find(contentSelector).css('margin-right', '');
                        body.find(barSelector).css('right', '').width('');
                        if (!docIsScrollable)
                            $('html').css('overflow-y', 'scroll');
                    }
                    else {
                        $.mobile.activePage.find(contentSelector).css('margin-right', verticalScrollbarWidth);
                        body.find(barSelector).css('right', verticalScrollbarWidth).width('auto');
                        if (!docIsScrollable)
                            $('html').css('overflow-y', 'hidden');
                    }
                }
            }
            var that = this;
            if (enable)
                body.off('touchmove touchstart');
            else
                body.on('touchstart', function (e) {
                    var touch = e.originalEvent.touches[0] || e.originalEvent.changedTouches[0];
                    that._startClientY = touch.clientY;
                    touchMovePrevented = false;
                }).on('touchmove', function (e) {
                    touchMovePrevented = false;
                    var touchedPanel = $(e.target).closest('.ui-panel'),
                        preventTouch = touchedPanel.length == 0;
                    if (!preventTouch) {
                        var listview = touchedPanel.find('ul'),
                            menuFooter = touchedPanel.find('div.app-menu-footer'),
                            listviewHeight = listview.height() + (menuFooter.length ? menuFooter.outerHeight() : 0),
                            touchedPanelHeight = touchedPanel.height(),
                            touch = e.originalEvent.touches[0] || e.originalEvent.changedTouches[0],
                            clientY = touch ? touch.clientY : -1,
                            panelScrollTop = listview.parent().scrollTop();
                        if (listviewHeight <= touchedPanelHeight)
                            preventTouch = true;
                        else {
                            if (listviewHeight - panelScrollTop <= touchedPanelHeight) {
                                if (that._startClientY > clientY)
                                    preventTouch = true;
                            }
                            else if (panelScrollTop == 0) {
                                if (that._startClientY < clientY)
                                    preventTouch = true;
                            }
                        }
                    }
                    if (preventTouch) {
                        touchMovePrevented = true;
                        return false;
                    }
                });
        },
        navContext: function (context, childrenOnly) {
            var that = this,
                activePageInfo = that.pageInfo(),
                rootPageInfo = activePageInfo,
                activeDataView = activePageInfo && activePageInfo.dataView,
                rootDataView = activeDataView,
                rootExtension = rootDataView && rootDataView.extension(),
                activeUseCase = activeDataView && activeDataView.get_useCase(),
                activeExtension = activeDataView && activeDataView.extension(),
                firstNavOption = true,
                backInHistory = -1;
            // enumerate data view context options
            if (activeExtension) {
                if (!childrenOnly)
                    if (activeExtension)
                        activeExtension.context(context);
                if (activePageInfo.dataView._parentDataViewId) {
                    activePageInfo = that.pageInfo(activePageInfo.dataView._parentDataViewId);
                    activeDataView = activePageInfo.dataView;
                    backInHistory--;
                }
            }
            if (rootExtension && !rootExtension.inserting() && !rootExtension.lookupInfo())
                $(this._pages).each(function (index) {
                    var pageInfo = this,
                        pageDataView = pageInfo.dataView,
                        pageExtension = pageDataView.extension(),
                        allowNavigate = true,
                        master = false;
                    if (pageDataView) {
                        allowNavigate = !pageDataView._hidden && !pageDataView._parentDataViewId;
                        if (allowNavigate) {
                            if (activeDataView && activeDataView._filterSource) {
                                allowNavigate = $appfactory.find(activeDataView._filterSource) == pageDataView;
                                master = allowNavigate;
                                if (!allowNavigate)
                                    allowNavigate = $appfactory.find(pageDataView._filterSource) == activeDataView;
                            }
                            else if (pageDataView._filterSource)
                                allowNavigate = $appfactory.find(pageDataView._filterSource) == activeDataView;
                            else
                                allowNavigate = !pageDataView._filterSource && pageDataView != activeDataView && !childrenOnly;
                        }
                    }
                    if (allowNavigate && !activeUseCase) {
                        if (firstNavOption) {
                            if (!childrenOnly)
                                context.push({});
                            firstNavOption = false;
                        }
                        context.push({
                            text: master ? that.infoBar().find('.app-item-heading').text() : this.text, desc: master ? this.text : null, icon: master ? 'back' : null, /*dataRel: master ? 'back' : null,*/
                            count: master ? null : (pageExtension && !pageExtension._reset ? pageDataView._totalRowCount : null),
                            callback: master ?
                                function () {
                                    window.history.go(backInHistory);
                                } :
                                function () {
                                    that.changePage(pageInfo.id);
                                }
                        });
                    }
                });
            if (!childrenOnly && (contextSidebarIsVisible() || sidebarIsUndocked)) {
                context.push({});
                context.push({
                    text: sidebarIsUndocked ? resourcesMobile.Dock : resourcesMobile.Undock, toolbar: false, icon: sidebarIsUndocked ? 'arrow-l' : 'arrow-r', callback: function () {
                        toggleContextSidebar(!sidebarIsUndocked);
                        refreshContextSidebar();
                        if (isDesktopClient) {
                            contextSidebar().width('').trigger('vmouseout');

                            //resetPageLayout();
                        }
                    }
                });
            }
        },
        refreshAppButtons: function (context) {
            var that = this,
                titleRight = that._title.offset().left + that._title.outerWidth() - 1,
                btn, icon, toolbar,
                visibleButtons = [], numberOfVisibleButtons,
                icons = [],
                hasCall, hasRefresh, hasEye,
                dataView = $appfactory.mobile.dataView(),
                hasSearch = dataView && dataView.get_isGrid() && dataView.get_showQuickFind(),
                firstVisibleButton = 0;
            that.toolbar().find('.app-btn').each(function () {
                btn = $(this);
                btn.show();
                if (btn.offset().left > titleRight) {
                    visibleButtons.push(btn);
                }
                else
                    btn.hide();
            });
            numberOfVisibleButtons = visibleButtons.length;
            if (numberOfVisibleButtons > 0) {
                $(context).each(function () {
                    icon = this.icon;
                    showOnToolbar = this.toolbar != false && icon != 'bars' && icon != 'back';
                    if (icon) {
                        if (icon == 'refresh')
                            hasRefresh = true;
                        else if (icon == 'phone')
                            hasCall = true;
                        else if (icon == 'eye' && showOnToolbar)
                            hasEye = true;
                        else if (showOnToolbar && icons.indexOf(icon) == -1)
                            icons.push(icon);
                    }
                });
                if (hasCall)
                    icons.push('phone');
                if (hasEye)
                    icons.push('eye');
                if (hasRefresh)
                    icons.push('refresh');
                if (hasSearch)
                    if (icons.length < numberOfVisibleButtons)
                        icons.push('search');
                    else
                        icons[numberOfVisibleButtons - 1] = 'search';
                if (icons.length < numberOfVisibleButtons)
                    firstVisibleButton = numberOfVisibleButtons - icons.length;
                for (i = 0; i < firstVisibleButton; i++)
                    $(visibleButtons[i]).hide();
                while (i < numberOfVisibleButtons) {
                    btn = $(visibleButtons[i]);
                    icon = icons[i - firstVisibleButton];
                    var lastIcon = btn.data('icon');
                    btn.removeClass('ui-icon-' + lastIcon).addClass('ui-icon-' + icon).data('icon', icon);
                    i++;
                }
                if (dataView && dataView.get_searchOnStart()) {
                    dataView.set_searchOnStart(false);
                    $('.app-btn.ui-icon-search').trigger('vclick');
                }
            }
        },
        refreshContext: function (selector, context) {
            var that = this,
                panel = $(selector),
                listview = panel.find('ul'),
                listviewHeight = iOS ? listview.outerHeight() : 0,
                listviewStub,
                lastItemIsSeparator = false;

            if (!listview.length || panel.is('.app-sidebar-right:not(:visible)')) {
                context = [];
                that.navContext(context);
                that.refreshAppButtons(context);
                return;
            }

            listview.find('a').data('context-action', null);
            if (listviewHeight)
                listviewStub = $('<div>').height(listviewHeight).insertAfter(listview);
            listview.find("li").remove();

            if (!context) {
                context = [];
                that.navContext(context);
            }
            // update context listview
            $(context).each(function () {
                var item = $('<li></li>')
                    .attr({
                        'data-icon': this.icon,
                        'data-theme': this.theme || 'a'
                    }).appendTo(listview),
                    link,
                    isSeparator = false,
                    separator;
                if (this.callback || this.dataRel) {
                    link = $('<a href="#"></a>').appendTo(item).text(this.text).data('context-action', this);
                    if (this.count != null)
                        $('<span class="ui-li-count"></span>').appendTo(link).text(this.count);
                    if (this.dataRel)
                        link.attr('data-rel', this.dataRel);
                }
                else if (this.href) {
                    item.attr('data-icon', this.icon);
                    link = $('<a href="#" rel="external"></a>').appendTo(item).text(this.text).data('context-action', this).attr('href', this.href);
                }
                else if (this.static)
                    item.html(this.text);
                else {
                    if (lastItemIsSeparator)
                        item.remove();
                    else {
                        separator = item.attr('data-role', 'list-divider').html(this.text);
                        if (!this.static)
                            separator.addClass('app-list-instruction');
                    }
                    lastItemIsSeparator = true;
                    isSeparator = true;
                }
                if (!isSeparator)
                    lastItemIsSeparator = false;
                if (this.desc)
                    $('<p class="app-item-desc"></p>').appendTo(link ? link : item).text(this.desc);
                if (this.disabled)
                    item.addClass('ui-disabled');
            });
            listview.listview('refresh');
            restorePanelScrollTop(panel);
            if (listviewStub)
                listviewStub.remove();
            if (panel.is('#app-sidebar-right'))
                that.refreshAppButtons(context);
        },
        filterStatus: function () {
            var filterBar = this.filterBar().hide(),
                pageInfo = this.pageInfo(),
                dataView = pageInfo.dataView,
                extension = dataView && dataView.extension(),
                filter = dataView ? dataView.get_filter() : null;
            if (dataView && filter.length > 0 && !dataView.filterIsExternal() && extension && extension.options().filterDetails) {
                var filterBarLink = filterBar.find('a'),
                    sb = new Sys.StringBuilder();
                filterBarLink.children().remove();
                dataView._renderFilterDetails(sb, filter);

                $('<span>').appendTo(filterBarLink).html(sb.toString().replace(filterDetailsRegex, '').replace(filterDetailsRegex2, '\"'));
                filterBar.show();
            }
        },
        focus: function (fieldName, message) {
            var that = this,
                fieldInput = $.mobile.activePage.find('.app-field-' + fieldName),
                item, itemOffsetTop,
                screen = that.screen(), scrollTop,
                popup = $('.app-popup-message');
            if (popup.length)
                return;
            if (fieldInput.length) {
                item = fieldInput.closest('li');
                itemOffsetTop = item.offset().top;
                if (itemOffsetTop < screen.top || itemOffsetTop + item.outerHeight() > screen.bottom) {
                    scrollTop = itemOffsetTop - (screen.height - item.outerHeight()) / 2;
                    $(window).scrollTop(scrollTop > 0 ? scrollTop : 0);
                }
                popup = $('<div class="ui-content app-popup-message"/>').html(message).popup({
                    history: false,
                    arrow: 't,b',
                    positionTo: fieldInput,
                    afteropen: function () {
                        that.pageScrolling(false);
                    },
                    afterclose: function () {
                        popup.popup('destroy').remove();
                        fieldInput.focus();
                        that.pageScrolling(true);
                    }
                }).popup('open').on('vclick', function () {
                    popup.popup('close');
                    return false;
                });
            }
        },
        showLookup: function (context) {
            var pageInfo = this.pageInfo(),
                dataView = pageInfo.dataView,
                lookupField = context.field,
                id,
                lookupDataView, lookupPageInfo;
            this.modalDataView();
            id = context.field.ItemsDataController.toLowerCase();
            if ($find(id))
                id += Sys.Application.getComponents().length;
            lookupDataView = $create(Web.DataView, {
                id: id, baseUrl: dataView.get_baseUrl(), servicePath: dataView.get_servicePath(),
                controller: lookupField.ItemsDataController, viewId: lookupField.ItemsDataView
            }, null, null, $('<div>').hide().appendTo(body).attr('id', id + 'Placeholder')[0]);
            lookupPageInfo = this.pageInfo(lookupDataView._id);
            if (context.query) {
                // apply quick find filter
                lookupDataView.set_quickFindText(context.query);
            }
            lookupPageInfo.text = context.aliasField.HeaderText;
            lookupPageInfo.resolved = true;
            lookupDataView._lookupInfo = context;
            if (context.value != null) {
                lookupDataView._syncKey = [context.value];
                lookupDataView._selectedKey = [context.value];
            }
            lookupDataView._parentDataViewId = dataView._id;
            this.modalDataView(lookupPageInfo.id);
            //this.changePage(lookupPageInfo.id);
        },
        pageShow: function (id) {
            var pageInfo = this.pageInfo(id);
            if (pageInfo == null) return;
            var dataView = pageInfo.dataView,
                extension = dataView ? dataView.extension() : null,
                infoBar = this.infoBar().hide(),
                stackIndex = this._modalStack.indexOf(pageInfo),
                menuButton = $('#app-btn-menu');
            if (stackIndex >= 0)
                this._modalStack.splice(stackIndex, 1);
            if (dataView) {
                //this.toolbar(this.title());
                if (dataView._filterSource) {
                    var masterDataView = $appfactory.find(dataView._filterSource);
                    if (masterDataView) {
                        var masterExtension = masterDataView.extension(),
                            map = masterExtension.itemMap(),
                            allFields = masterDataView._allFields,
                            row = masterExtension.commandRow(),
                            headingField;
                        if (map && row) {
                            var infoBarLink = infoBar.find('a').data('data-view-id', masterDataView._id);
                            infoBarLink.children().remove();
                            // optional parent label
                            if (dataView._parentDataViewId) {
                                $('<span class="app-bar-label"/>').appendTo(infoBarLink).text($appfactory.find(dataView._parentDataViewId).get_view().Label);
                                //$('<span class="app-item-desc-divider"></span>').appendTo(infoBarLink);
                            }
                            // heading item
                            var heading = $('<span class="app-item-heading"></span>').appendTo(infoBarLink),
                                headingField = allFields[map.heading];
                            v = row[headingField.Index];
                            v = headingField.text(v);
                            if (headingField.HtmlEncode)
                                heading.text(v);
                            else
                                heading.html(v);
                            // description fields
                            $(map.desc).each(function () {
                                $('<span> | </span>').appendTo(infoBarLink);
                                var descField = allFields[this],
                                    desc = $('<span></span>').appendTo(infoBarLink);
                                v = row[descField.Index];
                                v = descField.text(v);
                                if (descField.HtmlEncode)
                                    desc.text(v);
                                else
                                    desc.html(v);
                            });
                            infoBar.show();
                        }
                    }
                }
                this.filterStatus();
            }
            if (!pageInfo.initialized) {
                pageInfo.initialized = true;
                if (dataView)
                    dataView._loadPage();
            }
            if (extension && extension._reset)
                extension.refresh();
            if (this.toolbar().is(':visible'))
                if (!(this._pages.length < 1 || $.mobile.activePage.attr('id') == this._pages[0].id))
                    menuButton.removeClass('ui-icon-home').addClass('ui-icon-back').attr('href', '#app-back');
                else
                    menuButton.removeClass('ui-icon-back').addClass('ui-icon-home').attr('href', '#app-btn-menu');
            $("[data-role='navbar'] a.app-tab-active").addClass("ui-btn-active");
        },
        screen: function () {
            var scrollTop = $.mobile.window.scrollTop(),
                toolbarHeight = this.toolbar().outerHeight(),
                screenHeight = $.mobile.getScreenHeight();
            return { top: scrollTop + toolbarHeight, bottom: scrollTop + $.mobile.getScreenHeight(), height: screenHeight - toolbarHeight, width: $(window).width() };

        },
        fetchOnDemand: function () {
            var loadButton = $.mobile.activePage.find('.dv-load-at-bottom');
            if (loadButton.length) {
                var itemTop = loadButton.offset().top,
                    itemBottom = itemTop + loadButton.outerHeight(),
                    screen = this.screen();
                if (screen.top <= itemTop && itemTop <= screen.bottom || screen.top <= itemBottom && itemBottom <= screen.bottom)
                    loadButton.trigger('vclick');
            }
            loadButton = $.mobile.activePage.find('.dv-load-at-top');
            if (loadButton.length) {
                itemTop = loadButton.offset().top;
                itemBottom = itemTop + loadButton.outerHeight();
                screen = this.screen();
                if (screen.top <= itemTop && itemTop <= screen.bottom || screen.top <= itemBottom && itemBottom <= screen.bottom)
                    loadButton.trigger('vclick');
            }
            return this;
        },
        headingOnDemand: function () {
            var that = this;
            var headingText = $.mobile.activePage.find('.dv-heading .app-static-text'),
                headingBar = that.headingBar();
            if (headingText.length) {
                var screen = that.screen(),
                    headingTop = headingText.offset().top,
                    headingHeight = headingText.outerHeight(),
                    headingBarHeight = headingBar.is(':visible') ? headingBar.outerHeight() : 0;
                if (headingTop < screen.top && headingText.is(':visible')) {
                    headingBar.css('top', (that.toolbar().outerHeight() - 1) + 'px').show().find('span.app-bar-text').text(headingText.text());
                    headingBar.find('span.app-bar-label').text(headingText.closest('li').find('label:first').text());

                }
                else
                    headingBar.hide();
            }
            else

                headingBar.hide();
            return that;
        },
        wait: function (enable) {
            $.mobile.loading(enable ? 'show' : 'hide');
        },
        start: function () {
            if (!(this._appLoaded && this._pageCreated)) return;

            var that = this,
                links = $.mobile.activePage.find('a.app-action-navigate'),
                anchor = location.href.match(/#(.+)$/),
                anchoredPage = anchor ? that.pageInfo(anchor[1]) : null,
                urlHistory = $.mobile.navigate.history;
            if (anchoredPage && (!anchoredPage.dataView || !anchoredPage.dataView._filterSource))
                that.changePage(anchoredPage.id, false);
            else if (links.length == 1)
                $(this._pages).each(function () {
                    var dataView = this.dataView;
                    if (!dataView || !dataView._hidden) {
                        that.changePage(this.id, false);
                        var urlEntry = urlHistory.stack[0]
                        urlHistory.stack = [urlEntry];
                        urlHistory.activeIndex = 0;
                        if (urlEntry.hash) {
                            urlEntry.hash = '';
                            urlEntry.url = $appfactory.unanchor(urlEntry.url);
                        }
                        return false;
                    }
                });
            else if (getActivePageId() == 'Main') {
                links.show();
                $appfactory.mobile.pageMenu().listview().show();
                $('.app-page-menu-desc').show();
            }
        },
        pageMenu: function () {
            var that = this,
                content = this.content(),
                menu = content.find('ul.app-page-menu'),
                about = $('.TaskBox.About .Inner .Value');
            if (!menu.length) {
                var pageDesc = $('<p class="app-page-menu-desc"></p>').appendTo(content).hide();
                menu = $('<ul data-role="listview" data-inset="false" class="app-page-menu"></ul').appendTo(content).hide().on('vclick', function (event) {
                    var link = $(event.target);
                    if (!link.is('a'))
                        link = link.closest('a');
                    if (link.length) {
                        activeLink(link);
                        setTimeout(function () {
                            activeLink();
                            that.changePage(link.attr('href').substring(1));
                        }, 200);
                        event.preventDefault();
                        event.stopPropagation();
                    }
                });
                if (about.length) {
                    $('<br/><br/>').appendTo(pageDesc.html(about.html()));
                    pageDesc.find('a').attr('rel', 'external');
                }
            }
            return menu;
        },
        initialize: function () {
            var that = this,
                pulse = new Date().getTime();
            function appPulse() {
                var newPulse = new Date().getTime();
                if (newPulse - pulse > 2500) {
                    var event = $.Event("appawake");
                    $(document).trigger(event);
                    if (event.isDefaultPrevented())
                        return;
                    else
                        newPulse = new Date().getTime();
                }

                pulse = newPulse;
                setTimeout(appPulse, 1250);
            };
            setTimeout(appPulse, 10);
            var pageMenu = $appfactory.mobile.pageMenu(),
                userPages = $('#PageContent').find('div[data-app-role="page"]').each(function (index) {
                    var userPage = $(this).attr({ 'data-role': 'page', 'data-app-role': null }).appendTo(body).page(),
                        activator = parseActivator(userPage),
                        pageInfo = { text: activator.text, description: activator.description },
                        pageId = userPage.attr('id');
                    if (!pageId) {
                        pageId = 'UserPage' + index;
                        userPage.attr('id', pageId);
                    }
                    pageInfo.id = pageId;
                    $appfactory.mobile.pageInfo(pageInfo);
                    var button = $('<a class="app-action-navigate" data-transition="none"></a>')
                        .attr('href', '#' + pageId).text(pageInfo.text)
                        .appendTo($('<li>').appendTo(pageMenu));
                    if (pageInfo.description)
                        $('<p>').appendTo(button).text(pageInfo.description);
                });
            var restoreFixedElementsTimeout;
            $(document).on('focus', 'input,textarea,select', function (event) {
                var target = $(event.target);
                if (target.is('#app-text-search'))
                    return;
                _focusedInput = target;
                if (!isDesktopClient) {
                    if (restoreFixedElementsTimeout)
                        clearTimeout(restoreFixedElementsTimeout);
                    if (contextSidebarIsVisible() && documentIsScrollable())
                        contextSidebar().height($(document).height());
                }
                if (target.is('.app-lookup-input'))
                    target.next().addClass('ui-focus')//.toggleClass('ui-alt-icon');
                if (!isDesktopClient)
                    $('.ui-header.ui-header-fixed,.app-bar-heading,.app-sidebar-right').css('position', 'absolute');
            }).on('blur', 'input,textarea,select', function (event) {
                var link, linkText, query;
                if (!_focusedInput)
                    return;
                if (_focusedInput.is('.app-lookup-input')) {
                    linkText = _focusedInput.data('link-text');
                    link = _focusedInput.data('link-text', null).next().removeClass('ui-focus');
                    if (linkText) {
                        link.toggleClass('ui-icon-bullets ui-icon-search').removeClass('app-transparent');
                        setTimeout(function () {
                            link.text(linkText);
                        }, 200);
                    }
                    query = _focusedInput.val().trim();
                    if (query)
                        link.text(query).data('data-context').query = query;
                    _focusedInput.val('');
                }
                _focusedInput = null;
                if (!isDesktopClient)
                    restoreFixedElementsTimeout = setTimeout(function () {
                        restoreFixedElementsTimeout = null;
                        if (contextSidebarIsVisible())
                            contextSidebar().height('');
                        $('.ui-header.ui-header-fixed,.app-bar-heading,.app-sidebar-right').css('position', 'fixed');
                    }, 20);
            }).on('touchstart', 'a.app-lookup', function (event) {
                if (_focusedInput) {
                    var query = _focusedInput.val().trim();
                    if (query)
                        _focusedInput.next().text(query).removeClass('app-transparent');
                }
            }).on('keydown', function (event) {
                if (event.which == 13 && !$(event.target).is('textarea')) {
                    if (_focusedInput) {
                        if (_focusedInput.is('.app-lookup-input')) {
                            var s = _focusedInput.val().trim();
                            if (s.length || isDesktopClient) {
                                _focusedInput.next().data('data-context').query = s;
                                _focusedInput.next().trigger('vclick');
                            }
                        }
                        _focusedInput.blur();
                        return false;
                    }
                }
            }).on('keyup', '.app-lookup-input', function (event) {
                var target = $(event.target),
                    link = target.next();
                if (!target.data('link-text'))
                    setTimeout(function () {
                        if (target.val() != '') {
                            target.data('link-text', link.text());
                            link.html('&nbsp;').toggleClass('ui-icon-bullets ui-icon-search app-transparent');
                        }
                    }, 10);
            });
        }
    };

    /* initialize mobile page */

    (function () {
        $.event.special.swipe.scrollSupressionThreshold = 100;
        sidebarIsUndocked = userVariable('sidebarIsUndocked');
        body = $('body');
        if (isDesktopClient) {
            body.addClass('app-desktop');
        }
        if (sidebarIsUndocked)
            body.addClass('app-sidebar-undocked');

        $('form').hide();
        var toolbar = $('<div id="app-bar-tools" data-role="header" data-position="fixed" data-theme="a" class="ui-shadow app-bar-tools"></div>"').appendTo(body),
            page = $('<div data-role="page" id="Main"></div>').appendTo(body);
        // create page content
        $('<div data-role="content" class="app-content-main"></div>"').appendTo(page)
        // tool bar configuration
        $('<a data-role="button" href="#" id="app-btn-menu" data-icon="home" data-iconpos="notext" data-shadow="false" data-icon-shadow="false">Site Map</a>').appendTo(toolbar);
        var toolbarHeader = $('<h1 class="ui-title"/>').appendTo(toolbar),
            buttonsBar = $('<div class="app-btn-cluster-right"/>').appendTo(toolbar);
        // app button 1
        $('<a href="#" data-role="button" data-icon="gear" data-iconpos="notext" class="ui-btn-right app-btn"/>').appendTo(buttonsBar);
        // app button 2
        $('<a href="#" data-role="button" data-icon="gear" data-iconpos="notext" class="ui-btn-right app-btn"/>').appendTo(buttonsBar);
        // app button 3
        $('<a href="#" data-role="button" data-icon="gear" data-iconpos="notext" class="ui-btn-right app-btn"/>').appendTo(buttonsBar);
        // app button 4
        $('<a href="#" data-role="button" data-icon="gear" data-iconpos="notext" class=" app-btn ui-btn-right"/>').appendTo(buttonsBar);
        // app button 5
        $('<a href="#" data-role="button" data-icon="gear" data-iconpos="notext" class=" app-btn ui-btn-right"/>').appendTo(buttonsBar);
        // context button
        $('<a href="#" id="app-btn-context" data-icon="bars" data-iconpos="notext" data-role="button" class="ui-btn-right app-btn-context"/>').appendTo(buttonsBar);
        // info bar
        var infoBar = $('<div id="app-bar-info" class="app-bar app-bar-info"><a href="#" class="ui-btn ui-btn-icon-left ui-icon-info"></a></div>').appendTo(toolbar).hide();
        // filter bar
        var filterBar = $('<div id="app-bar-filter" class="app-bar app-bar-filter"><a href="#app-btn-clear-filter" class="ui-btn ui-btn-icon-left ui-icon-delete"></a></div>').appendTo(toolbar).hide();

        $('<div id="app-bar-heading" class="app-bar-heading ui-overlay-shadow"><span class="app-bar-label"/><span class="app-bar-text"/></div>').appendTo(body).hide();

        var infoBarLink = infoBar.find('a').on('vclick', function () {
            activeLink(infoBarLink);
            if (!panelIsBusy)
                setTimeout(function () {
                    activeLink();
                    $appfactory.mobile.infoView($appfactory.find(infoBarLink.data('data-view-id')), true);
                }, 200);
            return false;
        });

        // quick find controls
        var quickFindButton = toolbar.find('.app-btn').data('icon', 'gear').on('vclick taphold', function (event) {
            blurFocusedInput();
            var link = $(event.target),
                icon = link.data('icon');
            event.preventDefault();
            event.stopPropagation();
            if (icon == 'search') {
                // quick find is clicked
                toolbarStandardControls = $('.ui-title,#app-btn-menu,.app-btn-cluster-right').hide();
                toolbarSearchControls = toolbar.find('#app-controls-find');
                if (toolbarSearchControls.length == 0) {
                    toolbarSearchControls = $('<div id="app-controls-find" class="app-bar-search"><form><label for="app-text-search" class="ui-hidden-accessible">Search:</label><input type="search" id="app-text-search" data-role="search" placeholder="Quick Find - Products" data-mini="true"/><a href="#" data-role="button" data-icon="back" data-iconpos="notext" class="ui-btn-right ui-btn ui-icon-back ui-btn-icon-notext ui-shadow ui-corner-all" ></a></form></div>').insertBefore(toolbarHeader);

                    var textBox = toolbarSearchControls.find('input').textinput({ mini: true }).attr('type', 'text')
                        .focus(function () {
                            if (iOS)
                                setTimeout(function () {
                                    $(window).scrollTop($.mobile.defaultHomeScroll);
                                    $('meta[name="viewport"]').attr('viewport', 'device-width, initial-scale=1,maximum-scale=1, user-scalable=no');
                                }, 200);
                        }).blur(function () {
                            activeLink(cancelSearchButton);
                            setTimeout(function () {
                                activeLink();
                                toolbarStandardControls.show();
                                toolbarSearchControls.hide();
                                if (iOS) {
                                    var loadAtTop = $('.dv-load-at-top').show();
                                    if (loadAtTop.length)
                                        $(window).scrollTop(loadAtTop.outerHeight());

                                }
                                var dataView = $appfactory.mobile.dataView();
                                if (dataView._totalRowCount == -1)
                                    dataView.sync();

                            }, 200);
                        });
                    textBox.parent().find('a').remove();

                    toolbarSearchControls.find('form').submit(function (event) {
                        event.preventDefault();
                        event.stopPropagation();
                        textBox.blur();
                        toolbarStandardControls.show();
                        toolbarSearchControls.hide();
                        var pageInfo = $appfactory.mobile.pageInfo(),
                            extension = pageInfo.dataView.extension();
                        extension.quickFind($appfactory.mobile.search());
                        $appfactory.mobile.filterStatus();
                        $appfactory.mobile.toolbar($appfactory.mobile.title());
                    });


                    var cancelSearchButton = toolbarSearchControls.find('a:last').on('vclick', function () {
                        textBox.blur();
                        return false;
                    });
                }
                var pageInfo = $appfactory.mobile.pageInfo(),
                    text = pageInfo.dataView.extension().quickFind();
                if (iOS) {
                    $('.dv-load-at-top').hide();
                    $(window).scrollTop($.mobile.defaultHomeScroll);
                }
                toolbarSearchControls.show();
                $appfactory.mobile.search({ 'text': text, 'placeholder': String.format('{0} - {1}', resourcesGrid.QuickFindText, pageInfo.dataView.get_view().Label), focus: true });
            }
            else {
                activeLink(link);
                setTimeout(function () {
                    activeLink();
                    var context = [];
                    $appfactory.mobile.navContext(context);
                    $(context).each(function () {
                        var action = this;
                        if (action.icon == icon) {
                            executeContextAction(action);
                            return false;
                        }
                    });
                }, 250);
            }
            return false;
        });
        toolbar.toolbar();

        var startClientY,
            sidebarRight = $('<div id="app-sidebar-right" class="ui-panel ui-panel-fixed ui-body-a app-sidebar-right ui-shadow"><div class="ui-panel-inner"><ul/><div class="app-menu-footer"/></div></div>').appendTo(body),
            sidebarRightInner = sidebarRight.find('div:first'),
            sidebarRightList = sidebarRightInner.find('ul');
        sidebarRight
            .on('touchstart', function (e) {
                var touch = e.originalEvent.touches[0] || e.originalEvent.changedTouches[0];
                startClientY = touch.clientY;
                touchMovePrevented = false;
            }).on('touchmove', function (e) {
                if (_focusedInput)
                    return;
                touchMovePrevented = false;
                var touchedPanel = $(e.target).closest('.app-sidebar-right'),
                    preventTouch = touchedPanel.length == 0;
                if (!preventTouch) {
                    var listview = touchedPanel.find('ul'),
                        menuFooter = touchedPanel.find('div.app-menu-footer'),
                        listviewHeight = listview.height() + (menuFooter.length ? menuFooter.outerHeight() : 0),
                        touchedPanelHeight = touchedPanel.height(),
                        touch = e.originalEvent.touches[0] || e.originalEvent.changedTouches[0],
                        clientY = touch ? touch.clientY : -1,
                        panelScrollTop = listview.parent().scrollTop();
                    if (listviewHeight <= touchedPanelHeight)
                        preventTouch = true;
                    else {
                        if (listviewHeight - panelScrollTop <= touchedPanelHeight) {
                            if (startClientY > clientY)
                                preventTouch = true;
                        }
                        else if (panelScrollTop == 0) {
                            if (startClientY < clientY)
                                preventTouch = true;
                        }
                    }
                }
                if (preventTouch) {
                    touchMovePrevented = true;
                    return false;
                }
            })
            .on('swipe', function () {
                //skipContextActionOnClose = true;
            });

        if (isDesktopClient) {

            function sidebarScrolling(enable) {
                var scrollingState = sidebarRightInner.css('overflow-y');
                if (documentIsScrollable()) {
                    if (enable && scrollingState != 'auto' || !enable && scrollingState != 'hidden') {
                        sidebarRightInner.css('overflow-y', enable ? (contextSidebarIsScrollable() ? 'auto' : 'auto') : 'hidden');
                        if (enable) {
                            if (!contextSidebarIsScrollable()) {
                                var mouseOverWidth = sidebarRight.width();
                                sidebarRight.width(mouseOverWidth - verticalScrollbarWidth).css('margin-right', verticalScrollbarWidth)
                                    .data('mouse-over-width', mouseOverWidth);
                            }
                        }
                        else {
                            var w = sidebarRight.data('mouse-over-width');
                            if (w && !contextSidebarIsScrollable()) {
                                sidebarRight.data('mouse-over-width', null).width(w).css('margin-right', '');
                            }
                        }
                    }
                }
                else {
                    sidebarRightInner.css('overflow-y', enable ? 'auto' : 'hidden');
                    if (contextSidebarIsScrollable()) {
                        $('html').css('overflow-y', 'hidden');
                    }
                    else
                        $('html').css('overflow-y', 'scroll');
                }
            }

            sidebarScrolling(false);
            sidebarRight
                .on('vmouseover', function () {
                    if (!sidebarRight.data('scrollable')) {
                        sidebarRight.data('scrollable', true);
                        $appfactory.mobile.pageScrolling(false);
                        sidebarScrolling(true);
                    }
                })
                .on('vmouseout', function (event) {
                    if (!$(event.toElement).closest('.app-sidebar-right').length && sidebarRight.data('scrollable')) {
                        sidebarRight.data('scrollable', false);
                        sidebarScrolling(false);
                        $appfactory.mobile.pageScrolling(true);
                    }
                });
        }
        sidebarRightList.listview()
             .on('vclick', function (event) {
                 if (touchMoveIsCanceled() || panelIsBusy || tapIsCanceled())
                     return false;
                 blurFocusedInput();
                 if (isDesktopClient)
                     sidebarRight.trigger('vmouseout');
                 var link = $(event.target).closest('a');
                 activeLink(link);
                 if (contextSidebarRefreshTimeout) {
                     setTimeout(function () {
                         activeLink();
                     }, 200);
                     return;
                 }
                 var action = link.data('context-action');
                 if (action)
                     setTimeout(function () {
                         activeLink();
                         executeContextAction(action);
                     }, 200);
                 return false;
             });
        ;
    })();

    $appfactory.mobile = new Web.Mobile();

    $(document).ready(function () {
        $appfactory.mobile.initialize();
    }).contextmenu(function () {
        return false;
    }).one('pagecreate', '#Main', function () {
        $appfactory.mobile._pageCreated = true;
    }).on('pagebeforeshow', '#Main', function (event, data) {
        setTimeout(function () {
            $appfactory.mobile.start();
        }, 100);
    }).on('pageshow', function () {
        var pageInfo = $appfactory.mobile.pageInfo();
        if (pageInfo) {
            if (pageInfo.scrollTop)
                $(window).scrollTop(pageInfo.scrollTop);
            $appfactory.mobile.headingOnDemand();
            //var dataView = pageInfo.dataView;
            //if (dataView && dataView._busy())
            //    dataView._busy(true);
        }
        refreshContextSidebar();
    }).on('pagebeforeshow', function (e, options) {
        var mobile = $appfactory.mobile,
            activePage = $.mobile.activePage;
        mobile.toolbar($appfactory.mobile.title());
        mobile.pageShow(activePage.attr('id'));
        mobile.unloadPage(options.prevPage, activePage);
        userActivity();
    }).on('pagebeforehide', function () {
        $('.ui-panel-open').panel('close', true);
        if (isDesktopClient)
            $('html').css('overflow-y', 'scroll');
    }).on('pagebeforechange', function (e, options) {
        if (typeof options.toPage == 'string' && options.toPage.match(/http/))
            return;
        var mobile = $appfactory.mobile,
            toPage = $(options.toPage),
            toPageInfo = mobile.pageInfo(toPage.attr('id')),
            toolbarIsHidden = toPage.attr('data-app-toolbar') == 'false',
            dataView = toPageInfo && toPageInfo.dataView;
        if (toolbarStandardControls)
            toolbarStandardControls.show();
        if (toolbarSearchControls)
            toolbarSearchControls.hide();
        extension = dataView && dataView.extension();
        mobile.toolbar(!toolbarIsHidden);
        mobile.search({ 'allow': extension ? extension.options().quickFind : false });
    }).on('scrollstart', function (e) {
        skipTap = true;
    }).on('scrollstop', function () {
        skipTap = false;
        $appfactory.mobile.fetchOnDemand();
        $appfactory.mobile.headingOnDemand();
        userActivity();
    }).on('vclick', function (event) {
        var eventTarget = $(event.target),
            link = eventTarget.is('a') ? eventTarget : eventTarget.closest('a'),
            href = link.attr('href'),
            target;
        switch (href) {
            case '#app-menu':
                target = '#app-btn-menu';
                break;
            case '#app-context':
                target = '#app-btn-context';
                break;
            case '#app-back':
                target = function () {
                    history.back();
                };
                break;
            case '#app-btn-clear-filter':
                target = function () {
                    var pageInfo = $appfactory.mobile.pageInfo();
                    if (pageInfo && pageInfo.dataView) {
                        pageInfo.dataView.clearFilter();
                        $appfactory.mobile.filterStatus();
                    }
                };
                break;
            case '#app-details':
                target = function () {
                    var pageInfo = $appfactory.mobile.pageInfo(),
                        extension;
                    if (pageInfo && pageInfo.dataView) {
                        extension = pageInfo.dataView.extension();
                        extension.command(extension.commandRow(), 'Select');
                        pageInfo.dataView._viewDetails(link.attr('data-field-name'));
                    }
                };
                break;
            case '#app-lookup':
                target = function () {
                    var context = link.data('data-context');
                    blurFocusedInput();
                    $appfactory.mobile.showLookup(context);
                    context.query = null;
                };
                break;
            default:
                if (href) {
                    if (href.match(/^tel/))
                        target = function () {
                            window.location.href = href;
                        }
                    else {
                        var contentType = link.attr('data-content-type'),
                            previewPopup;
                        if (contentType && contentType.match(/^image/))
                            target = function () {
                                previewPopup = $('#app-popup-image');
                                if (!previewPopup.length) {
                                    previewPopup = $(
                                        '<div id="app-popup-image" class="app-popup-image" data-role="popup" data-overlay-theme="b" data-theme="b" data-position-to="window">' +
                                        '<a href="#app-back" data-rel="back" class="ui-btn ui-corner-all ui-shadow ui-btn-b ui-icon-delete ui-btn-icon-notext ui-btn-right"/>' +
                                        '<img class="app-image-preview" style="max-width:10000px"/><div class="app-image-preview-box"/>' +
                                        '</div>').appendTo(body).popup(defaultPopupOptions('none'));
                                    previewPopup.find('.app-image-preview').on('load', function (event) {
                                        $.mobile.loading('hide');
                                        var image = $(event.target).width('').height(''),
                                            imageBox = previewPopup.find('.app-image-preview-box'),
                                            screen = $appfactory.mobile.screen(),
                                            imageWidth = image.width(),
                                            maxImageWidth = screen.width * .9,
                                            imageHeight = image.height(),
                                            maxImageHeight = screen.height * .9;
                                        if (imageWidth > maxImageWidth) {
                                            imageHeight *= maxImageWidth / imageWidth;
                                            imageWidth = maxImageWidth;
                                            if (imageHeight > maxImageHeight) {
                                                imageWidth *= maxImageHeight / imageHeight;
                                                imageHeight = maxImageHeight;
                                            }
                                        }
                                        else if (imageHeight > maxImageHeight) {
                                            imageWidth *= maxImageHeight / imageHeight;
                                            imageHeight = maxImageHeight;
                                        }
                                        image.hide();
                                        imageBox.css({
                                            'background': '',
                                            'width': imageWidth + 'px',
                                            'height': imageHeight + 'px'
                                        }).show();
                                        previewPopup.popup('reposition', { positionTo: 'window' });
                                        imageBox.css({
                                            'background': String.format('url({0})', image.attr('src')),
                                            'background-size': String.format('{0}px {1}px', imageWidth, imageHeight)
                                        });
                                    });
                                }
                                $.mobile.loading('show');
                                previewPopup.find('.app-image-preview-box').hide();
                                previewPopup.find('.app-image-preview').attr('src', '').width(100).height('').show().attr('src', href);
                                previewPopup.popup('open');
                            }
                    }
                }
        }
        if (target) {
            activeLink(event.target);
            setTimeout(function () {
                activeLink();
                if (typeof target == 'string')
                    $(target).trigger('vclick');
                else
                    target();
            }, 200);
            return false;
        }
    });

    $(window).orientationchange(function () {
        refreshContextSidebar();
    }).resize(function () {
        refreshContextSidebar();
    });

    Sys.Application.add_init(function () {
    });

    Sys.Application.add_load(function () {
        $appfactory.mobile._appLoaded = true;
    });

    Web.DataView.MobileGrid.registerClass('Web.DataView.MobileGrid', Web.DataView.MobileBase);
    Web.DataView.MobileForm.registerClass('Web.DataView.MobileForm', Web.DataView.MobileBase);

})();