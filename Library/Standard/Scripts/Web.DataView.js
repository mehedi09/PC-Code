/// <reference path="jquery-1.10.2.js"/>
/// <reference name="MicrosoftAjax.debug.js" />
/// <reference name="AjaxControlToolkit.ExtenderBase.BaseScripts.js" assembly="AjaxControlToolkit" />
/// <reference name="AjaxControlToolkit.Common.Common.js" assembly="AjaxControlToolkit" />
/// <reference name="AjaxControlToolkit.ModalPopup.ModalPopupBehavior.js" assembly="AjaxControlToolkit"/>
/// <reference name="AjaxControlToolkit.AlwaysVisibleControl.AlwaysVisibleControlBehavior.js" assembly="AjaxControlToolkit"/>
/// <reference name="AjaxControlToolkit.PopupControl.PopupControlBehavior.js" assembly="AjaxControlToolkit"/>
/// <reference name="AjaxControlToolkit.Calendar.CalendarBehavior.js" assembly="AjaxControlToolkit"/>
/// <reference path="Web.DataViewResources.js"/>
/// <reference path="Web.Menu.js"/>
Type.registerNamespace("Web");

Web.DataViewMode = { View: 'View', Lookup: 'Lookup' };
Web.DynamicExpressionScope = { Field: 0, ViewRowStyle: 1, CategoryVisibility: 2, DataFieldVisibility: 3, DefaultValues: 4, ReadOnly: 5, Rule: 6 };
Web.AutoHideMode = { Nothing: 0, Self: 1, Container: 2 };
Web.DynamicExpressionType = { RegularExpression: 0, ClientScript: 1, ServerExpression: 2, CSharp: 3, VisualBasic: 4, Any: 4 };
Web.DataViewAggregates = ['None', 'Sum', 'Count', 'Avg', 'Max', 'Min'];
Web.FieldSearchMode = { Default: 0, Required: 1, Suggested: 2, Allowed: 3, Forbidden: 4 }

Web.PageState = {}
Web.PageState._init = function () {
    if (!this._state) {
        var state = $get('__COTSTATE');
        if (state != null && !String.isNullOrEmpty(state.value))
            this._state = Sys.Serialization.JavaScriptSerializer.deserialize(state.value);
        else
            this._state = {};
    }
}
Web.PageState._save = function () {
    var state = $get('__COTSTATE');
    if (state != null)
        state.value = Sys.Serialization.JavaScriptSerializer.serialize(this._state);
}
Web.PageState.read = function (name) {
    this._init();
    return this._state[name];
}
Web.PageState.write = function (name, value) {
    this._init();
    this._state[name] = value;
    this._save();
}

Sys.StringBuilder.prototype.appendFormat = function (fmt, args) {
    this.append(String._toFormattedString(false, arguments));
}

String.isNullOrEmpty = function (s) {
    return s == null || s.length == 0;
}

String.isBlank = function (s) {
    return s == null || typeof (s) == 'string' && s.match(Web.DataView._blankRegex) != null;
}

String._wordTrimRegex = /(\S{16})\S+/g;
String._tagRegex = /<\/?\w.*?>/g;

String.trimLongWords = function (s, maxLength) {
    if (s == null)
        return s;
    var re = this._wordTrimRegex;
    if (maxLength != null)
        re = new RegExp(String.format('(\\S{{{0}}})\\S+', maxLength), 'g');
    var result = s.replace(re, '$1...');
    if (s.match(String._tagRegex)) {
        var sb = new Sys.StringBuilder();
        var iterator = String._tagRegex;
        var m = iterator.exec(s);
        var lastIndex = 0;
        while (m) {
            tag = m[0];
            if (m.index > 0)
                sb.append(s.substring(lastIndex, m.index).replace(re, '$1...'));
            lastIndex = m.index + tag.length;
            sb.append(tag);
            m = iterator.exec(s);
        }
        if (lastIndex < s.length)
            sb.append(s.substring(lastIndex));
        result = sb.toString();

    }
    return result;
}

String.htmlEncode = function (s) {
    return typeof s == 'string' && s.match(Web.DataView._htmlTest) ? s : Web.DataView.htmlEncode(s);
}

String.isJavaScriptNull = function (s) {
    return s == '%js%null' || s == 'null';
};

String.jsNull = '%js%null';

Web.DataView = function (element) {
    Web.DataView.initializeBase(this, [element]);
    this._controller = null;
    this._viewId = null;
    this._servicePath = null;
    this._baseUrl = null;
    this._pageIndex = -1;
    this._pageSize = Web.DataViewResources.Pager.PageSizes[0];
    this._sortExpression = null;
    this._filter = [];
    this._externalFilter = [];
    this._categories = null;
    this._fields = null;
    this._allFields = null;
    this._rows = null;
    this._totalRowCount = 0;
    this._firstPageButtonIndex = 0;
    this._pageCount = 0;
    this._views = [];
    this._actionGroups = [];
    this._selectedKey = [];
    this._selectedKeyFilter = []
    this._lastCommandName = null;
    this._lastViewId = null;
    this._lookupField = null;
    this._filterFields = null;
    this._filterSource = null;
    this._mode = Web.DataViewMode.View;
    this._lookupPostBackExpression = null;
    this._domFilterSource = null;
    this._selectedKeyList = [];
    this._pageSizes = Web.DataViewResources.Pager.PageSizes;
}

Web.DataView.htmlEncode = function (s) { if (s != null && typeof (s) != 'string') s = s.toString(); return s ? s.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;') : s; }

Web.DataView.htmlAttributeEncode = function (s) { return s != null && typeof (s) == 'string' ? s.replace(/\x27/g, '&#39;').replace(/\x22/g, '&quot;') : s; }

Web.DataView.isIE6 = this._ie6 = Sys.Browser.agent == Sys.Browser.InternetExplorer && Sys.Browser.version < 7;

Web.DataView.prototype = {
    get_controller: function () {
        return this._controller;
    },
    set_controller: function (value) {
        this._controller = value;
    },
    get_useCase: function () {
        return this._useCase;
    },
    set_useCase: function (value) {
        this._useCase = value;
    },
    get_viewId: function () {
        if (!this._viewId && this._views.length > 0)
            this._viewId = this._views[0].Id;
        var viewId = this._viewId;
        if (!viewId)
            viewId = '';
        return viewId;
    },
    set_viewId: function (value) {
        this._viewId = value;
    },
    get_newViewId: function () {
        return this._newViewId;
    },
    set_newViewId: function (value) {
        this._newViewId = value;
    },
    get_servicePath: function () {
        return this._servicePath;
    },
    set_servicePath: function set_servicePath(value) {
        this._servicePath = this.resolveClientUrl(value);
        if (!Web.DataView._servicePath) Web.DataView._servicePath = value;
    },
    get_baseUrl: function () {
        return this._baseUrl;
    },
    set_baseUrl: function (value) {
        if (value == '~') value = '/';
        this._baseUrl = value;
        if (!Web.DataView._baseUrl) Web.DataView._baseUrl = value;
    },
    get_siteUrl: function () {
        var servicePath = this.get_servicePath();
        var m = servicePath.match(/(^.+?\/)\w+\/\w+\.asmx/);
        return m ? m[1] : '';
    },
    resolveClientUrl: function (url) {
        return url ? url.replace(/~\x2f/g, this.get_baseUrl()) : null;
    },
    get_hideExternalFilterFields: function () {
        return this._hideExternalFilterFields != false;
    },
    set_hideExternalFilterFields: function (value) {
        this._hideExternalFilterFields = value;
    },
    get_backOnCancel: function () {
        return this._backOnCancel == true;
    },
    set_backOnCancel: function (value) {
        this._backOnCancel = value;
    },
    get_confirmContext: function () {
        return this._confirmContext;
    },
    set_confirmContext: function (value) {
        this._confirmContext = value;
    },
    get_startCommandName: function () {
        return this._startCommandName;
    },
    set_startCommandName: function (value) {
        this._startCommandName = value;
    },
    get_startCommandArgument: function () {
        return this._startCommandArgument;
    },
    set_startCommandArgument: function (value) {
        this._startCommandArgument = value;
    },
    get_exitModalStateCommands: function () {
        return this._exitModalStateCommands;
    },
    set_exitModalStateCommands: function (value) {
        this._exitModalStateCommands = value;
    },
    get_showActionBar: function () {
        var extension = this.extension();
        if (extension) {
            var options = extension.options();
            return options.actionBar == true;
        }
        return this._showActionBar != false;
    },
    set_showActionBar: function (value) {
        this._showActionBar = value;
    },
    get_showActionButtons: function () {
        var buttonLocation = this._showActionButtons;
        if (buttonLocation == null) {
            buttonLocation = 'TopAndBottom';
            this._showActionButtons = buttonLocation;
        }
        return buttonLocation;
    },
    set_showActionButtons: function (value) {
        this._showActionButtons = value;
    },
    get_showSearchBar: function () {
        return this._showSearchBar == true && !(__tf != 4);
    },
    set_showSearchBar: function (value) {
        this._showSearchBar = value;
    },
    get_searchOnStart: function () {
        return this._searchOnStart == true;
    },
    set_searchOnStart: function (value) {
        this._searchOnStart = value;
        if (value) this.set_searchBarIsVisible(true);
    },
    get_searchBarIsVisible: function () {
        return this._searchBarIsVisible == true;
    },
    set_searchBarIsVisible: function (value) {
        this._searchBarIsVisible = value;
    },
    get_showModalForms: function () {
        if ($appfactory.mobile)
            return true;
        return this._showModalForms == true;
    },
    set_showModalForms: function (value) {
        this._showModalForms = value;
    },
    get_showDescription: function () {
        var extension = this.extension();
        if (extension) {
            var options = extension.options();
            return options.description == true;
        }
        return this._showDescription != false;
    },
    set_showDescription: function (value) {
        this._showDescription = value;
    },
    get_showFirstLetters: function () {
        return this._showFirstLetters == true;
    },
    set_showFirstLetters: function (value) {
        this._showFirstLetters = value;
    },
    get_autoSelectFirstRow: function () {
        return this._autoSelectFirstRow == true;
    },
    set_autoSelectFirstRow: function (value) {
        this._autoSelectFirstRow = value;
    },
    get_autoHighlightFirstRow: function () {
        return this._autoHighlightFirstRow == true;
    },
    set_autoHighlightFirstRow: function (value) {
        this._autoHighlightFirstRow = value;
    },
    get_refreshInterval: function () {
        return this._refreshInterval;
    },
    set_refreshInterval: function (value) {
        this._refreshInterval = !(__tf != 4) ? value : 0;
    },
    get_showViewSelector: function () {
        return this._showViewSelector != false;
    },
    set_showViewSelector: function (value) {
        this._showViewSelector = value;
    },
    get_showPager: function () {
        var pagerLocation = this._showPager;
        if (pagerLocation == null || pagerLocation == true) {
            pagerLocation = 'Bottom';
            this._showPager = pagerLocation;
        }
        else if (pagerLocation == false)
            pagerLocation = 'None';
        return pagerLocation;
    },
    set_showPager: function (value) {
        this._showPager = value;
    },
    get_showPageSize: function () {
        return this._showPageSize != false;
    },
    set_showPageSize: function (value) {
        this._showPageSize = value;
    },
    get_selectionMode: function () {
        return this._selectionMode;
    },
    set_selectionMode: function (value) {
        this._selectionMode = value;
    },
    multiSelect: function () {
        return this._selectionMode == 'Multiple';
    },
    get_cookie: function () {
        return this._cookie;
    },
    set_cookie: function (value) {
        this._cookie = value;
    },
    get_pagerButtonCount: function (refresh) {
        if (!this._pagerButtonCount || refresh) {
            var buttonCount = Web.DataViewResources.Pager.PageButtonCount;
            if (this.get_pageCount() > buttonCount) {
                buttonCount = buttonCount - 3;
                if (buttonCount < 5)
                    buttonCount = 5;
            }
            this._pagerButtonCount = buttonCount;
        }
        return this._pagerButtonCount;
    },
    get_pageIndex: function () {
        return this._pageIndex;
    },
    set_pageIndex: function (value) {
        this._pageIndex = value;
        if (value >= 0) {
            var buttonCount = this.get_pagerButtonCount();
            if (value >= this._firstPageButtonIndex + buttonCount)
                this._firstPageButtonIndex = value;
            else if (value < this._firstPageButtonIndex) {
                this._firstPageButtonIndex -= buttonCount;
                if (value < this._firstPageButtonIndex)
                    this._firstPageButtonIndex = value;
            }
            if (this._firstPageButtonIndex < 0)
                this._firstPageButtonIndex = 0;
            if (this.get_pageCount() - this._firstPageButtonIndex < buttonCount)
                this._firstPageButtonIndex = this.get_pageCount() - buttonCount;
            if (this._firstPageButtonIndex < 0)
                this._firstPageButtonIndex = 0;
        }
        if (value == -2)
            this._pageOffset = 0;
    },
    get_pageOffset: function () {
        if (!this.get_isDataSheet())
            return 0;
        return this._pageOffset == null ? 0 : this._pageOffset;
    },
    set_pageOffset: function (value) {
        this._pageOffset = value;

    },
    get_categoryTabIndex: function () {
        return this._categoryTabIndex;
    },
    set_categoryTabIndex: function (value) {
        if (value != this._categoryTabIndex) {
            this._categoryTabIndex = value;
            this._updateTabbedCategoryVisibility();
            if (value != -1) {
                if (this._modalPopup) {
                    this._resizeContainerBounds();
                    this._modalPopup.show();
                }
                _body_performResize();
                if (this.get_isEditing()) {
                    this._focusedFieldName = null;
                    this._focus();
                }
            }
        }
    },
    get_enabled: function () {
        return this._enabled == null ? true : this._enabled;
    },
    set_enabled: function (value) {
        this._enabled = value;
    },
    get_showInSummary: function () {
        return this._showInSummary;
    },
    set_showInSummary: function (value) {
        this._showInSummary = value;
    },
    get_summaryFieldCount: function () {
        return this._summaryFieldCount;
    },
    set_summaryFieldCount: function (value) {
        this._summaryFieldCount = value;
    },
    get_showLEVs: function () {
        return this._showLEVs;
    },
    set_showLEVs: function (value) {
        this._showLEVs = value;
    },
    get_tag: function () {
        return this._tag;
    },
    set_tag: function (value) {
        this._tag = value;
    },
    get_pageSize: function () {
        return this._pageSize;
    },
    set_pageSize: function (value) {
        this._pageSize = value;
        this._pageOffset = 0;
        delete this._viewColumnSettings;
        if (Array.indexOf(this._pageSizes, value) == -1) {
            this._pageSizes = Array.clone(this._pageSizes);
            Array.insert(this._pageSizes, 0, value);
        }
        //        if (this._fields != null) {
        //            this.set_pageIndex(-2);
        //            this._loadPage();
        //        }
        if (this._fields != null)
            this.refreshData();
    },
    get_sortExpression: function () {
        return this._sortExpression;
    },
    set_sortExpression: function (value) {
        if (!value || value.length == 0)
            this._sortExpression = null;
        else {
            var expression = value.match(/^(\w+)\s*((asc|desc)|$)/)
            if (expression[2].length == 0)
                if (String.isNullOrEmpty(this._sortExpression) || this._sortExpression.match(/^(\w+)\s*/)[1] != expression[1])
                    this._sortExpression = value + ' asc';
                else if (this._sortExpression.endsWith(' asc'))
                    this._sortExpression = value + ' desc';
                else
                    this._sortExpression = value + ' asc';
            else
                this._sortExpression = value;
        }
    },
    get_filterSource: function () {
        return this._filterSource;
    },
    set_filterSource: function (value) {
        this._filterSource = value;
    },
    get_filterFields: function () {
        return this._filterFields;
    },
    set_filterFields: function (value) {
        this._filterFields = value;
    },
    get_visibleWhen: function () {
        return this._visibleWhen;
    },
    set_visibleWhen: function (value) {
        this._visibleWhen = value;
    },
    get_showQuickFind: function () {
        return this._showQuickFind != false;
    },
    get_quickFindText: function () {
        return String.isNullOrEmpty(this._quickFindText) ? Web.DataViewResources.Grid.QuickFindText : this._quickFindText;
    },
    set_quickFindText: function (value) {
        this._quickFindText = value;
    },
    get_quickFindElement: function () {
        return $get(this.get_id() + '_QuickFind');
    },
    set_showQuickFind: function (value) {
        this._showQuickFind = value;
    },
    get_showRowNumber: function () {
        return this._showRowNumber == true;
    },
    set_showRowNumber: function (value) {
        this._showRowNumber = value;
    },
    get_filter: function () {
        if (this.get_lookupField() == null && (this.get_pageIndex() == -1 && !this._allFields || this._externalFilter.length > 0 && this._filter.length == 0)) {
            if (this.get_domFilterSource()) {
                this._externalFilter = [];
                var fieldNames = this.get_filterFields().split(Web.DataView._simpleListRegex);
                var fieldValues = this.get_domFilterSource().value.split(Web.DataView._simpleListRegex);
                for (var i = 0; i < fieldNames.length; i++)
                    Array.add(this._externalFilter, { Name: fieldNames[i], Value: fieldValues[i] });
            }
            else {
                var params = Web.DataView._commandLine.match(/\?([\s\S]+)/);
                if (params && (this.get_filterSource() != 'None' && this.get_filterSource() == null) && !this.get_useCase()) {
                    this._externalFilter = [];
                    var iterator = /(\w+)=([\S\s]*?)(&|$)/g;
                    var m = iterator.exec(params[1]);
                    while (m) {
                        if (m[1] != 'ReturnUrl') Array.add(this._externalFilter, { Name: m[1], Value: m[2].length == 0 ? String.jsNull : decodeURIComponent(m[2]) });
                        m = iterator.exec(params[1]);
                    }
                }
            }
            this.applyExternalFilter(this.get_isModal());
        }
        else if (this.get_filterSource() == 'Context' && this._externalFilter.length > 0)
            this.applyExternalFilter(true);
        if (this._startupFilter) {
            if (this.readContext('disableStartFilter') != true) {
                Array.addRange(this._filter, this._startupFilter);
                this.writeContext('disableStartFilter', true);
            }
            this._startupFilter = null;
        }
        return this._filter;
    },
    set_filter: function (value) {
        this._filter = value;
    },
    get_startupFilter: function () {
        return this._startupFilter;
    },
    set_startupFilter: function (value) {
        this._startupFilter = value;
    },
    get_externalFilter: function () {
        return this._externalFilter;
    },
    set_externalFilter: function (value) {
        this._externalFilter = value ? value : [];
    },
    get_ditto: function () {
        return this._ditto;
    },
    set_ditto: function (value) {
        this._ditto = value;
    },
    get_modalAnchor: function () {
        return this._modalAnchor;
    },
    set_modalAnchor: function (value) {
        this._modalAnchor = value;
    },
    get_description: function () {
        return this._description;
    },
    set_description: function (value) {
        this._description = value;
    },
    get_isModal: function () {
        return this._modalPopup != null || this._isModal;
    },
    get_categories: function () {
        return this._categories;
    },
    get_fields: function () {
        return this._fields;
    },
    get_rows: function () {
        return this._rows;
    },
    get_selectedRow: function () {
        var extension = this.extension();
        if (extension)
            return this._selectedRow;
        return this._rows ? this._rows[this._selectedRowIndex != null ? this._selectedRowIndex : 0] : [];
    },
    get_pageCount: function () {
        return this._pageCount;
    },
    get_aggregates: function () {
        return this._aggregates;
    },
    get_views: function () {
        return this._views;
    },
    actionGroups: function (scopeList) {
        var result = [],
            groupList = this._actionGroups,
            i, j, k,
            group, action, newGroup,
            scope;
        if (typeof scopeList == 'string')
            scopeList = [scopeList];
        for (k = 0; k < scopeList.length; k++) {
            scope = scopeList[k];
            for (i = 0; i < groupList.length; i++) {
                group = groupList[i];
                newGroup = null;
                if (group.Scope == scope || group.Id == scope) {
                    for (j = 0; j < group.Actions.length; j++) {
                        action = group.Actions[j];
                        if (this._isActionAvailable(action)) {
                            if (!newGroup)
                                result.push(newGroup = { Scope: group.Scope, HeaderText: group.HeaderText, Flat: group.Flat, Id: group.Id, Actions: [] });
                            newGroup.Actions.push(action);
                        }
                    }
                }
            }
        }
        return result;
    },
    actions: function (scope) {
        var groups = this.actionGroups(scope);
        return groups.length ? groups[0].Actions : null;
    },
    get_actionGroups: function (scope, all) {
        var groups = [];
        for (var i = 0; i < this._actionGroups.length; i++) {
            if (this._actionGroups[i].Scope == scope) {
                var group = this._actionGroups[i];
                var current = all ? group : null;
                if (!all) {
                    for (var j = 0; j < group.Actions.length; j++) {
                        if (this._isActionAvailable(group.Actions[j])) {
                            current = this._actionGroups[i]
                            break;
                        }
                    }
                }
                if (current) Array.add(groups, current);
            }
        }
        return groups;
    },
    get_actions: function (scope, all) {
        var result = [];
        for (var i = 0; i < this._actionGroups.length; i++)
            if (this._actionGroups[i].Scope == scope) {
                var ag = this._actionGroups[i];
                if (all)
                    Array.addRange(result, ag.Actions);
                else
                    return ag.Actions;
            }
        return result;
    },
    get_action: function (path) {
        var id = path.split(/\//);
        for (var i = 0; i < this._actionGroups.length; i++) {
            var ag = this._actionGroups[i];
            if (ag.Id == id[0])
                for (var j = 0; j < ag.Actions.length; j++) {
                    var a = ag.Actions[j];
                    if (a.Id == id[1])
                        return a;
                }
        }
        return null;
    },
    get_selectedKey: function () {
        return this._selectedKey;
    },
    set_selectedKey: function (value) {
        this._selectedKey = value;
    },
    get_selectedKeyFilter: function () {
        return this._selectedKeyFilter;
    },
    set_selectedKeyFilter: function (value) {
        this._selectedKeyFilter = value;
    },
    _get_selectedValueElement: function () {
        return $get(String.format('{0}_{1}_SelectedValue', this.get_id(), this.get_controller()));
        //return $get(String.format('{0}$SelectedValue', this.get_id()));
    },
    get_selectedValue: function () {
        var selectedValue = this.readContext('SelectedValue');
        if (selectedValue)
            return selectedValue;
        var sv = this._get_selectedValueElement();
        return sv ? sv.value : '';
    },
    set_selectedValue: function (value) {
        if (this._hasSearchAction) return;
        this.writeContext('SelectedValue', value.toString());
        var selectedValue = this._get_selectedValueElement();
        if (selectedValue)
            selectedValue.value = value != null ? value : '';
    },
    get_keyRef: function () {
        var key = this.get_selectedKey();
        if (!key) return null;
        var ref = '';
        for (var i = 0; i < this._keyFields.length; i++) {
            if (i > 0) ref += '&';
            ref = String.format('{0}{1}={2}', ref, this._keyFields[i].Name, key[i]);
        }
        return ref;
    },
    get_showIcons: function () {
        return this._icons != null && this._lookupField == null || this.get_showRowNumber();
    },
    get_showMultipleSelection: function () {
        return this.multiSelect() && this._hasKey();
    },
    get_sysColCount: function () {
        var count = 0;
        if (this.get_showIcons())
            count++;
        if (this.get_showMultipleSelection())
            count++;
        if (this.get_isDataSheet())
            count++;
        return count;
    },
    _createRowKey: function (index) {
        var r = this._rows[index];
        var v = '';
        for (var i = 0; i < this._keyFields.length; i++) {
            var f = this._keyFields[i];
            if (v.length > 0) v += ',';
            v += r[f.Index].toString()
        }
        return v;
    },
    toggleSelectedRow: function (index) {
        var startIndex = index != null ? index : 0;
        var endIndex = index != null ? index : this._rows.length - 1;
        var btn = $get(this.get_id() + '_ToggleButton');
        for (var i = startIndex; i <= endIndex; i++) {
            var key = this._createRowKey(i);
            var j = Array.indexOf(this._selectedKeyList, key);
            if (j != -1)
                Array.removeAt(this._selectedKeyList, j);
            var checked = index == null ? btn.checked : j == -1;
            if (checked)
                Array.add(this._selectedKeyList, key);
            var cb = $get(this.get_id() + '_CheckBox' + i);
            if (cb) {
                cb.checked = checked;
                if (checked)
                    $(cb).addClass('Selected');
                else
                    $(cb).removeClass('Selected');
                var elem = cb;
                while (elem && elem.tagName != 'TR')
                    elem = elem.parentNode;
                if (checked)
                    $(elem).addClass('MultiSelectedRow');
                else
                    $(elem).removeClass('MultiSelectedRow');
            }
        }
        this._skipCellFocus = this.get_isDataSheet();
        this.set_selectedValue(this._selectedKeyList.join(';'));
        var si = $get(this.get_id() + '$SelectionInfo');
        if (si) si.innerHTML = this._selectedKeyList.length == 0 ? '' : String.format(Web.DataViewResources.Pager.SelectionInfo, this._selectedKeyList.length);
        if (index >= 0)
            this.executeRowCommand(index, 'Select')
        else
            this.delayedRefresh();
    },
    delayedRefresh: function (refresh, delay) {
        if (!delay)
            delay = 1000;
        if (refresh) {
            delete this._delayedRefreshTimer;
            if (!(this._isBusy || Web.DataView._navigated || Sys.Application._disposing))
                this.refresh(true);
        }
        else {
            if (this._delayedRefreshTimer)
                clearTimeout(this._delayedRefreshTimer);
            var self = this;
            this._delayedRefreshTimer = setTimeout(function () {
                self.delayedRefresh(true);
            }, delay);
        }
    },
    get_view: function (id) {
        if (!id) id = this.get_viewId();
        if (!this._view || this._view.Id != id) {
            for (var i = 0; i < this._views.length; i++)
                if (this._views[i].Id == id) {
                    this._view = this._views[i];
                    break;
                }
        }
        return this._view;
    },
    get_viewType: function (id) {
        var view = this.get_view(id);
        if (this._viewTypes) {
            var t = this._viewTypes[view ? view.Id : id];
            if (t != null)
                return t;
        }
        return view ? view.Type : null;
    },
    get_isGrid: function (id) {
        var type = this.get_viewType(id);
        return type == 'Grid' || type == 'DataSheet'/* || type == 'Tree'*/;
    },
    get_isForm: function (id) {
        var type = this.get_viewType(id);
        return type == 'Form';
    },
    get_isDataSheet: function (id) {
        var type = this.get_viewType(id);
        if (__tf != 4) return false;
        if (this._viewTypes) {
            var t = this._viewTypes[this.get_viewId()];
            if (t != null)
                type = t;
        }
        return type == 'DataSheet';
    },
    /*get_isTree: function (id) {
    var type = this.get_viewType(id);
    return type == 'Tree' && __tf == 4;
    },*/
    get_isChart: function () {
        return this.get_viewType() == 'Chart';
    },
    get_lastViewId: function () {
        return this._lastViewId;
    },
    set_lastViewId: function (value) {
        this._lastViewId = value;
    },
    get_lastCommandName: function () {
        return this._lastCommandName;
    },
    set_lastCommandName: function (value) {
        this._lastCommandName = value;
        this._lastCommandArgument = null;
        $closeHovers();
    },
    get_lastCommandArgument: function () {
        return this._lastCommandArgument;
    },
    set_lastCommandArgument: function (value) {
        this._lastCommandArgument = value;
    },
    get_isEditing: function () {
        return (this._lastCommandName == 'New' || this._lastCommandName == 'Edit' || this._lastCommandName == 'BatchEdit' || this._lastCommandName == 'Duplicate') && this._editing == null || this._editing == true;
    },
    get_isInserting: function () {
        return this._lastCommandName == 'New' || this._lastCommandName == 'Duplicate';
    },
    get_lookupField: function () {
        return this.get_mode() == Web.DataViewMode.View ? this._lookupField : this._fields[0];
    },
    set_lookupField: function (value) {
        this._lookupField = value;
    },
    get_lookupContext: function () {
        var f = this.get_lookupField();
        return f ? { 'FieldName': f.Name, 'Controller': f._dataView.get_controller(), 'View': f._dataView.get_viewId()} : null;
    },
    get_mode: function () {
        return this._mode;
    },
    set_mode: function (value) {
        this._mode = value;
    },
    get_lookupValue: function () {
        return this._lookupValue;
    },
    set_lookupValue: function (value) {
        this._lookupValue = value;
    },
    get_lookupText: function () {
        return this._lookupText;
    },
    set_lookupText: function (value) {
        this._lookupText = value;
    },
    get_lookupPostBackExpression: function () {
        return this._lookupPostBackExpression;
    },
    set_lookupPostBackExpression: function (value) {
        this._lookupPostBackExpression = value;
    },
    get_domFilterSource: function () {
        return this._domFilterSource;
    },
    set_domFilterSource: function (value) {
        this._domFilterSource = value;
    },
    get_showDetailsInListMode: function () {
        return this._showDetailsInListMode != false;
    },
    set_showDetailsInListMode: function (value) {
        this._showDetailsInListMode = value;
    },
    get_autoHide: function () {
        return !String.isNullOrEmpty(this.get_visibleWhen()) ? Web.AutoHideMode.Self : this._autoHide == null ? Web.AutoHideMode.Nothing : this._autoHide;
    },
    set_autoHide: function (value) {
        this._autoHide = value;
    },
    get_transaction: function () {
        return this._transaction;
    },
    set_transaction: function (value) {
        this._transaction = value;
    },
    initialize: function () {
        Web.DataView.callBaseMethod(this, 'initialize');
        this._bodyKeydownHandler = Function.createDelegate(this, this._bodyKeydown);
        this._filterSourceSelectedHandler = Function.createDelegate(this, this._filterSourceSelected);
        this._quickFindHandlers = {
            'focus': this._quickFind_focus,
            'blur': this._quickFind_blur,
            'keydown': this._quickFind_keydown
        }
        this._checkMaxLengthHandler = function (e) {
            var maxLen = parseInt(this.getAttribute('maxlength'));
            if (this.value.length > maxLen) {
                this.value = this.value.substr(0, maxLen);
                e.preventDefault();
                e.stopPropagation();
            }
        };
    },
    dispose: function () {
        if (!Sys.Application._disposing) {
            $(this._element).find('iframe').remove();
            this._detachBehaviors();
        }
        var extension = this.extension();
        if (extension && extension.dispose)
            extension.dispose();
        this._wsRequest = null;
        this._stopInputListener();
        this._disposeModalPopup();
        this._disposeFieldFilter();
        this._disposeSearchBarExtenders();
        this._disposeImport();
        this._disposeFields();
        this._lookupField = null;
        this._parentDataView = null;
        this._bodyKeydownHandler = null;
        this._filterSourceSelectedHandler = null;
        this._restoreEmbeddedViews();
        delete this._container;
        Web.DataView.callBaseMethod(this, 'dispose');
    },
    get_master: function () {
        var filterSource = this.get_filterSource();
        return filterSource ? Web.DataView.find(filterSource) : null;
    },
    get_isTagged: function (tag) {
        return this._tag && Array.contains(this._tag.split(Web.DataView._simpleListRegex), tag);
    },
    updated: function () {
        Web.DataView.callBaseMethod(this, 'updated');
        if (!this._controller) return;
        if (this.get_servicePath().startsWith('http'))
            this.set_baseUrl(this.get_siteUrl());
        var selectedValue = this.get_selectedValue();
        if (selectedValue.length > 0) {
            this.set_autoHighlightFirstRow(false);
            this.set_autoSelectFirstRow(false);
            if (this.multiSelect())
                this._selectedKeyList = selectedValue.split(';');
            else {
                this._selectedKey = selectedValue.split(',');
                this._pendingSelectedEvent = true;
            }
        }
        if (this._container == null) {
            this.get_element().innerHTML = '';
            this._container = document.createElement('div');
            this.get_element().appendChild(this._container);
            $(this._container).addClass('DataViewContainer');
            var elementId = this._element.id;
            var idMatch = elementId.split(/_/);
            Sys.UI.DomElement.addCssClass(this._container, idMatch ? idMatch[idMatch.length - 1] : elementId);
            if (!this.get_showActionBar())
                $(this._container).addClass('ActionBarHidden');
            if (!this.get_showDescription())
                $(this._container).addClass('DescriptionHidden');
        }
        if (this.get_filterSource() && this.get_filterSource() != 'Context') {
            var source = this.get_master();
            if (source) {
                this._hasParent = true;
                source.add_selected(this._filterSourceSelectedHandler);
                if (this.get_transaction() == 'Supported')
                    if (!String.isNullOrEmpty(source.get_transaction())) {
                        this.set_transaction(source.get_transaction() != 'Supported' ? source.get_transaction() : null);
                        this._forceVisible = this.get_transaction() && source.get_isInserting();
                    }
                if (source._pendingSelectedEvent && !$appfactory.mobile) {
                    this._source = source;
                    var self = this;
                    this._afterUpdateTimerId = setInterval(function () {
                        self._afterUpdate();
                    }, 250);
                }
                else if (!this._forceVisible)
                    this._hidden = true;
            }
            else {
                source = $get(this.get_filterSource());
                if (source) $addHandler(source, 'change', this._filterSourceSelectedHandler);
                this.set_domFilterSource(source);
            }
            if (this._externalFilter.length == 0)
                this._createExternalFilter();
            if (this._filter.length == 0)
                if (!this._source) this.applyExternalFilter();
        }
        else {
            this._hidden = !this._evaluateVisibility();
            if (this._hidden)
                this._updateLayoutContainerVisibility(false);
        }
        if (this.get_transaction() == 'Supported')
            this.set_transaction(null);
        if (!$appfactory.mobile && this.get_modalAnchor() && !this.get_isModal())
            this._initializeModalPopup();
        if (source != null && this.get_autoHide() != Web.AutoHideMode.Nothing)
            this._updateLayoutContainerVisibility(false);
        if (this.get_startCommandName() == 'UseTransaction') {
            this._usesTransaction = true;
            this.set_startCommandName(null);
        }
        if (this.get_startCommandName() == 'DetectTransaction')
            if (!this.get_transaction()) {
                if (source && Web.DataView.isInstanceOfType(source)) {
                    source.remove_selected(this._filterSourceSelectedHandler);
                    clearInterval(this._afterUpdateTimerId);
                }
                return;
            }
            else
                this.set_startCommandName(null);
        var commandLine = Web.DataView.get_commandLine();
        var command = commandLine.match(/_commandName=(.+?)&_commandArgument=(.*?)(&|$)/);
        if (command && (String.isNullOrEmpty(this.get_startCommandName()) || __designer()) && !this.get_filterSource() && !this.get_isModal() && !this.get_lookupField()) {
            var tc = commandLine.match(/_controller=(\w+)/);
            var tv = commandLine.match(/_view=(\w+)/);
            if ((!tc || tc[1] == this.get_controller()) && (!tv || tv[1] == this.get_view())) {
                this._trySecondCommand = !String.isNullOrEmpty(tc);
                this.set_startCommandName(command[1]);
                this.set_startCommandArgument(command[2]);
                if (!String.isNullOrEmpty(this._viewId)) this._replaceTriggerViewId = this._viewId;
                //this._skipRender = true;
                this._skipTriggeredView = true;
            }
        }
        var isMobile = $appfactory.mobile;
        if (this.get_startCommandName()) {
            this.set_searchOnStart(false);
            this.set_lastCommandName(this.get_startCommandName());
            this.set_lastCommandArgument(this.get_startCommandArgument());
            if (this.get_startCommandName().match(/New|Edit|Select/))
                this.set_viewId(this.get_startCommandArgument());
            this.set_startCommandName(null);
            this.set_startCommandArgument(null);
            this._rows = [];
            if (!isMobile)
                this._loadPage();

        }
        else
            this.loadPage();
        if (isMobile)
            this.mobileUpdated();
    },
    _afterUpdate: function () {
        if (this._delayedLoading && this._source._pendingSelectedEvent || this._source._isBusy) return;
        clearInterval(this._afterUpdateTimerId);
        var source = this._source;
        this._source = null;
        this._filterSourceSelected(source, Sys.EventArgs.Empty, true);
    },
    dataAttr: function (element, name, value) {
        var $elem = $(element);
        var dataAttrName = 'data-' + name;
        if (!value) {
            value = $elem.attr(dataAttrName);
            if (!value)
                value = $elem.attr('factory:' + name);
            return value;
        }
        else
            $elem.attr(dataAttrName, value);
    },
    _updateLayoutContainerVisibility: function (visible) {
        if ($appfactory.mobile) {
            this._hidden = !visible;
            return;
        }
        if (this._forceVisible) visible = true;
        var c = this._element.parentNode;
        if (String.isNullOrEmpty(c.getAttribute('data-visibility-controller')))
            c.setAttribute('data-visibility-controller', this.get_id());
        var activator = !String.isNullOrEmpty(this.dataAttr(c, 'activator')) ? this.dataAttr(c, 'activator').match(/^\s*(\w+)\s*\|\s*(.+)\s*$/) : null;
        if (this.get_autoHide() == Web.AutoHideMode.Self) {
            this._element.style.display = visible ? '' : 'none';
            if (!visible)
                visible = $(this._element).siblings().is(':visible');
            var tabBar = c.parentNode.childNodes[0];
            while (tabBar.tagName != 'DIV')
                tabBar = tabBar.nextSibling;
            if (activator && activator[1] == 'Tab' && Sys.UI.DomElement.containsCssClass(tabBar, 'TabBar')) {
                if (c.getAttribute('data-visibility-controller') == this.get_id()) {
                    var tabIndex = -1;
                    for (var i = 0; i < c.parentNode.childNodes.length; i++) {
                        var n = c.parentNode.childNodes[i];
                        if (n.className && Sys.UI.DomElement.containsCssClass(n, 'TabBody')) tabIndex++;
                        if (c == n) break;

                    }
                    if (tabIndex != -1) {
                        var menuCells = tabBar.getElementsByTagName('td');
                        var menuCell = menuCells[tabIndex];
                        menuCell.style.display = visible ? '' : 'none';
                        if (!visible && Sys.UI.DomElement.containsCssClass(menuCell, 'Selected')) {
                            var links = tabBar.getElementsByTagName('a');
                            for (i = 0; i < menuCells.length; i++) {
                                if ($common.getVisible(menuCells[i])) {
                                    $find(c.parentNode.id + '$ActivatorMenu').select(i, links[i]);
                                    break;
                                }
                            }
                        }
                    }
                }
            }
            else
                this.dataAttr(c, 'hidden', !visible);
        }
        else {
            if (activator && activator[1] == 'SideBarTask')
                this.dataAttr(c, 'hidden', true);
            while (c) {
                if (!String.isNullOrEmpty(this.dataAttr(c, 'flow'))) {
                    c.style.display = visible ? '' : 'none';
                    break;
                }
                c = c.parentNode;
            }
        }
        var sideBar = $get('PageContentSideBar');
        if (sideBar && activator) {
            var tasks = sideBar.getElementsByTagName('a');
            for (i = 0; i < tasks.length; i++) {
                var l = tasks[i];
                if (Sys.UI.DomElement.containsCssClass(l.parentNode, 'Task') && l.innerHTML == activator[2]) {
                    l.parentNode.style.display = visible ? '' : 'none';
                    break;
                }
            }
        }
        if (Web.DataView._loaded) _body_performResize();
    },
    loadPage: function (showWait) {
        if ($appfactory.mobile) return;
        var displayed = this.get_isDisplayed();
        this._showWait(!displayed);
        if (this.get_mode() != Web.DataViewMode.View || (this.get_lookupField() || !(this._delayedLoading = !displayed))) {
            if (!this._source)
                this._loadPage();
        }
        else if (!Array.contains($appfactory._delayedLoadingViews, this)) {
            Array.add($appfactory._delayedLoadingViews, this);
            $appfactory._startDelayedLoading();
        }
    },
    get_isDisplayed: function () {
        if (this._hidden) return false;
        var elem = this.get_element(),
            node;
        if (!elem)
            return false;
        node = elem && elem.parentNode;
        while (node != null) {
            if (node.getAttribute && node.tagName != 'TABLE' && this.dataAttr(node, 'activator') && !node._activated)
                return false;
            if (node.style && node.style.display == 'none')
                return false;
            node = node.parentNode;
        }
        return true;
    },
    goToPage: function (pageIndex, absolute) {
        if (this._isBusy) return;
        if (absolute)
            this._pageOffset = 0;
        //if (this.get_isDataSheet())
        //    delete this._viewColumnSettings;
        this.set_pageIndex(pageIndex);
        this._loadPage();
    },
    sort: function (sortExpression) {
        if (this._isBusy) return;
        this._clearCache();
        if (this.get_sortExpression() == sortExpression) sortExpression = '';
        this.set_sortExpression(sortExpression);
        if (this.get_selectedKey().length > 0) {
            this._saveViewVitals()
            this._sync();
        }
        else {
            this.set_pageIndex(0);
            this._loadPage();
        }
    },
    applyFilterByIndex: function (fieldIndex, valueIndex) {
        if (valueIndex == -1)
            this.removeFromFilterByIndex(fieldIndex);
        else {
            var filterField = this._allFields[fieldIndex];
            var field = this.findFieldUnderAlias(filterField);
            this.applyFilter(filterField, valueIndex >= 0 ? '=' : null, valueIndex >= 0 ? field._listOfValues[valueIndex] : null);
        }
    },
    findFieldUnderAlias: function (aliasField) {
        if (aliasField.Hidden)
            for (var i = 0; i < this._allFields.length; i++)
                if (this._allFields[i].AliasIndex == aliasField.Index) return this._allFields[i];
        return aliasField;
    },
    removeFromFilterByIndex: function (index) {
        field = this._allFields[index];
        this.removeFromFilter(field);
        this.sync();
    },
    removeFromFilter: function (field) {
        for (var i = 0; i < this._filter.length; i++) {
            if (this._filter[i].match(/^(\w+):/)[1] == field.Name) {
                Array.removeAt(this._filter, i);
                break;
            }
        }
    },
    clearFilter: function () {
        for (var i = 0; i < this._allFields.length; i++) {
            var f = this._allFields[i];
            var af = this.findFieldUnderAlias(f);
            if (this.filterOf(f) != null && !this.filterIsExternal(f.Name))
                this.removeFromFilter(f);
        }
        var qfe = this.get_quickFindElement();
        if (qfe != null) {
            qfe.value = '';
            this.quickFind();
        }
        else {
            this.set_quickFindText(null);
            this._executeQuickFind(null);
        }
    },
    beginFilter: function () {
        this._filtering = true;
    },
    endFilter: function () {
        this._filtering = false;
        this.refreshData();
        //this.set_pageIndex(-2);
        //this._loadPage();
    },
    applyFilter: function (field, operator, value) {
        this._clearCache();
        this.removeFromFilter(field);
        if (operator == ':') {
            if (value) Array.add(this._filter, field.Name + ':' + value);
        }
        else if (operator) Array.add(this._filter, field.Name + ':' + operator + this.convertFieldValueToString(field, value));
        var keepFieldValues = (this._filter.length == 1 && this._filter[0].match(/(\w+):/)[1] == field.Name);
        field = this.findFieldUnderAlias(field);
        for (i = 0; i < this._allFields.length; i++)
            if (!keepFieldValues || this._allFields[i].Name != field.Name) this._allFields[i]._listOfValues = null;
        //        if (this._filtering != true) {
        //            this.set_pageIndex(-2);
        //            this._loadPage();
        //        }
        if (this._filtering != true)
            this._sync(); //this.refreshData();
        //this._forgetSelectedRow(true);
    },
    applyExternalFilter: function (preserveFilter) {
        if (!preserveFilter || !this._filter) this._filter = [];
        this._selectedRowIndex = null;
        for (var i = 0; i < this._externalFilter.length; i++) {
            var filterItem = this._externalFilter[i];
            if (preserveFilter) {
                for (var j = 0; j < this._filter.length; j++) {
                    if (this._filter[j].startsWith(filterItem.Name + ':=')) {
                        Array.removeAt(this._filter, j);
                        break;
                    }
                }
            }
            Array.add(this._filter, filterItem.Name + ':=' + filterItem.Value);
        }
    },
    applyFieldFilter: function (fieldIndex, func, values, defer) {
        if (fieldIndex == null)
            fieldIndex = this._filterFieldIndex;
        if (!func)
            func = this._filterFieldFunc;
        var field = this._allFields[fieldIndex];
        this.removeFromFilter(field);
        //var filter = field.Name + ':';
        var filter = String.format('{0}:', field.Name, field.Type);

        if (values && values[0] == Web.DataViewResources.HeaderFilter.EmptyValue)
            values[0] = String.jsNull;
        if (!values)
            filter += func + '$\0';
        else if (func == '$between')
            filter += '$between$' + this.convertFieldValueToString(field, values[0]) + '$and$' + this.convertFieldValueToString(field, values[1]) + '\0';
        else
            for (var i = 0; i < values.length; i++)
                filter += func + (func.startsWith('$') ? '$' : '') + this.convertFieldValueToString(field, values[i]) + '\0';
        if (filter.indexOf('\0') > 0) Array.add(this._filter, filter);
        //        if (!defer) {
        //            this.set_pageIndex(-2);
        //            this._loadPage();
        //        }
        if (!defer)
            this.refreshData();
        this._forgetSelectedRow(true);
    },
    get_fieldFilter: function (field, extractFunction) {
        for (var i = 0; i < this._filter.length; i++) {
            var m = this._filter[i].match(/(\w+):(\*|\$\w+\$|=|~|>=?|<(=|>){0,1})([\s\S]*)/);
            if (m[1] == field.Name) {
                if (extractFunction) {
                    var s = m[2];
                    return s.startsWith('$') ? s.substring(0, s.length - 1) : s;
                }
                else
                    return m[4];
                break;
            }
        }
        return null;
    },
    _createFieldInputExtender: function (type, field, input, index) {
        var c = null;
        if (field.Type.startsWith('DateTime')) {
            c = $create(AjaxControlToolkit.CalendarBehavior, { id: String.format('{0}_{1}Calendar{2}_{3}', this.get_id(), type, field.Index, index), button: input.nextSibling }, null, null, input);
            c.set_format(field.DataFormatString.match(/\{0:([\s\S]*?)\}/)[1]);
        }
        else if (field.AllowQBE && field.Type == 'String' && field.AllowAutoComplete != false) {
            c = $create(Web.AutoComplete, {
                'completionInterval': 500,
                'contextKey': String.format('{0}:{1},{2}', type, this.get_id(), field.Name),
                'delimiterCharacters': ';',
                'id': String.format('{0}_{1}AutoComplete{2}_{3}', this.get_id(), type, field.Index, index),
                'minimumPrefixLength': field.AutoCompletePrefixLength == 0 ? 1 : field.AutoCompletePrefixLength,
                'serviceMethod': 'GetListOfValues',
                'servicePath': this.get_servicePath(),
                'useContextKey': true,
                'enableCaching': type != 'SearchBar',
                'typeCssClass': type
            },
                null, null, input);
            c._updateClearButton();
        }
        return c;
    },
    showFieldFilter: function (fieldIndex, func, text) {
        if (!this._filterExtenders) this._filterExtenders = [];
        var field = this._allFields[fieldIndex];
        var filter = this.get_fieldFilter(field);
        if (filter) {
            var vm = filter.match(/^([\s\S]*?)(\0|$)/);
            if (vm) filter = vm[1];
        }
        filter = filter && !String.isJavaScriptNull(filter) ? filter.split(Web.DataView._listRegex) : [''];
        this._filterFieldIndex = fieldIndex;
        this._filterFieldFunc = func;
        var filterElement = this._filterElement = document.createElement('div');
        filterElement.id = this.get_id() + '$FieldFilter';
        filterElement.className = 'FieldFilter';
        var sb = new Sys.StringBuilder();
        var button = field.Type.startsWith('DateTime') ? '<a class="Calendar" href="javascript:" onclick="return false">&nbsp;</a>' : '';
        sb.appendFormat('<div class="Field"><div class="Label"><span class="Name">{0}</span> <span class="Function">{1}</span></div><div class="Value"><input type="text" value="{2}"/>{3}</div></div>', field.HeaderText, text.toLowerCase(), Web.DataView.htmlAttributeEncode(field.format(this.convertStringToFieldValue(field, filter[0]))), button);
        if (func == '$between')
            sb.appendFormat('<div class="Field"><div class="Label"><span class="Function">{0}</span></div><div class="Value"><input type="text" value="{1}"/>{2}</div></div>', Web.DataViewResources.Data.Filters.Labels.And, Web.DataView.htmlAttributeEncode(filter[1] ? field.format(this.convertStringToFieldValue(field, filter[1])) : ''), button);
        sb.appendFormat('<div class="Buttons"><button onclick="$find(\'{0}\').closeFieldFilter(true);return false">{1}</button><button onclick="$find(\'{0}\').closeFieldFilter(false);return false">{2}</button></div>', this.get_id(), Web.DataViewResources.ModalPopup.OkButton, Web.DataViewResources.ModalPopup.CancelButton);
        filterElement.innerHTML = sb.toString();
        //document.body.appendChild(this._filterElement);
        this._appendModalPanel(filterElement);
        this._filterPopup = $create(AjaxControlToolkit.ModalPopupBehavior, { 'id': this.get_id() + '$FilterPopup', PopupControlID: filterElement.id, DropShadow: true, BackgroundCssClass: 'ModalBackground' }, null, null, this._container.getElementsByTagName('a')[0]);
        var inputList = filterElement.getElementsByTagName('input');
        for (var i = 0; i < inputList.length; i++) {
            var input = inputList[i];
            var c = this._createFieldInputExtender('Filter', field, input, i);
            if (c) Array.add(this._filterExtenders, c);
        }
        this._saveTabIndexes();
        this._filterPopup.show();
        //inputList[0].focus();
        Sys.UI.DomElement.setFocus(inputList[0]);
        $(filterElement).find('input:text').keydown(function (event) {
            if (event.which == 13) {
                event.preventDefault();
                $(filterElement).find('button:first').click();
            }
        });
    },
    closeFieldFilter: function (apply) {
        var inputList = this._filterElement.getElementsByTagName('input');
        var values = [];
        if (apply) {
            var field = this._allFields[this._filterFieldIndex];
            for (var i = 0; i < inputList.length; i++) {
                var input = inputList[i];
                if (String.isBlank(input.value)) {
                    alert(Web.DataViewResources.Validator.RequiredField);
                    Sys.UI.DomElement.setFocus(input);
                    //input.focus();
                    return;
                }
                else {
                    this._formatSearchField(input, this._filterFieldIndex);
                    var v = { NewValue: input.value.trim() };
                    var error = this._validateFieldValueFormat(field, v);
                    if (error) {
                        alert(error);
                        Sys.UI.DomElement.setFocus(input);
                        //input.focus();
                        //input.select();
                        return;
                    }
                    else
                        Array.add(values, field.Type.startsWith('DateTime') ? input.value.trim() : v.NewValue);
                }
            }
        }
        this._disposeFieldFilter();
        this._restoreTabIndexes();
        if (apply)
            this.applyFieldFilter(null, null, values);
    },
    _disposeSearchBarExtenders: function () {
        if (this._searchBarExtenders) {
            for (var i = 0; i < this._searchBarExtenders.length; i++)
                this._searchBarExtenders[i].dispose();
            Array.clear(this._searchBarExtenders);
        }
    },
    _disposeFieldFilter: function () {
        if (this._filterExtenders) {
            for (var i = 0; i < this._filterExtenders.length; i++)
                this._filterExtenders[i].dispose();
            Array.clear(this._filterExtenders);
        }
        if (this._filterElement) {
            this._filterPopup.hide();
            this._filterPopup.dispose();
            this._filterPopup = null;
            this._filterElement.parentNode.removeChild(this._filterElement);
            delete this._filterElement;
        }
    },
    _showSearchBarFilter: function (fieldIndex, visibleIndex) {
        this._searchBarVisibleIndex = visibleIndex;
        if (fieldIndex == -1) {
            var elem = this._get('$SearchBarValue$', visibleIndex);
            elem.value = '';
            this._searchBarFuncChanged(visibleIndex);
            this._searchBarVisibleIndex = null;
        }
        else
            this.showCustomFilter(fieldIndex);
    },
    _appendModalPanel: function (elem) {
        this.get_element().appendChild(elem);
    },
    showCustomFilter: function (fieldIndex) {
        var field = this._allFields[fieldIndex];
        var panel = this._customFilterPanel = document.createElement('div');
        //this.get_element().appendChild(panel);
        this._appendModalPanel(panel);
        panel.className = 'CustomFilterDialog';
        panel.id = this.get_id() + '_CustomFilterPanel';
        var sb = new Sys.StringBuilder();
        sb.appendFormat('<div><span class="Highlight">{0}</span> {1}:</div>', Web.DataView.htmlEncode(field.Label), Web.DataViewResources.Data.Filters.Labels.Includes);
        sb.append('<table cellpadding="0" cellspacing="0">');
        sb.appendFormat('<tr><td colspan="2"><div id="{0}$CustomFilterItemList${1}" class="CustomFilterItems">{2}</div></td></tr>', this.get_id(), fieldIndex, Web.DataViewResources.Common.WaitHtml);
        sb.appendFormat('<tr><td></td><td align="right"><button id="{0}Ok">{1}</button> <button id="{0}Cancel">{2}</button></td></tr>', this.get_id(), Web.DataViewResources.ModalPopup.OkButton, Web.DataViewResources.ModalPopup.CancelButton);
        sb.append('</table>');
        panel.innerHTML = sb.toString();
        sb.clear();
        this._customFilterField = field;
        this._customFilterModalPopupBehavior = $create(AjaxControlToolkit.ModalPopupBehavior, {
            OkControlID: this.get_id() + 'Ok', CancelControlID: this.get_id() + 'Cancel', OnOkScript: String.format('$find("{0}").applyCustomFilter()', this.get_id()), OnCancelScript: String.format('$find("{0}").closeCustomFilter()', this.get_id()),
            PopupControlID: panel.id, DropShadow: true, BackgroundCssClass: 'ModalBackground'
        }, null, null, this._container.getElementsByTagName('a')[0]);
        this._customFilterModalPopupBehavior.show();
        $addHandler(document.body, 'keydown', this._bodyKeydownHandler);
        var originalField = this.findFieldUnderAlias(field);
        //if (originalField._listOfValues && this._searchBarVisibleIndex == null)
        //    this._onGetFilterListOfValuesComplete(originalField._listOfValues, { 'fieldName': field.Name });
        //else
        //    this._loadFilterListOfValues(field.Name);
        this._loadFilterListOfValues(field.Name);
    },
    _loadFilterListOfValues: function (fieldName) {
        this._busy(true);
        var lc = this.get_lookupContext();
        this._invoke('GetListOfValues', this._createArgsForListOfValues(fieldName), Function.createDelegate(this, this._onGetFilterListOfValuesComplete), { 'fieldName': fieldName });
    },
    _renderFilterOption: function (sb, field, v, index, selected) {
        var item = this._findItemByValue(field, v);
        if (item)
            v = item[1];
        sb.appendFormat('<tr><td class="Input"><input type="checkbox" id="{0}$CustomFilterItem{1}${2}"{4}/></td><td class="Label"><label for="{0}$CustomFilterItem{1}${2}">{3}</label></td></tr>', this.get_id(), field.Index, index, v, selected ? ' checked="checked"' : '');
    },
    _onGetFilterListOfValuesComplete: function (result, context) {
        this._busy(false);
        var field = this.findField(context.fieldName);
        this.findFieldUnderAlias(field)._listOfValues = result;
        if (result[result.length - 1] == null) {
            Array.insert(result, 0, result[result.length - 1]);
            Array.removeAt(result, result.length - 1);
        }
        var itemsElem = this._get('$CustomFilterItemList$', field.Index);
        if (!itemsElem) return;

        var currentFilter = this._searchBarVisibleIndex != null ? this._createSearchBarFilter(true) : this._filter;
        var customFilter = null;
        for (var i = 0; i < currentFilter.length; i++) {
            var m = currentFilter[i].match(Web.DataView._fieldFilterRegex);
            if (m[1] == field.Name) {
                customFilter = m[2];
                break;
            }
        }
        var listOfValues = null;
        var func = '$in$';
        if (customFilter) {
            m = customFilter.match(Web.DataView._filterRegex);
            if (m) {
                if (m[1].match(/\$(in|notin|between)\$/)) {
                    func = m[1];
                    listOfValues = m[3].split(Web.DataView._listRegex);
                }
                else
                    listOfValues = [m[3]];
                for (i = 0; i < listOfValues.length; i++) {
                    var v = listOfValues[i];
                    if (String.isJavaScriptNull(v))
                        listOfValues[i] = Web.DataViewResources.HeaderFilter.EmptyValue;
                    else {
                        v = this.convertStringToFieldValue(field, v);
                        listOfValues[i] = field.format(v);
                    }
                }
            }
        }

        var sb = new Sys.StringBuilder();

        sb.appendFormat('<table class="FilterItems" cellpadding="0" cellspacing="0"><tr><td><input type="CheckBox" onclick="$find(\'{0}\')._selectAllFilterItems({1})" id="{0}$CustomFilterItemList$SelectAll"/></td><td><label for="{0}$CustomFilterItemList$SelectAll">{2}</label></td></tr>', this.get_id(), field.Index, Web.DataViewResources.Data.Filters.Labels.SelectAll);

        /*for (i = 0; i < result.length; i++) {
        v = result[i];
        if (v == null)
        v = Web.DataViewResources.HeaderFilter.EmptyValue;
        else {
        v = Web.DataView.htmlEncode(field.format(v));
        if (v == '') v = Web.DataViewResources.HeaderFilter.BlankValue;
        }
        var selected = listOfValues && ((func == '$in$' && Array.contains(listOfValues, v)) || (func == '$notin$' && !Array.contains(listOfValues, v)));
        sb.appendFormat('<tr><td class="Input"><input type="checkbox" id="{0}$CustomFilterItem{1}${2}"{4}/></td><td class="Label"><label for="{0}$CustomFilterItem{1}${2}">{3}</label></td></tr>', this.get_id(), field.Index, i, v, selected ? ' checked="checked"' : '');
        }
        */

        var selectedValues = [];
        var selectedStrings = [];
        var otherValues = [];
        var otherStrings = [];
        for (i = 0; i < result.length; i++) {
            v = result[i];
            var v2 = v;
            if (v == null)
                v = Web.DataViewResources.HeaderFilter.EmptyValue;
            else {
                v = Web.DataView.htmlEncode(field.format(v));
                if (v == '') v = Web.DataViewResources.HeaderFilter.BlankValue;
            }
            var selected = listOfValues && ((func == '$in$' && Array.contains(listOfValues, v)) || (func == '$notin$' && !Array.contains(listOfValues, v)));
            if (selected) {
                Array.add(selectedStrings, v);
                Array.add(selectedValues, v2);
            }
            else {
                Array.add(otherStrings, v);
                Array.add(otherValues, v2);
            }
        }
        for (i = 0; i < selectedStrings.length; i++)
            this._renderFilterOption(sb, field, selectedStrings[i], i, true);
        for (i = 0; i < otherStrings.length; i++)
            this._renderFilterOption(sb, field, otherStrings[i], i + selectedStrings.length, false);

        sb.append('</table>');
        itemsElem.innerHTML = sb.toString();
        //itemsElem.getElementsByTagName('input')[0].focus();
        Sys.UI.DomElement.setFocus(itemsElem.getElementsByTagName('input')[0]);
        if (selectedValues.length > 0) {
            field._listOfValues = [];
            Array.addRange(field._listOfValues, selectedValues);
            Array.addRange(field._listOfValues, otherValues);
        }
    },
    _selectAllFilterItems: function (fieldIndex) {
        var itemsElem = this._get('$CustomFilterItemList$', fieldIndex);
        var list = itemsElem.getElementsByTagName('input');
        for (var i = 1; i < list.length; i++)
            list[i].checked = list[0].checked;
    },
    applyCustomFilter: function () {
        var field = this._customFilterField;
        var searchBarValue = this._searchBarVisibleIndex != null ? this._get('$SearchBarValue$', this._searchBarVisibleIndex) : null;
        var searchBarFunc = searchBarValue ? this._get('$SearchBarFunction$', this._searchBarVisibleIndex) : null;
        this.removeFromFilter(field);
        var filter = null
        var itemsElem = this._get('$CustomFilterItemList$', field.Index);
        var list = itemsElem.getElementsByTagName('input');
        var originalField = this.findFieldUnderAlias(field);
        var numberOfOptions = 0;
        for (var i = 1; i < list.length; i++)
            if (list[i].checked) {
                if (!filter)
                    filter = '';
                else
                    filter += '$or$';
                filter += this.convertFieldValueToString(field, originalField._listOfValues[i - 1]);
                numberOfOptions++;

            }
        if (filter && (numberOfOptions <= 10 || numberOfOptions != list.length - 1)) {
            if (numberOfOptions <= 10 || numberOfOptions <= (list.length - 1) / 2) {
                if (searchBarValue)
                    searchBarFunc.value = '$in,true';
                else
                    Array.add(this._filter, String.format('{0}:$in${1}\0', this._customFilterField.Name, filter));
            }
            else {
                filter = null;
                for (i = 1; i < list.length; i++)
                    if (!list[i].checked) {
                        if (!filter)
                            filter = '';
                        else
                            filter += '$or$';
                        filter += this.convertFieldValueToString(field, originalField._listOfValues[i - 1]);
                    }
                if (searchBarValue)
                    searchBarFunc.value = '$notin,true';
                else
                    Array.add(this._filter, String.format('{0}:$notin${1}\0', this._customFilterField.Name, filter));
            }
        }
        else
            filter = null;

        for (i = 0; i < this._allFields.length; i++) {
            var f = this._allFields[i];
            if (f != originalField)
                f._listOfValues = null;
        }
        if (searchBarValue) {
            searchBarValue.value = filter ? filter : '';
            this._searchBarFuncChanged(this._searchBarVisibleIndex);
        }
        //        else {
        //            this.set_pageIndex(-2);
        //            this._loadPage();
        //        }
        else {
            this._forceSync();
            this.refreshData();
        }
        this.closeCustomFilter();
        //this._forgetSelectedRow(true);
    },
    //    applyCustomFilter2: function () {
    //        this.removeFromFilter(this._customFilterField);
    //        var iterator = /\s*(=|<={0,1}|>={0,1}|)\s*([\S\s]+?)\s*(,|;|$)/g;
    //        var filter = this._customFilterField.Name + ':';
    //        var s = $get(this.get_id() + '_Query').value;
    //        var match = iterator.exec(s);
    //        while (match) {
    //            if (!String.isBlank(match[2]))
    //                filter += (match[1] ? match[1] : (this._customFilterField.Type == 'String' ? '*' : '=')) + match[2] + '\0';
    //            match = iterator.exec(s);
    //        }
    //        if (filter.indexOf('\0') > 0) Array.add(this._filter, filter);
    //        this.set_pageIndex(-2);
    //        this._loadPage();
    //        this.closeCustomFilter();
    //    },
    closeCustomFilter: function () {
        if (this._customFilterModalPopupBehavior) {
            this._customFilterModalPopupBehavior.dispose();
            this._customFilterModalPopupBehavior = null;
            this._customFilterField = null;
        }
        if (this._customFilterPanel) {
            this._customFilterPanel.parentNode.removeChild(this._customFilterPanel);
            delete this._customFilterPanel;
        }
        $removeHandler(document.body, 'keydown', this._bodyKeydownHandler);
        this._customFilterField = null;
        this._searchBarVisibleIndex = null;
    },
    convertFieldValueToString: function (field, value) {
        //        if (field.Type == 'String')
        //            return value != null && typeof (value) != String ? value.toString() : value;
        //        else {
        //            if (value != null && typeof (value) == 'string')
        //                value = this.convertStringToFieldValue2(field, value);
        //            return String.format('%js%{0}', Sys.Serialization.JavaScriptSerializer.serialize(value));
        //        }
        if (typeof (value) == 'string' && (value.match(Web.DataView._listRegex) || value.startsWith('%js%')))
            return value;
        if (field.Type != 'String' && value != null && typeof (value) == 'string')
            value = this.convertStringToFieldValue2(field, value);
        if (Date.isInstanceOfType(value))
            value = new Date(value - value.getTimezoneOffset() * 60 * 1000);
        return String.format('%js%{0}', Sys.Serialization.JavaScriptSerializer.serialize(value));
    },
    convertFieldValueToString2: function (field, value) {
        if (field.Type.startsWith('DateTime') && !String.isNullOrEmpty(field.DataFormatString)) {
            if (value == null)
                return null;
            else
                return String.localeFormat(field.DataFormatString, value);
        }
        else {
            if (field.Type == 'Boolean') {
                if (value == null)
                    return null;
                else
                    return value.toString();
            }
            else {
                //if (field.Type == 'Decimal' || field.Type == 'Single')
                //    return String.localeFormat('{0:N6}', value);
                //else
                return value.toString();
            }
        }
    },
    convertStringToFieldValue: function (field, value) {
        if (value != null && value.startsWith('%js%')) {
            value = Sys.Serialization.JavaScriptSerializer.deserialize(value.substring(4));
            if (Date.isInstanceOfType(value))
                value = new Date(value.getTime() + value.getTimezoneOffset() * 60 * 1000);
            return value;
        }
        else
            return this.convertStringToFieldValue2(field, value);
    },
    convertStringToFieldValue2: function (field, value) {
        if (value == null) return value;
        switch (field.Type) {
            case 'DateTime':
                var d = field.DataFormatString && field.DataFormatString.length ? Date.parseLocale(value, field.DataFormatString.match(/\{0:([\s\S]*?)\}/)[1]) : Date.parse(value)
                if (!isNaN(d) && d != null)
                    return d;
                break;
            case 'SByte':
            case 'Byte':
            case 'Int16':
            case 'Int32':
            case 'UInt32':
            case 'Int64':
            case 'Single':
            case 'Double':
            case 'Decimal':
            case 'Currency':
                var n = Number.parseLocale(value);
                if (!isNaN(n))
                    return n;
                break;
        }
        return value;
    },
    goToView: function (viewId) {
        if (!String.isNullOrEmpty(this._replaceTriggerViewId) && this._replaceTriggerViewId == viewId) {
            if (this._skipTriggeredView) this._skipTriggeredView = false;
            location.replace(location.href)
            return;
        }
        this._clearCache(true);
        var lastFilter = this.get_filter();
        var lastGroup = this.get_view().Group;
        if (viewId == 'form')
            for (var i = 0; i < this.get_views().length; i++)
                if (this.get_views()[i].Type == 'Form') {
                    viewId = this.get_views()[i].Id;
                    break;
                }
        this._detachBehaviors();
        if (!this.get_isForm() /*this.get_view().Type != 'Form'*/) {
            this._lastViewId = this.get_viewId();
            this._selectedRowIndex = 0;
        }
        var oldViewId = this.get_view().Id;
        var viewChanged = oldViewId != viewId;
        if (viewChanged) {
            this._focusedFieldName = null;
            if (!this.get_isGrid())
                this.writeContext('vitals', null);
        }
        this.set_viewId(viewId);
        var v = this.get_view();
        if (v.Type != 'Form') {
            this._lastViewId = viewId;
            this._restorePosition();
        }
        this.set_pageIndex(-1);
        var viewFilter = v.Type == 'Form' ? this.get_selectedKeyFilter() : (!String.isNullOrEmpty(lastGroup) && this.get_view().Group == lastGroup || !viewChanged ? lastFilter : []);
        if (this._requestedFilter) {
            viewFilter = this._requestedFilter;
            this._requestedFilter = null;
        }
        var viewSortExpression = viewChanged ? null : this.get_sortExpression();
        if (this._requestedSortExpression) {
            viewSortExpression = this._requestedSortExpression;
            this._requestedSortExpression = null;
        }
        this.set_filter(viewFilter);
        this.set_sortExpression(viewSortExpression);
        this._loadPage();
        this._raiseSelectedDelayed = true;
        if (viewChanged) {
            this._scrollIntoView = true;
            this._focusedCell = null;
        }
    },
    filterOf: function (field) {
        var header = (!String.isNullOrEmpty(field.AliasName) ? field.AliasName : field.Name) + ':';
        for (var i = 0; i < this._filter.length; i++) {
            var s = this._filter[i];
            if (s.startsWith(header) && !s.match(':~'))
                return this._filter[i].substr(header.length);
        }
        return null;
    },
    findField: function (query) {
        for (var i = 0; i < this._allFields.length; i++) {
            var field = this._allFields[i];
            if (field.Name == query) return field;
        }
        return null;
    },
    findCategory: function (query) {
        for (var i = 0; i < this._categories.length; i++) {
            var c = this._categories[i];
            if (c.Id == query) return c;
        }
        return null;
    },

    _isInInstantDetailsMode: function () {
        return location.href.match(Web.DataView.DetailsRegex);
    },
    _closeInstantDetails: function () {
        if (this._isInInstantDetailsMode()) {
            if (Web.DataViewResources.Lookup.ShowDetailsInPopup) {
                close();
                return true;
            }
        }
        return false;
    },
    _confirm: function (context, confirmCallback) {
        var iterator = /(_(\w+))\s*=\s*(.+?)(\s*\r|;|\n|$)/gi
        var confirmation = context.action.Confirmation;
        var result = true;
        var m = iterator.exec(confirmation);
        if (m && !(__tf != 4)) {
            var controller = null;
            var view = '';
            var commandName = 'New';
            var commandArgument = '';
            while (m) {
                var name = m[2];
                var value = m[3];
                if (name == 'controller')
                    controller = value;
                if (name == 'view')
                    view = value;
                if (name == 'commandName')
                    commandName = commandName;
                if (name == 'commandArgument')
                    commandArgument = value;
                if (name == 'width')
                    context.MaxWidth = value;
                if (name == 'title')
                    context.WindowTitle = value;
                m = iterator.exec(confirmation);
            }
            var dataView = this.get_isModal() ? null : Web.DataView.find(controller, 'Controller');
            if (dataView && !dataView.get_isModal()) {
                var values = dataView._collectFieldValues();
                result = dataView._validateFieldValues(values, true);
                if (result) {
                    this._convertValuesToParameters(values);
                    this._paramValues = values;
                }
            }
            else {
                values = this._collectFieldValues();
                var contextValues = context.Values = []
                for (var i = 0; i < values.length; i++) {
                    var fv = values[i];
                    Array.add(contextValues, { Name: 'Context_' + fv.Name, Value: fv.Modified ? fv.NewValue : fv.OldValue });
                }
                dataView = Web.DataView.showModal(this, controller, view, commandName, commandArgument, this.get_baseUrl(), this.get_servicePath(), [], { confirmContext: context, showSearchBar: this.get_showSearchBar() });
                result = false;
            }
        }
        else {
            confirmation = this._parseText(confirmation, this.get_currentRow());
            if (confirmCallback)
                confirmCallback(confirmation);
            else if (!confirm(confirmation))
                result = false;
        }
        return result;
    },
    executeAction: function (scope, actionIndex, rowIndex, groupIndex, confirmed) {
        if (this._isBusy) return;
        Web.DataView.hideMessage();
        var isLookup = this.get_lookupField() != null;
        var actions = isLookup && this._lookupActionProcessing() ? null : (scope == 'ActionBar' ? this.get_actionGroups(scope)[groupIndex].Actions : this.get_actions(scope));
        if (actionIndex < 0 && actions) {
            for (var i = 0; i < actions.length; i++)
                if (this._isActionAvailable(actions[i], rowIndex)) {
                    actionIndex = i;
                    break;
                }
            if (actionIndex < 0) return;
        }
        var action = actions ? actions[actionIndex] : null;
        if (action && !String.isNullOrEmpty(action.Confirmation)) {
            if (this.get_isGrid() && !this.get_isDataSheet() && this.get_lastCommandName() != 'BatchEdit' && !isLookup)
                this.executeRowCommand(rowIndex, 'Select');
            if (!confirmed && !this._confirm({ action: action, scope: scope, actionIndex: actionIndex, rowIndex: rowIndex, groupIndex: groupIndex }))
                return;
        }
        var command = action ? action.CommandName : 'Select';
        var argument = action ? action.CommandArgument : null;
        var causesValidation = action ? action.CausesValidation : true;
        var path = action ? action.Path : null;
        this.executeRowCommand(rowIndex, command, argument, causesValidation, path);
    },
    executeRowCommand: function (rowIndex, command, argument, causesValidation, path) {
        var extension = this.extension();
        if (rowIndex != null && rowIndex >= 0) {
            this._selectedRowIndex = rowIndex;
            this._raiseSelectedDelayed = !(command == 'Select' && String.isNullOrEmpty(argument));
            if (extension)
                this._selectedRow = this._rows[rowIndex];
            this._selectKeyByRowIndex(rowIndex);
        }
        var args = { commandName: command, commandArgument: argument ? argument : '', path: path, causesValidation: causesValidation ? true : false };
        if (!$appfactory.mobile && this.get_isDataSheet() && command.match(/Select|New|Edit|Duplicate/) && this._rows.length > 0) {
            if (extension != null && !Web.DataView.Extensions.active(extension))
                Web.DataView.Extensions.active(extension, true);
            else if (!this._get_focusedCell())
                this._startInputListenerOnCell(0, 0);
        }
        if (!this.executeCommand(args))
            return;
        if (command == 'ClientScript') {
            if (!this._raiseSelectedDelayed) {
                var self = this;
                setTimeout(function () {
                    self.refresh(true);
                }, 10);
            }
        }
        else if (command == 'Select' && argument == null && !this.get_isGrid()/*this.get_view().Type != 'Grid'*/)
            this._render();
    },
    rowCommand: function (row, command, argument, causesValidation, path) {
        //if (rowIndex != null && rowIndex >= 0) {
        //    this._selectedRowIndex = rowIndex;
        //    this._raiseSelectedDelayed = !(command == 'Select' && String.isNullOrEmpty(argument));
        //    this._selectKeyByRowIndex(rowIndex);
        //}
        this._raiseSelectedDelayed = !(command == 'Select' && String.isNullOrEmpty(argument));
        this._selectKeyByRow(row);
        var args = { commandName: command, commandArgument: argument ? argument : '', path: path, causesValidation: causesValidation ? true : false };
        if (this.get_isDataSheet() && command.match(/Select|New|Edit|Duplicate/)) {
            var extension = this.extension();
            if (extension != null && !Web.DataView.Extensions.active(extension))
                Web.DataView.Extensions.active(extension, true);
        }
        if (!this.executeCommand(args))
            return;
        if (command == 'ClientScript') {
            if (!this._raiseSelectedDelayed) {
                var self = this;
                setTimeout(function () {
                    self.refresh(true);
                }, 10);
            }
        }
        else if (command == 'Select' && argument == null && !this.get_isGrid())
            this._render();
    },
    _get_dataRequestForm: function () {
        var f = $get('_dataRequest_form');
        if (!f) {
            f = document.createElement('form');
            f.id = '_dataRequest_form';
            f.method = 'post';
            f.innerHTML = '<input type="hidden" name="q" id="q"/><input type="hidden" name="aa" id="aa"/><input type="hidden" name="c" id="c"/><input type="hidden" name="a" id="a"/>';
            document.body.appendChild(f);
        }
        return f;
    },
    _applySelectionFilter: function (q) {
        if (this.multiSelect() && this._selectedKeyList.length > 0 && this._keyFields.length == 1) {
            q.Filter = Array.clone(q.Filter);
            Array.add(q.Filter, String.format('{0}:$in${1}', this._keyFields[0].Name, this._selectedKeyList.join('$or$')));
        }
    },
    get_appRootPath: function () {
        var servicePath = this.get_servicePath();
        if (typeof (__cothost) != 'undefined') {
            if (__cothost == 'DotNetNuke' && servicePath.match(/DesktopModules\//i))
                return servicePath.replace(/Service\.asmx$/i, '');
            if (__cothost == 'SharePoint' && servicePath.match(/_layouts\//i))
                return servicePath.replace(/Service\.asmx$/i, '');
        }
        return '~/';
    },
    executeReport: function (args) {
        this._cancelConfirmation();
        var q = this._createParams(true);
        q.Controller = this.get_controller();
        q.View = this.get_viewId();
        var f = this._get_dataRequestForm();
        f.target = '';
        f.action = this.resolveClientUrl(this.get_appRootPath() + 'Report.ashx');
        $get('c', f).value = args.commandName;
        var commandArgument = args.commandArgument;
        if (!String.isNullOrEmpty(commandArgument)) {
            if (commandArgument.startsWith('_'))
                f.target = commandArgument;
            var a = commandArgument.split(Web.DataView._simpleListRegex);
            commandArgument = a[0];
            if (a.length == 3) {
                q.Controller = a[1];
                q.View = a[2];
            }
        }
        $get('a', f).value = commandArgument;
        if (q.Filter.length > 0 && this.get_viewType() != "Form") {
            var sb = new Sys.StringBuilder();
            this._renderFilterDetails(sb, q.Filter);
            var master = this.get_master();
            if (master) {
                var r = master.get_selectedRow();
                for (var i = 0; i < master._allFields.length; i++) {
                    var field = master._allFields[i];
                    if (field.ShowInSummary && !field.OnDemand) {
                        field = master._allFields[field.AliasIndex];
                        if (!sb.isEmpty())
                            sb.append(' ');
                        sb.appendFormat('{0} {1} {2}.', field.HeaderText, Web.DataViewResources.Data.Filters.Labels.Equals, field.format(r[field.Index]));
                    }
                }
            }
            q.FilterDetails = sb.toString();
        }
        if (this._viewMessages)
            q.FilterDetails = String.format('{0} {1}', this._viewMessages[this.get_viewId()], q.FilterDetails);
        if (q.FilterDetails)
            q.FilterDetails = q.FilterDetails.replace(/(<b class=\"String\">([\s\S]*?)<\/b>)/g, '"$2"').replace(/(&amp;)/g, '&').replace(/(<.+?>)|&nbsp;/g, '');
        this._applySelectionFilter(q);
        $get('q', f).value = Sys.Serialization.JavaScriptSerializer.serialize(q);
        var aa = this._createArguments(args);
        this._validateFieldValues(aa.Values, true);
        aa.ExternalFilter = q.ExternalFilter;
        $get('aa', f).value = Web.DataView.htmlEncode(Sys.Serialization.JavaScriptSerializer.serialize(aa));
        this._showDownloadProgress();
        f.submit();
    },
    _showDownloadProgress: function () {
        if ($appfactory.isSaaS()) return;
        this._busy(true);
        var that = this;
        var downloadToken = 'APPFACTORYDOWNLOADTOKEN';
        document.cookie = String.format('{0}={1}; path=/', downloadToken, encodeURIComponent(this.get_id()));
        var downloadInterval = setInterval(function () {
            if (!String.isNullOrEmpty(document.cookie)) {
                var cookies = document.cookie.split(';');
                for (var i = 0; i < cookies.length; i++) {
                    var cookie = cookies[i].trim();
                    if (cookie.startsWith(downloadToken)) {
                        var cookieValue = cookie.substring(downloadToken.length + 1).split(',');
                        if (cookieValue.length == 2 && cookieValue[0] == that.get_id()) {
                            document.cookie = String.format('{0}=; expires={1}; path=/', downloadToken, new Date(0).toUTCString());
                            that._busy(false);
                            clearInterval(downloadInterval);
                            var pendingExecuteComplete = that._pendingExecuteComplete;
                            if (that._pendingExecuteComplete) {
                                that._pendingExecuteComplete = null;
                                that._onExecuteComplete(pendingExecuteComplete.result, pendingExecuteComplete.context);
                            }
                        }
                    }
                }
            }
        }, 500);
    },
    executeExport: function (args) {
        var f = this._get_dataRequestForm();
        f.target = args.commandName == 'ExportRss' ? '_blank' : '';
        f.action = this.resolveClientUrl(this.get_appRootPath() + 'Export.ashx');
        var q = this._createParams(true);
        this._applySelectionFilter(q);
        args.Controller = this.get_controller();
        args.View = this.get_viewId();
        args.Filter = q.Filter;
        args.SortExpression = q.SortExpression;
        $get('c', f).value = args.commandName;
        $get('a', f).value = args.commandArgument;
        $get('q', f).value = Sys.Serialization.JavaScriptSerializer.serialize(args);
        f.submit();
    },
    _clearDynamicItems: function () {
        for (var i = 0; i < this._allFields.length; i++) {
            var f = this._allFields[i];
            if (f.DynamicItems) f.DynamicItems = null;
        }
    },
    _copyLookupValues: function (r, lf, nv, outputValues) {
        if (String.isNullOrEmpty(lf.Copy)) return;
        var values = outputValues ? outputValues : [];
        var iterator = /(\w+)\s*=\s*(\w+)/g;
        var m = iterator.exec(lf.Copy);
        while (m) {
            if (lf._dataView.findField(m[1])) {
                if (m[2] == 'null')
                    Array.add(values, { 'name': m[1], 'value': null });
                else
                    if (r) {
                        var f = this.findField(m[2]);
                        if (f) Array.add(values, { 'name': m[1], 'value': r[f.Index] });
                    }
                    else if (nv) {
                        for (var i = 0; i < nv.length; i++) {
                            if (nv[i].Name == m[2]) {
                                Array.add(values, { 'name': m[1], 'value': nv[i].NewValue });
                                break;
                            }
                        }
                    }
            }
            m = iterator.exec(lf.Copy);
        }
        if (outputValues) return;
        lf._dataView.refresh(true, values);
        lf._dataView._focus();
    },
    _copyExternalLookupValues: function () {
        if (this.get_filterSource() && this.get_filterSource() != 'Context') {
            var master = this.get_master();
            if (master) {
                var ditto = [];
                var filter = this.get_externalFilter();
                for (var i = 0; i < filter.length; i++) {
                    var f = this.findField(filter[i].Name);
                    if (f && !String.isNullOrEmpty(f.Copy)) {
                        master._copyLookupValues(master.get_currentRow(), f, null, ditto);
                    }
                }
                this._ditto = ditto;
            }
        }
    },
    _processSelectedLookupValues: function () {
        var values = [];
        var labels = [];
        var lf = this.get_lookupField();
        var dataValueField = this.findField(lf.ItemsDataValueField);
        var dataTextField = this.findField(lf.ItemsDataTextField);
        var r = this.get_selectedRow();
        if (!dataValueField) {
            for (var i = 0; i < this._allFields.length; i++) {
                if (this._allFields[i].IsPrimaryKey)
                    Array.add(values, r[this._allFields[i].Index]);
            }
        }
        else
            Array.add(values, r[dataValueField.Index]);
        if (!dataTextField) {
            for (i = 0; i < this.get_fields().length; i++) {
                f = this.get_fields()[i];
                if (!f.Hidden && f.Type == 'String') {
                    Array.add(labels, f.format(r[f.AliasIndex]));
                    break;
                }
            }
            if (labels.length == 0) {
                for (i = 0; i < values.length; i++) {
                    var f = this.get_fields()[i];
                    if (!f.Hidden) {
                        Array.add(labels, f.format(r[f.AliasIndex]));
                        break;
                    }
                }
            }
        }
        else
            Array.add(labels, dataTextField.format(r[dataTextField.Index]));
        this._copyLookupValues(r, lf);
        lf._dataView.changeLookupValue(lf.Index, values.length == 1 ? values[0] : values, labels.join(';'));
    },
    _showModal: function (args) {
        this.set_lastCommandName(null);
        this.set_lastCommandArgument(null);
        this._render();
        if (args.commandName == 'Duplicate')
            args.commandName = 'New';

        var dataView = Web.DataView.showModal(this, this.get_controller(), args.commandArgument, args.commandName, args.commandArgument, this.get_baseUrl(), this.get_servicePath(),
            this.get_hasParent() ? this._externalFilter : null,
            { 'filter': this.get_selectedKeyFilter(), 'ditto': this.get_ditto(), 'lastViewId': this.get_lastViewId(), 'transaction': this.get_transaction(), 'filterSource': this.get_filterSource(), 'filterFields': this.get_filterFields(), 'showSearchBar': this.get_showSearchBar(), 'tag': this.get_tag() });
        this.set_ditto(null);
        this._savePosition();
        if (!dataView.get_isInserting())
            dataView._position = this._position;
        this._restorePosition();
    },
    _savePosition: function () {
        if (!this.get_isForm()/*this.get_view().Type != 'Form'*/ && this._selectedRowIndex != null) {
            this._position = {
                index: this._pageSize * this._pageIndex + this._selectedRowIndex,
                count: this._totalRowCount,
                filter: this.get_filter(),
                sortExpression: this.get_sortExpression(),
                key: Array.clone(this._selectedKey),
                keyFilter: this._selectedKeyFilter,
                active: false
            };
        }
    },
    _restorePosition: function () {
        if (this._position) {
            this._selectedKey = this._position.key;
            this._selectedKeyFilter = this._position.keyFilter;
            this._position = null;
        }
    },
    _advance: function (delta) {
        if (this._isBusy || !this._position || (delta == -1 & this._position.index == 0 || delta == 1 && this._position.index == this._position.count - 1)) return;
        this._position.index += delta;
        this._position.changing = true;
        this._position.changed = true;
        this._loadPage();
        this._position.changing = false;
    },
    cancel: function () {
        if (this._closeInstantDetails()) { }
        else if (this.endModalState('Cancel')) return;
        else if (this.get_backOnCancel() || !String.isNullOrEmpty(this._replaceTriggerViewId)) {
            this.goBack(false);
            setTimeout(function () {
                location.replace(location.href)
            }, 500);
        }
        else {
            this.set_lastCommandName('Cancel');
            this._pendingSelectedEvent = true;
            if (this.get_isForm()/*this.get_view().Type == 'Form'*/ || this.get_isInserting()) {
                this._forceSync();
                this.goToView(this._lastViewId);
            }
            else if (this._totalRowCount < 0)
                this.goToPage(-1);
            else {
                this._clearDynamicItems();
                this._render();
                _body_performResize();
            }
        }
    },
    _convertValuesToParameters: function (values) {
        var i = 0;
        while (i < values.length) {
            var fv = values[i];
            fv.ReadOnly = true;
            if (fv.Name.match('PrimaryKey'))
                Array.removeAt(values, i);
            else {
                fv.Name = 'Parameters_' + fv.Name;
                i++;
            }
        }
    },
    _actionConfirmed: function (args) {
        var actionArgs = this._createArguments(args);
        var valid = this._validateFieldValues(actionArgs.Values, args.causesValidation == null || args.causesValidation);
        if (valid) {
            var context = this.get_confirmContext();
            var dataView = this.get_parentDataView();
            if (context && dataView) {
                var values = dataView._paramValues = actionArgs.Values;
                //                var i = 0;
                //                while (i < values.length) {
                //                    var fv = values[i];
                //                    fv.ReadOnly = true;
                //                    if (fv.Name.match('PrimaryKey'))
                //                        Array.removeAt(values, i);
                //                    else {
                //                        fv.Name = 'Parameters_' + fv.Name;
                //                        i++;
                //                    }
                //                }
                this._convertValuesToParameters(values);
                dataView._confirmDataViewId = this.get_id();
                dataView._lookupActionProcessing(false)
                dataView.executeAction(context.scope, context.actionIndex, context.rowIndex, context.groupIndex, true);
                dataView._lookupActionProcessing(true)
            }
        }
    },
    executeCommand: function (args) {
        if (this._isBusy) return;
        var rules = new Web.BusinessRules(this),
            mobile = $appfactory.mobile;
        rules.before(args);
        if (rules.canceled()) {
            rules.dispose();
            this._valid = args.commandName == 'Calculate';
            return this._valid;
        }
        switch (args.commandName) {
            case 'Select':
            case '':
                this.set_lastCommandName(args.commandName);
                this.set_lastCommandArgument(args.commandArgument);
                if (this.get_lookupField() && args.commandArgument == '') this._processSelectedLookupValues();
                else {
                    if (!String.isBlank(args.commandArgument)) {
                        this._savePosition();
                        if (this.get_showModalForms() && this.get_isForm(args.commandArgument) /*this.get_viewType(args.commandArgument) == 'Form'*/)
                            this._showModal(args);
                        else
                            this.goToView(args.commandArgument);
                    }
                    else
                        this._render();
                    if (__designer())
                        __designer_notifySelected(this);
                }
                break;
            case 'Edit':
            case 'BatchEdit':
            case 'New':
            case 'Duplicate':
                if (!mobile) {
                    this._allowModalAutoSize();
                    this._fixHeightOfRow(false);
                    if (args.commandName == 'Edit') this._savePosition(); else this._restorePosition();
                }
                if (args.commandName == 'Duplicate') {
                    var r = this.get_selectedRow();
                    if (r) {
                        var dv = []
                        for (i = 0; i < this._allFields.length; i++) {
                            var f = this._allFields[i];
                            Array.add(dv, { 'name': f.Name, 'value': r[f.Index] });
                        }
                        this._ditto = dv;
                    }
                }
                var fc = this._get_focusedCell(),
                    extension = this.extension();
                if (args.commandName == 'New' || args.commandName == 'Duplicate') {
                    if (String.isNullOrEmpty(args.commandArgument))
                        args.commandArgument = this.get_viewId();
                    if (extension && extension.clearSelection)
                        extension.clearSelection(true);
                    else
                        this._forgetSelectedRow(false, fc);
                    if (args.commandName == 'New') this._copyExternalLookupValues();
                }
                this.set_lastCommandName(args.commandName);
                this.set_lastCommandArgument(args.commandArgument);
                this._clearDynamicItems();
                if (!String.isBlank(args.commandArgument))
                    if (this.get_showModalForms() && this.get_isForm(args.commandArgument) /*this.get_viewType(args.commandArgument) == 'Form'*/ && !this.get_isModal())
                        this._showModal(args);
                    else
                        this.goToView(args.commandArgument);
                else {
                    if (extension && extension.stateChanged) {
                        extension.stateChanged();
                    }
                    else {
                        if (this.get_isModal())
                            this._container.style.height = '';
                        if (this.get_isDataSheet() && !this._pendingChars)
                            this._startInputListenerOnCell(this._selectedRowIndex, fc == null ? 0 : fc.colIndex);
                        this._render();
                    }
                }
                if (__designer())
                    __designer_notifySelected(this);
                break;
            case 'Navigate':
                this.navigate(args.commandArgument);
                break;
            case 'Cancel':
                this.cancel();
                break;
            case 'Confirm':
                this._actionConfirmed(args);
                break;
            case 'Back':
                history.go(!String.isNullOrEmpty(args.commandArgument) ? parseInt(args.commandArgument) : -1);
                break;
            case 'Report':
            case 'ReportAsPdf':
            case 'ReportAsImage':
            case 'ReportAsExcel':
            case 'ReportAsWord':
                this.executeReport(args);
                break;
            case 'ExportCsv':
            case 'ExportRowset':
            case 'ExportRss':
                this.executeExport(args);
                break;
            case '_ViewDetails':
                this._viewDetails(args.commandArgument);
                break;
            case 'ClientScript':
                Web.HoverMonitor._instance.close();
                eval(args.commandArgument);
                break;
            case 'SelectModal':
            case 'EditModal':
                this.set_lastCommandName(null);
                this.set_lastCommandArgument(null);
                this._render();
                var modalCmd = args.commandName.match(/^(\w+)Modal$/);
                //this.set_lastCommandName(modalCmd[1]);
                //this.set_lastCommandArgument(args.commandArgument);
                var modalArg = args.commandArgument.split(',');
                var modalController = modalArg.length == 1 ? this.get_controller() : modalArg[0];
                var modalView = modalArg.length == 1 ? args.commandArgument : modalArg[1];
                var filter = [];
                for (i = 0; i < this.get_selectedKey().length; i++)
                    Array.add(filter, { Name: this._keyFields[i].Name, Value: this.get_selectedKey()[i] });
                var dataView = Web.DataView.showModal(this, modalController, modalView, modalCmd[1], modalView, this.get_baseUrl(), this.get_servicePath(), filter);
                dataView._parentDataViewId = this.get_id();
                break;
            case 'Import':
                this._showImport(args.commandArgument);
                break;
            case 'DataSheet':
                this.writeContext('GridType', 'DataSheet');
                this._forceFocusDataSheet = true;
                this.changeViewType('DataSheet');
                this.refreshAndResize();
                break;
            case 'Grid':
                this.writeContext('GridType', 'Grid');
                this.changeViewType('Grid');
                this.refreshAndResize();
                break;
            /*            case 'Open':
            this.drillIn();
            break;*/ 
            case 'Status':
                this._changeStatus(args);
                break;
            case 'Search':
                this._executeSearch(args.path);
                break;
            case 'None':
                return true;
            default:
                /*var view = this.get_viewId();
                var m = args.commandArgument.match(/^view:(.+)$/);
                if (args.commandName == 'Insert' && m) {
                view = m[1];
                Array.clear(this._selectedKey);
                this.updateSummary();
                this.set_lastCommandName('New');
                this.set_lastCommandArgument(view);
                }
                var values = this._collectFieldValues();
                if (args.values)
                values = Array.clone(args.values);
                */
                var view = null;
                var m = args.commandArgument.match(/^view:(.+)$/);
                if (args.commandName == 'Insert' && m) {
                    view = m[1];
                    Array.clear(this._selectedKey);
                    this.updateSummary();
                    this.set_lastCommandName('New');
                    this.set_lastCommandArgument(view);
                }
                var actionArgs = this._createArguments(args, view);
                /*
                this._valid = this._validateFieldValues(values, args.causesValidation == null || args.causesValidation)
                if (this._valid)
                this._execute({ CommandName: args.commandName, CommandArgument: args.commandArgument, LastCommandName: this.get_lastCommandName(), Values: values, ContextKey: this.get_id(), Cookie: this.get_cookie(), Controller: this.get_controller(), View: view });
                */
                this._valid = this._validateFieldValues(actionArgs.Values, args.causesValidation == null || args.causesValidation)
                if (this._valid)
                    this._execute(actionArgs);
                break;
        }
        rules.after(args);
        rules.dispose();
        return !rules.canceled();
    },
    _forgetSelectedRow: function (notify, focusedCell) {
        if (!focusedCell)
            focusedCell = this._get_focusedCell();
        if (this.get_isDataSheet()) {
            if (focusedCell)
                focusedCell.colIndex = 0;
        }
        this._lastSelectedRowIndex = !this._ignoreSelectedKey && this._selectedKey.length > 0 && this._rowIsSelected(this._selectedRowIndex) ? this._selectedRowIndex : -1;
        this._ignoreSelectedKey = false;
        Array.clear(this._selectedKey);
        this.updateSummary();
        if (notify)
            this.raiseSelected();
    },
    _changeStatus: function (args) {
        if (args.causesValidation) {
            var values = this._collectFieldValues();
            if (args.values)
                values = Array.clone(args.values);
            if (!this._validateFieldValues(values, true))
                return;
        }
        var statusField = this.findField('Status');
        if (!statusField) return;
        if (this.get_isEditing()) {
            var statusElem = this._get('_Item', statusField.Index);
            if (!statusElem) {
                statusElem = document.createElement('input');
                statusElem.type = 'hidden';
                statusElem.id = String.format('{0}_Item{1}', this._id, statusField.Index);
                this._container.appendChild(statusElem);
            }
            statusElem.value = args.commandArgument;
        }
        else {
            var row = this.get_selectedRow();
            row[statusField.Index] = args.commandArgument;
        }
        this._updateVisibility();
    },
    _notifyDesigner: function (changed) {
        if (__designer() && changed) {
            var lastArgs = this._lastArgs;
            external.ExplorerNodeChanged(this.get_controller(), this.get_viewId(), lastArgs.CommandName, lastArgs.CommandArgument, Sys.Serialization.JavaScriptSerializer.serialize(lastArgs.Values));
        }
    },
    goBack: function (changed) {
        Web.DataView._navigated = true;
        this._notifyDesigner(changed);
        var l = location;
        if (l.href.match(/_explorerNode=/))
            l.replace(l.href);
        else
            history.go(-1);
    },
    /*get_path: function () {
    var path = this.readContext('TreePath');
    if (!path) {
    path = [];
    Array.add(path, { 'text': Web.DataViewResources.Grid.RootNodeText, 'key': [], 'filter': [], 'quickFind': '' });
    this.writeContext('TreePath', path);
    }
    return path;
    },*/
    /*drillIn: function (index) {
    if (!this.get_isTree()) return;
    for (var i = 0; i < this._allFields.length; i++) {
    var recursiveField = this._allFields[i];
    if (recursiveField.ItemsDataController == this.get_controller()) {
    var path = this.get_path();
    if (!path)
    path = [];
    if (index != null) {
    var levelInfo = path[index];
    while (path.length - 1 > index)
    Array.removeAt(path, path.length - 1);
    this.set_selectedKeyFilter([]);
    this.set_quickFindText(levelInfo.quickFind);
    this.set_filter(levelInfo.filter);
    if (path.length == 0) {
    this.set_selectedKey([]);
    this.removeFromFilter(recursiveField);
    this.refreshData();
    }
    else {
    var key = levelInfo.key;
    this.applyFieldFilter(i, '=', key);
    this.set_selectedKey(key);
    this._syncKeyFilter();
    }
    this.raiseSelected();
    }
    else {
    var field = this._fields[0];
    var text = field.format(this.get_selectedRow()[field.Index]);
    levelInfo = path[path.length - 1];
    levelInfo.filter = this.get_filter();
    levelInfo.quickFind = this.get_quickFindText();
    Array.add(path, { 'text': text, 'key': this.get_selectedKey(), 'filter': [], 'quickFind': '' });
    this.set_filter([]);
    this.set_quickFindText(null);
    this.applyFieldFilter(i, '=', this.get_selectedKey());
    }
    this.writeContext('TreePath', path);
    break;
    }
    }
    },*/
    _viewDetails: function (fieldName) {
        var f = this.findField(fieldName);
        if (f) {
            var keyFieldName = f.Name;
            if (f.ItemsDataController == this.get_controller())
                for (var i = 0; i < this._allFields.length; i++) {
                    if (this._allFields[i].IsPrimaryKey) {
                        keyFieldName = this._allFields[i].Name;
                        break;
                    }
                }
            var contextFilter = this.get_contextFilter(f);
            if (__designer()) {
                var link = String.format('{0}&{1}={2}', f.ItemsDataController, !String.isNullOrEmpty(f.ItemsDataValueField) ? f.ItemsDataValueField : keyFieldName, this.get_selectedRow()[f.Index]);
                for (i = 0; i < contextFilter.length; i++) {
                    var filter = contextFilter[i];
                    link = String.format('{0}&{1}={2}', link, filter.Name, filter.Value);
                }
                link = this.resolveClientUrl(String.format('~/Details.{0}?l={1}', __designer() ? 'htm' : 'aspx', encodeURIComponent(link)));
                location.href = link;
                Web.DataView._navigated = false;
            }
            else {
                filter = [{ 'Name': !String.isNullOrEmpty(f.ItemsDataValueField) ? f.ItemsDataValueField : keyFieldName, 'Value': this.fieldValue(f.Name)}];
                Array.addRange(filter, contextFilter);
                var dataView = $appfactory.showModal(this, f.ItemsDataController, "editForm1", "Select", "editForm1", this.get_baseUrl(), this.get_servicePath(), filter, { useCase: 'ObjectRef' });
                dataView.set_showSearchBar(this.get_showSearchBar());
                dataView._parentDataViewId = this.get_id();
                dataView._closeViewDetails = true;
            }

            //            for (i = 0; i < contextFilter.length; i++) {
            //                var filter = contextFilter[i];
            //                link = String.format('{0}&{1}={2}', link, filter.Name, filter.Value);

            //            }

            //            var link = String.format('{0}&{1}={2}', f.ItemsDataController, !String.isNullOrEmpty(f.ItemsDataValueField) ? f.ItemsDataValueField : keyFieldName, this.get_selectedRow()[f.Index]);
            //            var contextFilter = this.get_contextFilter(f);
            //            for (i = 0; i < contextFilter.length; i++) {
            //                var filter = contextFilter[i];
            //                link = String.format('{0}&{1}={2}', link, filter.Name, filter.Value);

            //            }



            //            link = this.resolveClientUrl(String.format('~/Details.{0}?l={1}', __designer() ? 'htm' : 'aspx', encodeURIComponent(link)));
            //            if (Web.DataViewResources.Lookup.ShowDetailsInPopup)
            //            //window.open(link, '_blank', 'scrollbars=yes,height=100,resizable=yes');
            //                this._navigate('_blank:' + link, 'scrollbars=yes,height=100,resizable=yes');
            //            else
            //                window.location.href = link;
            //            Web.DataView._navigated = false;
        }
    },
    changeViewType: function (type) {
        this.cancelDataSheet();
        if (!this._viewTypes)
            this._viewTypes = [];
        this._viewTypes[this.get_viewId()] = type;
        this._clearCache();
    },
    _parseLocation: function (url, row, values) {
        if (!row) row = this.get_selectedRow();
        if (!url) return null;
        url = this.resolveClientUrl(url);
        var iterator = /([\s\S]*?)\{(\w+)?\}/g;
        var formattedurl = '';
        var lastIndex = -1;
        var match = iterator.exec(url);
        while (match) {
            formattedurl += match[1];
            if (values && this._lastArgs) {
                for (var i = 0; i < values.length; i++) {
                    var v = values[i];
                    if (v.Name == match[2]) {
                        formattedurl += this._lastArgs.CommandName.match(/Insert/i) ? v.NewValue : v.OldValue;
                        break;
                    }
                }
            }
            else {
                var field = match[2].match(/^\d+$/) ? this.get_fields()[parseInt(match[2])] : this.findField(match[2]);
                if (field) {
                    var fv = row[field.Index];
                    if (fv != null)
                        formattedurl += match.index == 0 ? fv : encodeURIComponent(fv);
                }
            }
            lastIndex = iterator.lastIndex;
            match = iterator.exec(url);
        }
        if (lastIndex != -1) url = formattedurl + (lastIndex < url.length ? url.substr(lastIndex) : '');
        if (url.startsWith('?'))
            url = location.pathname + url;
        return url;
    },
    _parseText: function (text, row) {
        if (!row) row = this.get_selectedRow();
        if (!text) return null;
        var iterator = /([\s\S]*?)\{(\w+)?\}/g;
        var formattedText = '';
        var lastIndex = -1;
        var match = iterator.exec(text);
        while (match) {
            formattedText += match[1];
            var field = match[2].match(/^\d+$/) ? this.get_fields()[parseInt(match[2])] : this.findField(match[2]);
            if (field) {
                var fv = row[field.Index];
                if (fv != null) {
                    fv = field.format(fv);
                    //fv = fv.replace(/\'/g, '\\\'');
                    formattedText += fv;
                }
            }
            lastIndex = iterator.lastIndex;
            match = iterator.exec(text);
        }
        if (lastIndex != -1) text = formattedText + (lastIndex < text.length ? text.substr(lastIndex) : '');
        return text;
    },
    _showImport: function (view) {
        if (!view) view = this.get_viewId();
        this._importView = view;
        this._importElement = document.createElement('div');
        this._importElement.id = this.get_id() + '$Import';
        this._importElement.className = 'Import';
        var sb = new Sys.StringBuilder();
        var s = String.format('<a href="javascript:" onclick="$find(\'{0}\')._downloadImportTemplate(\'{1}\');return false;">{2}</a>', this.get_id(), view, Web.DataViewResources.Data.Import.DownloadTemplate);
        sb.appendFormat('<div id="{0}$ImportStatus" class="Status"><span>{1}</span> {2}</div>', this.get_id(), Web.DataViewResources.Data.Import.UploadInstruction, s);
        sb.appendFormat('<div id="{0}$ImportMap" class="Map" style="display:none"></div>', this.get_id());
        sb.appendFormat('<iframe src="{1}?parentId={0}&controller={2}&view={3}" frameborder="0" scrolling="no" id="{0}$ImportFrame" class="Import"></iframe>', this.get_id(), this.resolveClientUrl(this.get_appRootPath() + 'Import.ashx'), this.get_controller(), view);
        sb.appendFormat('<div class="Email">{1}:<br/><input type="text" id="{0}$ImportEmail"/></div>', this.get_id(), Web.DataViewResources.Data.Import.Email);
        sb.appendFormat('<div class="Buttons"><button id="{0}$StartImport" onclick="$find(\'{0}\')._startImportProcessing();return false" style="display:none">{1}</button><button id="{0}$CancelImport" onclick="$find(\'{0}\')._closeImport();return false">{2}</button></div>', this.get_id(), Web.DataViewResources.Data.Import.StartButton, Web.DataViewResources.ModalPopup.CancelButton);
        this._importElement.innerHTML = sb.toLocaleString();
        //document.body.appendChild(this._importElement);
        this._appendModalPanel(this._importElement);
        this._importPopup = $create(AjaxControlToolkit.ModalPopupBehavior, { 'id': this.get_id() + '$ImportPopup', PopupControlID: this._importElement.id, DropShadow: true, BackgroundCssClass: 'ModalBackground' }, null, null, this._container.getElementsByTagName('a')[0]);
        this._saveTabIndexes();
        this._importPopup.show();
    },
    _closeImport: function () {
        this._disposeImport();
        this._restoreTabIndexes();
    },
    _disposeImport: function () {
        if (this._importElement) {
            this._importPopup.hide();
            this._importPopup.dispose();
            this._importPopup = null;
            this._importElement.parentNode.removeChild(this._importElement);
            delete this._importElement;
        }
    },
    _downloadImportTemplate: function (view) {
        this.executeExport({ commandName: 'ExportTemplate', commandArgument: String.format('{0},{1}', this.get_controller(), view) });
    },
    _initImportUpload: function (frameDocument) {
        var div = frameDocument.createElement('div');
        div.innerHTML = String.format('<form method="post" enctype="multipart/form-data"><input type="file" id="ImportFile" name="ImportFile" style="font-size:8.5pt;font-family:tahoma;padding:2px 0px 4px 0px;" onchange="parent.window.$find(\'{0}\')._startImportUpload(this.value);this.parentNode.submit()"/></form>', this.get_id());
        frameDocument.body.appendChild(div);
        //frameDocument.getElementById('ImportFile').focus();
        Sys.UI.DomElement.setFocus(frameDocument.getElementById('ImportFile'));
    },
    _get_importStatus: function () {
        return $get(this.get_id() + '$ImportStatus');
    },
    _get_importFrame: function () {
        return $get(this.get_id() + '$ImportFrame');
    },
    _startImportUpload: function (fileName) {
        var parts = fileName.split(/\\/);
        this._importFileName = parts[parts.length - 1];
        Sys.UI.DomElement.setVisible(this._get_importFrame(), false);
        $(this._get_importStatus()).addClass('Wait');
        this._get_importStatus().innerHTML = Web.DataViewResources.Data.Import.Uploading;
    },
    _finishImportUpload: function (frameDocument) {
        Sys.UI.DomElement.removeCssClass(this._get_importStatus(), 'Wait');
        Sys.UI.DomElement.addCssClass(this._get_importStatus(), 'Ready');
        var errors = frameDocument.getElementById('Errors');
        if (errors)
            this._get_importStatus().innerHTML = errors.value;
        else {
            var fileName = frameDocument.getElementById('FileName');
            var numberOfRecords = frameDocument.getElementById('NumberOfRecords');
            var availableImportFields = frameDocument.getElementById('AvailableImportFields').value.trim().split(/\r?\n/);
            var fieldMap = frameDocument.getElementById('FieldMap').value.trim().split(/\r?\n/);
            this._get_importStatus().innerHTML = String.format(Web.DataViewResources.Data.Import.MappingInstruction, numberOfRecords.value, this._importFileName);
            this._importFileName = frameDocument.getElementById('FileName').value;
            var importButton = $get(this.get_id() + '$StartImport');
            Sys.UI.DomElement.setVisible(importButton, true);
            //importButton.focus();
            Sys.UI.DomElement.setFocus(importButton);
            var sb = new Sys.StringBuilder();
            sb.append('<table>');
            for (var i = 0; i < fieldMap.length; i++) {
                var mapping = fieldMap[i].match(/^(.+?)=(.+?)?$/);
                sb.appendFormat('<tr><td>{2}</td><td><select id="{0}$ImportField{1}"><option value="">{3}</option>', this.get_id(), i, Web.DataView.htmlEncode(mapping[1]), Web.DataViewResources.Data.Import.AutoDetect);
                for (var j = 0; j < availableImportFields.length; j++) {
                    var option = availableImportFields[j].split('=');
                    if (option[0] == mapping[2]) {
                        sb.appendFormat('<option value="{0}"', option[0]);
                        sb.append(' selected="selected"');
                        sb.appendFormat('>{0}</option>', Web.DataView.htmlEncode(option[1]));
                    }
                }
                sb.append('</select></td></tr>');
            }
            sb.append('</table>');
            var importMapElem = $get(this.get_id() + '$ImportMap');
            Sys.UI.DomElement.setVisible(importMapElem, true);
            importMapElem.innerHTML = sb.toString();
            var $importMap = $(importMapElem).find('select').change(function () {
                refreshOptions();
            });
            var refreshOptions = function () {
                var unmappedFields = Array.clone(fieldMap);
                var mappedFields = [];
                var maxWidth = 0;
                $importMap.each(function () {
                    $(this).css('width', 'auto');
                    if (this.value != '')
                        Array.add(mappedFields, this.value);
                }).each(function () {
                    var that = this;
                    $(that).find('option').filter(function () {
                        return that.value != this.value && this.value != '';
                    }).remove();
                    for (var j = 0; j < availableImportFields.length; j++) {
                        var option = availableImportFields[j].split('=');
                        if (!Array.contains(mappedFields, option[0])) {
                            $(this).append($('<option>', { value: option[0] }).text(option[1]));
                        }
                    }
                }).each(function () {
                    var w = $(this).outerWidth();
                    if (w > maxWidth)
                        maxWidth = w;
                }).css('width', maxWidth);
            };
            refreshOptions();
        }
        this._importPopup.show();
        this._get_importFrame().parentNode.removeChild(this._get_importFrame());
    },
    _startImportProcessing: function () {
        var emailElem = $get(this.get_id() + '$ImportEmail');
        var email = emailElem.value.replace(/;/g, ',');
        if (String.isBlank(email) && !confirm(Web.DataViewResources.Data.Import.EmailNotSpecified)) {
            //emailElem.focus();
            Sys.UI.DomElement.setFocus(emailElem);
            return;
        }
        var sb = new Sys.StringBuilder();
        sb.appendFormat('{0};{1};{2};{3};', this._importFileName, this.get_controller(), this._importView, email);
        var i = 0;
        while (true) {
            var mapping = $get(this.get_id() + '$ImportField' + i);
            if (!mapping) break;
            sb.append(mapping.value);
            sb.append(';');
            i++;
        }
        this.executeCommand({ commandName: 'ProcessImportFile', commandArgument: sb.toString() });
        this._closeImport();
        alert(Web.DataViewResources.Data.Import.Processing);
        this.refresh();
    },
    navigate: function (location, values) {
        debugger
        this.set_selectedValue(this.get_selectedKey());
        Web.HoverMonitor._instance.close();
        location = this._parseLocation(location, null, values);
        var targetView = null;
        for (i = 0; i < this.get_views().length; i++)
            if (this.get_views()[i].Id == location) {
                targetView = this.get_views()[i];
                break;
            }
        if (targetView)
            this.goToView(location);
        else
            this._navigate(location);
    },
    _navigate: function (location, features) {
        Web.DataView._navigated = true;
        var m = location.match(Web.DataView.LocationRegex);
        if (typeof __dauh != 'undefined')
            if (m)
                this.encodePermalink(m[2], m[1], features)
            else
                this.encodePermalink(location);
        else
            if (m) {
                Web.DataView._navigated = false;
                open(m[2], m[1], features ? features : '');
            }
            else
                window.location.href = location;
    },
    get_contextFilter: function (field, values) {
        var contextFilter = [];
        if (!String.isNullOrEmpty(field.ContextFields)) {
            var contextValues = values ? values : this._collectFieldValues(true);
            var iterator = /(\w+)(\s*=\s*(.+?)){0,1}\s*(,|$)/g;
            var m = iterator.exec(field.ContextFields);
            while (m) {
                var n = !String.isNullOrEmpty(m[3]) ? m[3] : m[1];
                var m2 = n.match(/^\'(.+)\'$/);
                if (!m2)
                    m2 = n.match(/^(\d+)$/);
                if (m2) {
                    for (var i = 0; i < contextFilter.length; i++) {
                        if (contextFilter[i].Name == m[1]) {
                            contextFilter[i].Value += '\0=' + m2[1];
                            m2 = null;
                            break;
                        }
                    }
                    if (m2) Array.add(contextFilter, { 'Name': m[1], 'Value': m2[1] });
                }
                else {
                    var f = this.findField(n);
                    if (f) {
                        for (i = 0; i < contextValues.length; i++) {
                            if (contextValues[i].Name == f.Name) {
                                var v = contextValues[i];
                                var fieldValue = v.Modified ? v.NewValue : v.OldValue;
                                Array.add(contextFilter, { 'Name': m[1], 'Value': fieldValue });
                                break;
                            }
                        }
                    }
                }
                m = iterator.exec(field.ContextFields);
            }
        }
        return contextFilter;
    },
    showLookup: function (fieldIndex) {
        if (!this.get_enabled()) return;
        var field = this._allFields[fieldIndex];
        if (!field._lookupModalBehavior) {
            var showLink = $get(this.get_id() + '_Item' + field.Index + '_ShowLookupLink');
            if (showLink) {
                var panel = field._lookupModalPanel = document.createElement('div');
                //document.body.appendChild(panel);
                this._appendModalPanel(panel);
                panel.className = 'ModalPanel';
                panel.id = this.get_id() + '_ItemLookupPanel' + field.Index;
                panel.innerHTML = String.format('<table style="width:100%;height:100%"><tr><td valign="middle" align="center"><table cellpadding="0" cellspacing="0"><tr><td class="ModalTop"><div style="height:1px;font-size:1px"></div></td><td><div style="height:1px;font-size:1px"></div></td></tr><tr><td align="left" valign="top" id="{0}_ItemLookupPlaceholder{1}"  class="ModalPlaceholder"></td><td class="RightSideShadow"></td></tr><tr><td colspan="2"><div class="BottomShadow"></div></td></tr></table></td></tr></table>', this.get_id(), field.Index);
                field._lookupModalBehavior = $create(AjaxControlToolkit.ModalPopupBehavior, { id: this.get_id() + "_ItemLookup" + field.Index, PopupControlID: panel.id, BackgroundCssClass: 'ModalBackground' }, null, null, showLink);
            }
        }
        else
            field._lookupDataControllerBehavior._render();
        var contextFilter = this.get_contextFilter(field);
        var focusQF = true;
        if (!field._lookupDataControllerBehavior) {
            focusQF = false;
            field._lookupDataControllerBehavior = $create(Web.DataView, {
                id: this.get_id() + '_LookupView' + fieldIndex, baseUrl: this.get_baseUrl(), pageSize: field.ItemsPageSize ? field.ItemsPageSize : Web.DataViewResources.Pager.PageSizes[0], showFirstLetters: field.ItemsLetters, servicePath: this.get_servicePath(),
                controller: field.ItemsDataController, viewId: field.ItemsDataView, showActionBar: Web.DataViewResources.Lookup.ShowActionBar, lookupField: field, externalFilter: contextFilter, filterSource: contextFilter.length > 0 ? 'Context' : null, 'showSearchBar': this.get_showSearchBar(), 'searchOnStart': this.get_showSearchBar() && field.SearchOnStart, 'description': field.ItemsDescription
            }, null, null, $get(this.get_id() + '_ItemLookupPlaceholder' + field.Index));
        }
        else if (contextFilter.length > 0) {
            field._lookupDataControllerBehavior.set_externalFilter(contextFilter);
            field._lookupDataControllerBehavior.goToPage(-1);
            focusQF = true;
        }
        this._saveTabIndexes();
        field._lookupModalBehavior.show();
        if (focusQF) field._lookupDataControllerBehavior._focusQuickFind(true);
        $addHandler(document.body, 'keydown', field._lookupDataControllerBehavior._bodyKeydownHandler);
        field._lookupDataControllerBehavior._adjustLookupSize();
        this._lookupIsActive = true;
    },
    changeLookupValue: function (fieldIndex, value, text) {
        var field = this._allFields[fieldIndex],
            that = this;
        setTimeout(function () {
            that._restoreTabIndexes();
            var itemId = that.get_id() + '_Item' + fieldIndex;
            var itemTextId = that.get_id() + '_Item' + field.AliasIndex;
            Sys.UI.DomElement.setVisible($get(itemId + '_ClearLookupLink'), true);
            var elem = $get(itemId + '_ShowLookupLink');
            elem.innerHTML = that.htmlEncode(field, text);
            Sys.UI.DomElement.setFocus(elem);
            //$get(itemId + '_ShowLookupLink').focus();
            if (value)
                value = field.format(value);
            $get(itemId).value = value;
            if (itemId != itemTextId) $get(itemTextId).value = text;
            $(elem).closest('table').css('width', '');
            //while (elem.tagName != 'TABLE') elem = elem.parentNode;
            //elem.style.width = '';
            that._updateLookupInfo(value, text);
            that._valueChanged(fieldIndex);
            that._adjustModalHeight();
        }, 0);
        that._closeLookup(field);
    },
    clearLookupValue: function (fieldIndex) {
        var field = this._allFields[fieldIndex];
        var itemId = this.get_id() + '_Item' + fieldIndex;
        var itemTextId = this.get_id() + '_Item' + field.AliasIndex;
        Sys.UI.DomElement.setVisible($get(itemId + '_ClearLookupLink'), false);
        $get(itemId + '_ShowLookupLink').innerHTML = Web.DataViewResources.Lookup.SelectLink;
        $get(itemId).value = '';
        $get(itemTextId).value = '';
        if (!String.isNullOrEmpty(field.Copy)) {
            var values = [];
            var iterator = /(\w+)=(\w+)/g;
            var m = iterator.exec(field.Copy);
            while (m) {
                if (m[2] == 'null')
                    Array.add(values, { 'name': m[1], 'value': null });
                m = iterator.exec(field.Copy);
            }
            if (values.length > 0)
                this.refresh(true, values);
        }

        this._updateLookupInfo('', Web.DataViewResources.Lookup.SelectLink);
        $get(itemId + '_ShowLookupLink').focus();
        this._valueChanged(fieldIndex);
        this._adjustModalHeight();
    },
    _updateLookupInfo: function (value, text) {
        var lookupText = $get(this.get_id() + '_Text0');
        if (lookupText) {
            lookupText.value = text;
            lookupText.name = lookupText.id;
            var lookupValue = $get(this.get_id() + '_Item0');
            lookupValue.value = value;
            lookupValue.name = lookupValue.id;
            if (this.get_lookupPostBackExpression()) {
                var prm = Sys.WebForms.PageRequestManager.getInstance();
                if (prm)
                    eval("Sys.WebForms.PageRequestManager.getInstance()._doPostBack" + this.get_lookupPostBackExpression().match(/\w+(.+)/)[1]);
                else
                    eval(this.get_lookupPostBackExpression());
            }
        }
    },
    createNewLookupValue: function (fieldIndex) {
        var field = this._newLookupValueField = this._allFields[fieldIndex];
        var cnv = this._createNewView = Web.DataView.showModal(/*$get(String.format('{0}_Item{1}_CreateNewLookupLink', this.get_id(), field.Index))*/this, field.ItemsDataController, field.ItemsNewDataView, 'New', field.ItemsNewDataView, this.get_baseUrl(), this.get_servicePath(), this.get_contextFilter(field));
        cnv._parentDataViewId = this.get_id();
        cnv.add_executed(Function.createDelegate(this, this._saveNewLookupValueCompleted));
        cnv.set_showSearchBar(this.get_showSearchBar());
        this._lookupIsActive = true;
    },
    _saveNewLookupValueCompleted: function (sender, args) {
        if (args.result.Errors.length > 0) return;
        args.handled = true;
        Web.DataView.hideMessage();
        var v = null;
        var newLookupValueField = this._newLookupValueField;
        var lookupDataValueField = newLookupValueField.ItemsDataValueField;
        if (String.isNullOrEmpty(lookupDataValueField))
            lookupDataValueField = sender._keyFields[0].Name;
        if (args.result.Values.length == 0) args.result.Values = sender._lastArgs.Values;
        for (var j = 0; j < args.result.Values.length; j++)
            if (args.result.Values[j].Name == lookupDataValueField) {
                v = args.result.Values[j].NewValue;
                break;
            }
        var t = null;
        var lookupDataTextField = newLookupValueField.ItemsDataTextField;
        if (String.isNullOrEmpty(lookupDataTextField))
            lookupDataTextField = sender._fields[0].Name;
        for (i = 0; i < sender._lastArgs.Values.length; i++) {
            if (sender._lastArgs.Values[i].Name == lookupDataTextField) {
                t = sender._lastArgs.Values[i].NewValue;
                break;
            }
        }
        this._createNewView.endModalState('Cancel');
        this._copyLookupValues(null, newLookupValueField, sender._lastArgs.Values);
        this.changeLookupValue(newLookupValueField.Index, v, t);
        this._lookupIsActive = false;
    },
    hideLookup: function (fieldIndex) {
        var field = fieldIndex ? this._allFields[fieldIndex] : this.get_lookupField();
        var dv = this.get_lookupField()._dataView;
        dv._closeLookup(field);
        dv._restoreTabIndexes();
        $get(dv.get_id() + '_Item' + field.Index + '_ShowLookupLink').focus();
    },
    closeLookupAndCreateNew: function () {
        this.hideLookup();
        var field = this.get_lookupField();
        field._dataView.createNewLookupValue(field.Index);
    },
    htmlEncode: function (field, s) { var f = this._allFields[field.AliasIndex]; return f.HtmlEncode ? (f.Type == 'String' ? Web.DataView.htmlEncode(s) : s) : s; },
    filterIsExternal: function (fieldName) {
        if (this._externalFilter.length == 0) return false;
        for (var i = 0; i < this._filter.length; i++) {
            var name = this._filter[i].match(/(\w+):/)[1];
            var found = false;
            if (!fieldName || fieldName == name)
                for (var j = 0; j < this._externalFilter.length; j++)
                    if (this._externalFilter[j].Name == name) {
                        found = true;
                        break;
                    }
            if (!found) return false;
        }
        return true;
    },
    updateSummary: function () {
        if (!this.get_showInSummary()) return;
        var summaryBox = null;
        if (!this._summaryId) {
            var sideBar = $getSideBar();
            if (!sideBar) this._summaryId = '';
            else {
                this._summaryId = 'PageSummary_' + this.get_id();
                summaryBox = $get('PageSummaryBox');
                if (!summaryBox) {
                    summaryBox = document.createElement('div');
                    summaryBox.id = 'PageSummaryBox';
                    summaryBox.className = 'TaskBox Summary';
                    summaryBox.innerHTML = String.format('<div class="Inner"><div class="Summary">{0}</div></div>', Web.DataViewResources.Menu.Summary);
                    sideBar.insertBefore(summaryBox, sideBar.childNodes[sideBar._hasActivators ? 1 : 0]);
                    summaryBox._numberOfVisibleSummaries = 0;
                }
                var viewSummary = $get(this._summaryId);
                if (!viewSummary) {
                    viewSummary = document.createElement('div');
                    viewSummary.id = this._summaryId;
                    summaryBox.childNodes[0].appendChild(viewSummary);
                }
            }
        }
        if (this._summaryId.length > 0) {
            if (!summaryBox) summaryBox = $get('PageSummaryBox');
            if (!this._rows || this._rows.length == 0) {
                Sys.UI.DomElement.setVisible(summaryBox, false);
                return;
            }
            var row = this.get_selectedRow();
            viewSummary = $get(this._summaryId);
            var sb = new Sys.StringBuilder();
            var saveLastCommandName = this._lastCommandName;
            var saveViewType = this.get_view().Type;
            this.get_view().Type = 'Grid';
            this._lastCommandName = null;
            var empty = true;
            if (this._selectedKey.length > 0) {
                var first = true;
                var count = 0;
                for (var i = 0; i < this._allFields.length; i++) {
                    var f = this._allFields[i];
                    if (f.ShowInSummary/* && !f.Hidden*/) {
                        empty = false;
                        sb.append('<div class="Field">');
                        if (first)
                            first = false;
                        else
                            sb.append('<div class="Divider"></div>');
                        sb.appendFormat('<div class="Label">{0}</div>', String.trimLongWords(this._allFields[f.AliasIndex].Label));
                        sb.append('<div class="Value">');
                        this._renderItem(sb, f, row, false, false, false, false, true);
                        sb.append('</div></div>');
                        count++;
                        if (this.get_summaryFieldCount() > 0 && count >= this.get_summaryFieldCount()) break;
                    }
                }
            }
            Sys.UI.DomElement.setVisible(viewSummary, !empty);
            if (empty && this._summaryIsVisible)
                summaryBox._numberOfVisibleSummaries--;
            else if (!empty && !this._summaryIsVisible || !empty && this._summaryIsVisible == null)
                summaryBox._numberOfVisibleSummaries++;
            this._summaryIsVisible = !empty;
            Sys.UI.DomElement.setVisible(summaryBox, summaryBox._numberOfVisibleSummaries > 0);
            var s = sb.toString();
            viewSummary.innerHTML = s;
            var clearPermalink = this._lastArgs != this._lastClearArgs && this._lastArgs.CommandName == 'Delete';
            if (!$appfactory.mobile && (!empty || clearPermalink) && this.get_filterSource() == null && typeof (Web.Membership) != "undefined") {
                if (clearPermalink) this._lastClearArgs = this._lastArgs;
                Web.Membership._instance.addPermalink(String.format('{0}&_controller={1}&_commandName=Select&_commandArgument=editForm1', this.get_keyRef(), this.get_controller()), clearPermalink ? null : String.format('<div class="TaskBox" style="width:{2}px"><div class="Inner"><div class="Summary">{0}</div>{1}</div></div>', document.title, s, viewSummary.offsetWidth == 0 ? 135 : viewSummary.offsetWidth));
            }
            sb.clear();
            this._lastCommandName = saveLastCommandName;
            this.get_view().Type = saveViewType;
        }
    },
    get_hasDetails: function () {
        return this._hasDetails == true;
    },
    get_hasParent: function () {
        return this._hasParent == true;
    },
    get_usesTransaction: function () {
        return this._usesTransaction == true;
    },
    get_inTransaction: function () {
        return this.get_transaction() != null;
    },
    add_selected: function (handler) {
        this._hasDetails = true;
        this.get_events().addHandler('selected', handler);
    },
    remove_selected: function (handler) {
        this.get_events().removeHandler('selected', handler);
    },
    raiseSelected: function (eventArgs) {
        if (Web.DataView._navigated) return;
        var handler = this.get_events().getHandler('selected');
        if (handler) handler(this, Sys.EventArgs.Empty);
        if (!this.multiSelect())
            this.set_selectedValue(this.get_selectedKey());
    },
    add_executed: function (handler) {
        this.get_events().addHandler('executed', handler);
    },
    remove_executed: function (handler) {
        this.get_events().removeHandler('executed', handler);
    },
    raiseExecuted: function (eventArgs) {
        var handler = this.get_events().getHandler('executed');
        if (handler) handler(this, eventArgs);
    },
    _closeLookup: function (field) {
        $closeHovers();
        if (field && field._lookupModalBehavior) {
            field._lookupModalBehavior.hide();
            $removeHandler(document.body, 'keydown', field._lookupDataControllerBehavior._bodyKeydownHandler);
        }
        this._lookupIsActive = false;
        if (event) {
            var ev = new Sys.UI.DomEvent(event);
            ev.stopPropagation();
            ev.preventDefault();
        }
    },
    _collectFieldValues: function (all) {
        //if (all == null) all = false;
        all = true;
        var values = new Array(),
            selectedRow = this.get_selectedRow(),
            inserting = this.get_isInserting(),
            extension = this.extension();
        if (extension && extension.collect)
            values = extension.collect();
        else {
            if (!selectedRow && !inserting) return values;
            for (var i = 0; i < this._allFields.length; i++) {
                var field = this._allFields[i],
                    isRadioButtonList = field.ItemsStyle == 'RadioButtonList',
                    element = this._get('_Item', i);
                if (field.ReadOnly && !all)
                    element = null;
                else if (isRadioButtonList) {
                    var j = 0,
                        option = $get(this.get_id() + '_Item' + i + '_' + j);
                    while (option) {
                        if (option.checked) {
                            element = option;
                            break;
                        }
                        else
                            element = null;
                        j++;
                        option = $get(this.get_id() + '_Item' + i + '_' + j);
                    }
                }
                else if (field.ItemsStyle == 'CheckBoxList' && element) {
                    j = 0;
                    option = $get(this.get_id() + '_Item' + i + '_' + j);
                    if (option) {
                        element.value = '';
                        while (option) {
                            if (option.checked) {
                                if (element.value.length > 0) element.value += ',';
                                element.value += option.value;
                            }
                            j++;
                            option = $get(this.get_id() + '_Item' + i + '_' + j);
                        }
                    }
                }
                if (field.ClientEditor && element) {
                    if (field.ClientEditor == 'Web$DataView$RichText') {
                        var factory = Web.DataView.EditorFactories[field.ClientEditor.replace('.', '$')]
                        if (factory.persist)
                            factory.persist(element);
                    }
                }
                else if (field.Editor && element) {
                    var frame = $get(element.id + '$Frame');
                    if (frame) {
                        editor = Web.DataView.Editors[field.EditorId];
                        if (editor)
                            element.value = editor.GetValue();

                    }
                }
                var elementValue = element ? element.value : null;
                if (elementValue)
                    if (field.Type.startsWith('Date')) {
                        var d = Date.tryParseFuzzyDate(elementValue, field.DataFormatString);
                        if (d != null && element.type == 'text')
                            elementValue = element.value = field.DateFmtStr ? String.format(field.DateFmtStr, d) : field.format(d);
                    }
                    else if (!String.isBlank(field.DataFormatString) && field.isNumber()) {
                        /* == '{0:c}' ir -- '{0:p} */
                        var n = Number.tryParse(elementValue);
                        if (n != null) {
                            if (field.DataFormatString.match(/\{0:p\}/i) && n > 1)
                                n = n / 100;
                            elementValue = element.value = field.format(n);
                        }
                    }
                if (field.TimeFmtStr) {
                    var timeElem = this._get('_Item$Time', i)
                    if (timeElem) {
                        d = Date.tryParseFuzzyTime(timeElem.value);
                        if (d != null) {
                            timeElem.value = String.localeFormat(field.TimeFmtStr, d);
                            elementValue += ' ' + timeElem.value;
                        }
                    }
                }
                if (!field.OnDemand && (element || field.IsPrimaryKey || (!field.ReadOnly || all))) {
                    var add = true;
                    var readOnly = false;
                    if (this._lastCommandName == 'BatchEdit') {
                        var cb = $get(String.format('{0}$BatchSelect{1}', this.get_id(), field.Index));
                        readOnly = field.TextMode == 4 || field.Hidden || field.ReadOnly;
                        add = field.IsPrimaryKey || readOnly || cb && cb.checked;
                    }
                    if (add) Array.add(values,
                        {
                            Name: field.Name, OldValue: inserting ? (/*this._newRow ? this._newRow[field.Index] : */null) : selectedRow[field.Index],
                            NewValue: element && elementValue != null ? (field.Type == 'Boolean' && elementValue.length > 0 ? elementValue == 'true' : (elementValue.length == 0 ? null : elementValue)) : (!inserting && (field.TextMode == 4 || field.Hidden || field.ReadOnly) ? selectedRow[field.Index] : null),
                            Modified: (element != null && !(!inserting && field.Type == 'String' && String.isNullOrEmpty(elementValue) && String.isNullOrEmpty(selectedRow[field.Index])) || isRadioButtonList && inserting && !field.AllowNulls),
                            ReadOnly: field.ReadOnly && !(field.IsPrimaryKey && inserting) || readOnly
                        });
                }
            }
        }
        for (i = 0; i < this._externalFilter.length; i++) {
            var filterItem = this._externalFilter[i];
            for (j = 0; j < values.length; j++) {
                var v = values[j];

                if (v.Name.toLowerCase() == filterItem.Name.toLowerCase() && v.NewValue == null) {
                    v.NewValue = typeof filterItem.Value == 'string' ? this.convertStringToFieldValue(this.findField(v.Name), filterItem.Value) : filterItem.Value;
                    v.Modified = true;
                    break;
                }
            }
        }
        return values;
    },
    _enumerateExpressions: function (type, scope, target) {
        var l = [];
        if (this._expressions) {
            for (var i = 0; i < this._expressions.length; i++) {
                var e = this._expressions[i];
                if (e.Scope == scope && (type == Web.DynamicExpressionType.Any || e.Type == Web.DynamicExpressionType.RegularExpression) && e.Target == target)
                    Array.add(l, e);
            }
        }
        return l;
    },
    _prepareJavaScriptExpression: function (expression) {
        if (!expression._variables) {
            var vars = [];
            var re = /\[(\w+)\]/g;
            var m = re.exec(expression.Test);
            while (m) {
                var fieldName = m[1];
                var found = false;
                for (var i = 0; i < vars.length; i++) {
                    if (vars[i].name == fieldName) {
                        found = true;
                        break;
                    }
                }
                if (!found) {
                    var f = this.findField(fieldName);
                    if (f)
                        Array.add(vars, { 'name': fieldName, 'regex': new RegExp('\\[' + fieldName + '\\]', 'g'), 'replace': String.format('this._javaScriptRowValue({0})', f.Index) });
                }
                m = re.exec(expression.Test);
            }
            expression._variables = vars;
            expression.Test = expression.Test.replace(/\[(\w+)\.(\w+)\]/gi, 'this.fieldValue(\'$2\',\'$1\')');
        }
    },
    _javaScriptRowValue: function (fieldIndex, source) {
        return this._javaScriptRow[fieldIndex];
    },
    _evaluateJavaScriptExpressions: function (expressions, row, concatenateResult) {
        var result = concatenateResult ? '' : null;
        for (var i = 0; i < expressions.length; i++) {
            var exp = expressions[i];
            if (exp.Type == Web.DynamicExpressionType.ClientScript) {
                this._prepareJavaScriptExpression(exp);
                var script = exp._script;
                if (!script) {
                    script = exp.Test;
                    for (var j = 0; j < exp._variables.length; j++) {
                        var v = exp._variables[j];
                        script = script.replace(v.regex, v.replace);
                    }
                    exp._script = script;
                }
                if (script) {
                    this._javaScriptRow = row;
                    try {
                        var r = eval(script);
                        if (concatenateResult) {
                            if (r) {
                                if (result == null) result = exp.Result;
                                else result += ' ' + exp.Result;
                            }
                        }
                        else
                            return exp.Result == null ? r : exp.Result;
                    }
                    catch (er) {
                    }
                    finally {
                        this._javaScriptRow = null;
                    }
                }
            }
        }
        return result;
    },
    _validateFieldValueFormat: function (field, v) {
        var error = null;
        switch (field.Type) {
            case 'SByte':
            case 'Byte':
            case 'Int16':
            case 'Int32':
            case 'UInt32':
            case 'Int64':
            case 'Single':
            case 'Double':
            case 'Decimal':
            case 'Currency':
                var newValue = v.NewValue;
                if (typeof (newValue) != 'number')
                    newValue = Number.tryParse(newValue);
                if (/*String.format('{0}', newValue)*/isNaN(newValue) || newValue == null)
                    error = Web.DataViewResources.Validator.NumberIsExpected;
                else
                    v.NewValue = newValue;
                break;
            case 'Boolean':
                try {
                    v.NewValue = String.isInstanceOfType(v.NewValue) ? Boolean.parse(v.NewValue) : v.NewValue;
                }
                catch (e) {
                    error = Web.DataViewResources.Validator.BooleanIsExpected;
                }
                break;
            case 'DateTime':
                //case 'DateTimeOffset':
                if (typeof v.NewValue == 'string') {
                    newValue = !String.isNullOrEmpty(field.DataFormatString) ? Date.parseLocale(v.NewValue, field.DataFormatString.match(/\{0:([\s\S]*?)\}/)[1]) : Date.parse(v.NewValue);
                    if (!newValue)
                        error = Web.DataViewResources.Validator.DateIsExpected;
                    else
                        v.NewValue = newValue;
                    if (!error && v.NewValue != null) v.NewValue = new Date(v.NewValue - v.NewValue.getTimezoneOffset() * 60 * 1000);
                }
                break;
        }
        return error;
    },
    validate: function (values) {
        for (var i = 0; i < values.length; i++)
            if (values[i].Error)
                return false;
        return true;
    },
    _validateFieldValues: function (values, displayErrors, focusedCell) {
        var valid = true;
        var sb = new Sys.StringBuilder();
        for (var i = 0; i < values.length; i++) {
            var v = values[i];
            var field = this.findField(v.Name);
            if (!field || focusedCell && field.ColIndex != focusedCell.colIndex) continue;
            if (field.Type == 'DateTime' && v.OldValue != null && v.OldValue.getTimezoneOffset) v.OldValue = new Date(v.OldValue - v.OldValue.getTimezoneOffset() * 60 * 1000);
            var error = null;
            if (field.ReadOnly && field.IsPrimaryKey) {
                if (v.NewValue == null && v.OldValue != null)
                    v.NewValue = v.OldValue;
            }
            else if (v.Modified /*&& (typeof (__designerMode) == 'undefined' || !v.ReadOnly && !(field.ReadOnly && field.IsPrimaryKey))*/) {
                // see if the field is blank
                if (!field.AllowNulls && (!field.HasDefaultValue || Web.DataViewResources.Validator.EnforceRequiredFieldsWithDefaultValue)) {
                    if (String.isBlank(v.NewValue) && !field.Hidden && !field.isReadOnly())
                        error = Web.DataViewResources.Validator.RequiredField;
                }
                // convert blank values to "null"
                if (!error && String.isBlank(v.NewValue))
                    v.NewValue = null;
                // convert to the "typed" value
                if (!error && v.NewValue != null && !field.IsMirror && (!field.Hidden || v.Modified)) {
                    var fieldError = this._validateFieldValueFormat(field, v);
                    if (!field.isReadOnly())
                        error = fieldError;
                }
                if (!error) {
                    var expressions = this._enumerateExpressions(Web.DynamicExpressionType.RegularExpression, Web.DynamicExpressionScope.Field, v.Name);
                    for (var j = 0; j < expressions.length; j++) {
                        var exp = expressions[j];
                        var s = v.NewValue ? v.NewValue : '';
                        try {
                            var re = new RegExp(exp.Test);
                            var m = re.exec(s);
                            if (exp.Result.match(/\$(\d|\'\`)/)) {
                                if (m) v.NewValue = s.replace(re, exp.Result);
                            }
                            else {
                                if (!m) error = error ? error += exp.Result : exp.Result;
                            }
                        }
                        catch (ex) {
                        }
                    }
                }
                // see if the value has been modified
                v.Modified = field.Type.startsWith('DateTime') ? ((v.NewValue == null ? null : v.NewValue.toString()) != (v.OldValue == null ? null : v.OldValue.toString())) : v.NewValue != v.OldValue;
            }
            v.Error = error;
            // display/hide the error as needed
            if ($appfactory.mobile) {
                if (error && displayErrors) {
                    this._focus(field.Name, error);
                    valid = false;
                }
            }
            else {
                var errorElement = $get(this.get_id() + '_Item' + field.Index + '_Error');
                if (errorElement && displayErrors) {
                    //Sys.UI.DomElement.setVisible(errorElement, error != null);
                    Sys.UI.DomElement.setVisible(errorElement, false);
                    errorElement.innerHTML = error;
                    if (error != null && valid)
                        this._showFieldError(field, error);
                    var elem = errorElement.parentNode;
                    while (elem && elem.tagName != 'BODY') {
                        if (!$common.getVisible(elem)) {
                            errorElement = null;
                            break;
                        }
                        elem = elem.parentNode;
                    }
                }
                if (error && displayErrors) {
                    if (valid) {
                        var lastFocusedCell = this._lastFocusedCell;
                        if (lastFocusedCell) {
                            this._focusCell(-1, -1, false);
                            this._focusCell(lastFocusedCell.rowIndex, lastFocusedCell.colIndex, true);
                            this._lastFocusedCell = null;
                        }
                        this._focus(field.Name);

                    }
                    valid = false;
                    if (!errorElement) sb.append(Web.DataView.formatMessage('Attention', field.Label + ": " + error));
                }
            }
        }
        if (!displayErrors) valid = true;
        if (!valid)
            Web.DataView.showMessage(sb.toString());
        sb.clear();
        return valid;
    },
    _fieldIsInExternalFilter: function (field) {
        return this._findExternalFilterItem(field) != null;
    },
    _findExternalFilterItem: function (field) {
        for (var i = 0; i < this._externalFilter.length; i++) {
            var filterItem = this._externalFilter[i];
            if (field.Name.toLowerCase() == filterItem.Name.toLowerCase())
                return filterItem;
        }
        return null;
    },
    _internalFocus: function () {
        var elem = $get(this._focusId);
        if (elem)
            try {
                elem.value = '';
                elem.value = this._focusText;
                Sys.UI.DomElement.setCaretPosition(elem, this._focusText.length);
            }
            catch (err) {
            }
    },
    _showFieldError: function (field, message) {
        var error = this._get('_Item', field.Index + '_Error');
        if (error) {
            Sys.UI.DomElement.setVisible(error, message != null);
            if (message) {
                this._skipErrorReset = true;
                error.style.marginLeft = '0px';
                error.style.marginTop = '0px';
                error.innerHTML = String.format('{0} <a href="javascript:" onclick="Sys.UI.DomElement.setVisible(this.parentNode, false);$find(\'{2}\')._focus(\'{3}\');return false" class="Close" title="{1}"><span>&nbsp;</span></a>', message, Web.DataViewResources.ModalPopup.Close, this.get_id(), field.Name);
                if (this.get_isForm()) {
                    var pp = $common.getPaddingBox(error.previousSibling ? error.previousSibling : error);
                    error.style.marginLeft = pp.left + 'px';
                    error.style.marginTop = 1 + 'px';
                }
                else {
                    var scrolling = $appfactory.scrolling(); // $common.getScrolling();
                    var cb = $common.getClientBounds();
                    var eb = $common.getBounds(error);
                    var deltaX = eb.x + eb.width - (scrolling.x + cb.width);
                    if (deltaX < 0)
                        deltaX = 0;
                    var pb = $common.getBounds(error.parentNode);
                    pp = $common.getPaddingBox(error.parentNode);
                    var nextSibling = error.nextSibling;
                    while (nextSibling && nextSibling.nodeType != 1)
                        nextSibling = nextSibling.nextSibling;
                    var b = $common.getBounds(nextSibling ? nextSibling : error);
                    error.style.marginLeft = (-(b.x - pb.x + 1 + deltaX)) + 'px';
                    error.style.marginTop = (b.height + pp.bottom) + 'px'; //(pb.height - (b.y - pb.y)) + 'px';
                }
            }
        }
    },
    _focus: function (fieldName, message) {
        if ($appfactory.mobile) {
            $appfactory.mobile.focus(fieldName, message);
            return;
        }
        if (message) {
            for (var i = 0; i < this.get_fields().length; i++) {
                this._showFieldError(this.get_fields()[i]);
            }
        }
        var cell = this._get_focusedCell();
        if (cell && this.get_isEditing() && this._id == Web.DataView._activeDataSheetId) {
            if (!String.isNullOrEmpty(fieldName)) {
                var field = null;
                var cellChanged = false;
                for (i = 0; i < this._fields.length; i++) {
                    field = this._fields[i];
                    if (field.Name == fieldName) {
                        this._focusCell(cell.rowIndex, cell.colIndex, false);
                        cellChanged = cell.colIndex != i;
                        cell = { rowIndex: this._selectedRowIndex, colIndex: i };
                        if (!this._continueAfterScript)
                            this._saveAndNew = false;
                        break;
                    }
                }
                if (!String.isNullOrEmpty(message) && field) {
                    if (cellChanged) {
                        this._focusCell(cell.rowIndex, cell.colIndex, true);
                        this.refresh(true);
                    }
                    this._showFieldError(field, message);
                }
            }
            var cellElem = this._focusCell(cell.rowIndex, cell.colIndex, true);
            if (cellElem) {
                var list = cellElem.getElementsByTagName('input');
                var canFocus = false;
                for (i = 0; i < list.length; i++)
                    if (list[i].type != 'hidden') {
                        canFocus = true;
                        break;
                    }
                if (!canFocus)
                    list = cellElem.getElementsByTagName('textarea');
                if (list.length == 0)
                    list = cellElem.getElementsByTagName('select');
                if (list.length == 0)
                    list = cellElem.getElementsByTagName('a');
                for (i = 0; i < list.length; i++) {
                    var elem = list[i];
                    if (elem.tagName != 'INPUT' || elem.type != 'hidden') {
                        if ((elem.tagName == 'INPUT' || elem.tagName == 'TEXTAREA') && this._pendingChars != null) {
                            this._focusText = this._pendingChars;
                            this._focusId = elem.id;
                            var self = this;
                            setTimeout(function () {
                                self._internalFocus();
                            }, 50);
                        }
                        else
                            Sys.UI.DomElement.setFocus(elem);
                        break;
                    }
                }
            }
            this._pendingChars = null;
            return;
        }
        if (String.isNullOrEmpty(fieldName) && !String.isNullOrEmpty(this._focusedFieldName)) {
            field = this.findField(this._focusedFieldName);
            if (field) fieldName = field.Name;
        }
        this._focusedFieldName = fieldName;
        for (i = 0; i < this.get_fields().length; i++) {
            field = this.get_fields()[i];
            var autoComplete = field.ItemsStyle == 'AutoComplete' && (field.Name == fieldName || field.AliasName == fieldName || String.isNullOrEmpty(fieldName));
            if (!field.ReadOnly && (fieldName == null || field.Name == fieldName || autoComplete)) {
                var elemId = this.get_id() + '_Item' + (autoComplete ? field.AliasIndex : field.Index);
                switch (field.ItemsStyle) {
                    case 'RadioButtonList':
                    case 'CheckBoxList':
                        elemId += '_0';
                        break;
                    case 'Lookup':
                        elemId += '_ShowLookupLink';
                        break;
                }
                var element = $get(elemId);
                var c = $get(String.format('{0}_ItemContainer{1}', this.get_id(), field.Index));
                var cat = this._categories[field.CategoryIndex];
                var categoryTabIndex = Array.indexOf(this._tabs, cat.Tab);
                if (fieldName && categoryTabIndex >= 0) this.set_categoryTabIndex(categoryTabIndex);
                this._toggleCategoryVisibility(field.CategoryIndex, true);
                if (element && (!c || Sys.UI.DomElement.getVisible(c))) {
                    if (fieldName || (categoryTabIndex == this.get_categoryTabIndex() || this._tabs.length == 0)) {
                        if (categoryTabIndex >= 0) this.set_categoryTabIndex(categoryTabIndex);
                        try {
                            if (message) {
                                this._showFieldError(field, message);
                            }
                            Sys.UI.DomElement.setFocus(element);
                        }
                        catch (ex) {
                        }
                        break;
                    }
                }
            }
        }
    },
    _serverFocus: function (fieldName, message) {
        this._focus(fieldName, message);
        if (this.get_isDataSheet()) {
            this.refresh(true);
            this._focus(fieldName, message);
        }
    },
    _saveTabIndexes: function () {
        this._lastSavedTabIndexes = this._savedTabIndexes;
        this._savedTabIndexes = [];
        for (var i = 0; i < Web.DataView._tagsWithIndexes.length; i++) {
            var tags = document.getElementsByTagName(Web.DataView._tagsWithIndexes[i]);
            for (var j = 0; j < tags.length; j++) {
                var elem = tags[j];
                if (elem)
                    Array.add(this._savedTabIndexes, { element: elem, tabIndex: elem.tabIndex });
            }
        }
    },
    _restoreTabIndexes: function () {
        if (this._savedTabIndexes) {
            for (var i = 0; i < this._savedTabIndexes.length; i++) {
                this._savedTabIndexes[i].element.tabIndex = this._savedTabIndexes[i].tabIndex;
                delete this._savedTabIndexes[i].element;
            }
            Array.clear(this._savedTabIndexes);
        }
        this._savedTabIndexes = this._lastSavedTabIndexes;
        this._lastSavedTabIndexes = null;
    },
    _selectKeyByRowIndex: function (rowIndex) {
        this._selectKeyByRow(this._rows[rowIndex]);
    },
    _selectKeyByRow: function (row) {
        this._selectedRow = row;
        var oldKey = this._selectedKey;
        this._selectedKey = [];
        this._selectedKeyFilter = []
        for (var i = 0; i < this._keyFields.length; i++) {
            var field = this._keyFields[i];
            Array.add(this._selectedKey, row[field.Index]);
            Array.add(this._selectedKeyFilter, field.Name + ':=' + this.convertFieldValueToString(field, row[field.Index]));
            if (oldKey && (oldKey.length < i || (oldKey[i] != this._selectedKey[i]))) oldKey = null;
        }
        this.updateSummary();
        if (!oldKey && !this._raiseSelectedDelayed) this.raiseSelected();
    },
    _showWait: function (force) {
        if ($appfactory.mobile) return;
        //   $.mobile.loading('show');
        var waitHtml = Web.DataViewResources.Common.WaitHtml;
        if (this.get_fields() == null || force) {
            this._container.innerHTML = this.get_isModal() || this.get_lookupField() ? waitHtml : '<div class="dataview-busy-whitespace"></div>';
            $(this._container).find('.Wait').addClass('dataview');
        }
        else {
            var wait = $get(this.get_id() + '_Wait');
            if (wait) {
                this._oldWaitHTML = wait.innerHTML;
                wait.innerHTML = waitHtml;
            }
        }
        var extension = this.extension();
        if (extension)
            extension.wait();
    },
    _hideWait: function () {
        if (this._oldWaitHTML != null) {
            var waitElement = $get(this.get_id() + '_Wait');
            if (waitElement) waitElement.innerHTML = this._oldWaitHTML;
        }
    },
    _get_colSpan: function () {
        return this.get_isForm() ? 2 : this.get_fields().length +
            (this.multiSelect() ? 1 : 0) +
            (this.get_showIcons() ? 1 : 0) +
            (this.get_isDataSheet() ? 1 : 0) +
            (this._actionColumn ? 1 : 0);
    },
    _renderCreateNewBegin: function (sb, field) { if (!String.isNullOrEmpty(field.ItemsNewDataView)) sb.append('<table cellpadding="0" cellspacing="0"><tr><td>'); },
    _renderCreateNewEnd: function (sb, field) {
        if (!String.isNullOrEmpty(field.ItemsNewDataView)) {
            sb.append('</td><td>');
            if (this.get_enabled())
                sb.appendFormat('<a href="#" class="CreateNew" onclick="$find(\'{0}\').createNewLookupValue({1});return false" id="{0}_Item{1}_CreateNewLookupLink" title="{2}"{3}>&nbsp;</a>',
                    this.get_id(), field.Index, String.format(Web.DataViewResources.Lookup.NewToolTip, field.Label), String.format(' tabindex="{0}"', $nextTabIndex()));
            sb.append('</td></tr></table>');
        }
    },
    _raisePopulateDynamicLookups: function () {
        if (this._hasDynamicLookups && this.get_isEditing() && this._skipPopulateDynamicLookups != true)
            this.executeCommand({ 'commandName': 'PopulateDynamicLookups', 'commandArgument': '', 'causesValidation': false });
        this._skipPopulateDynamicLookups = false;
    },
    _raiseCalculate: function (field, triggerField) {
        this.executeCommand({ 'commandName': 'Calculate', 'commandArgument': field.Name, 'causesValidation': false, 'trigger': triggerField.Name });
    },
    get_currentRow: function () {
        return this.get_isInserting() ? (this._newRow ? this._newRow : []) : this.get_selectedRow();
    },
    fieldValue: function (fieldName, source) {
        var dataView = !source || source.length == 0 ? this : (source.match(/^master$/i) ? this.get_master() : $find(source));
        if (!dataView) return null;
        if (!dataView._allFields)
            return null;
        var f = dataView.findField(fieldName);
        if (!f) return null;
        var r = dataView._clonedRow;
        if (r == null)
            r = dataView._cloneChangedRow();
        return r ? r[f.Index] : null;
    },
    _useLEVs: function (row) {
        if (row && this._allowLEVs) {
            var r = this._get_LEVs();
            if (r.length > 0) {
                for (i = 0; i < r[0].length; i++) {
                    var v = r[0][i];
                    f = this.findField(v.Name);
                    if (f && f.AllowLEV) {
                        if (this._lastCommandName == 'New' && v.Modified && v.NewValue != null) {
                            var copy = true;
                            for (var k = 0; k < this._externalFilter.length; k++) {
                                if (this._externalFilter[k].Name.toLowerCase() == v.Name.toLowerCase()) {
                                    copy = false;
                                    break;
                                }
                            }
                            if (copy)
                                row[f.Index] = v.NewValue;
                        }
                        f._LEV = v.Modified ? v.NewValue : null;
                    }
                }
            }
        }
    },
    _configure: function (row) {
        if (!this._requiresConfiguration) return;
        if (!row) row = this.get_currentRow();
        if (!row) return;
        for (var i = 0; i < this._allFields.length; i++) {
            var f = this._allFields[i];
            if (!String.isNullOrEmpty(f.Configuration)) {
                var iterator = /\s*(\w+)=(\w+)\s*?($|\n)/g;
                var m = iterator.exec(f.Configuration);
                while (m) {
                    var sourceField = this.findField(m[2]);
                    if (sourceField) {
                        var v = row[sourceField.Index];
                        if (v) f[m[1]] = v;
                    }
                    m = iterator.exec(f.Configuration);
                }
            }
        }
    },
    _focusQuickFind: function (force) {
        if (!this._quickFindFocused || force == true) {
            this._lostFocus = true;
            try {
                Sys.UI.DomElement.setFocus(this.get_quickFindElement());
                //this.get_quickFindElement().select();
                //this.get_quickFindElement().focus();
            }
            catch (ex) {
            }
            this._quickFindFocused = true;
        }
    },
    _restoreEmbeddedViews: function () {
        if (!this._embeddedViews) return;
        for (var i = 0; i < this._embeddedViews.length; i++) {
            var ev = this._embeddedViews[i];
            ev.parent.appendChild(ev.view._element);
            delete ev.parent;
            ev.view = null;
        }
        Array.clear(this._embeddedViews);
    },
    _incorporateEmbeddedViews: function () {
        if (!this._embeddedViews) return;
        for (var i = 0; i < this._embeddedViews.length; i++) {
            var ev = this._embeddedViews[i];
            var placeholder = $get('v_' + ev.view.get_cookie().replace(/-/g, ''));
            var elem = ev.view._element;
            ev.parent = elem.parentNode;
            placeholder.appendChild(elem);
        }
    },
    _render: function (refreshExtension) {
        if ($appfactory.mobile) {
            if (refreshExtension)
                this._refreshExtension();
        }
        else {
            this._restoreEmbeddedViews();
            this._detachBehaviors();
            this._disposeSearchBarExtenders();
            //var checkWidth = this.get_view() && this.get_isForm()/* this.get_view().Type == 'Form'*/ && this._numberOfColumns > 1;
            //var width = this.get_element().offsetWidth;
            this._useLEVs();
            this._configure();
            this._internalRender();
            if (this._viewMessages)
                this.showViewMessage(this._viewMessages[this.get_viewId()]);
            //if (!this.get_isModal() && checkWidth && width < this.get_element().offsetWidth) {
            //            this._dittoCollectedValues();
            //            var oldNumberOrColumns = this._numberOfColumns;
            //            this._numberOfColumns = 1;
            //            this._ignoreColumnIndex = true;
            //            this._internalRender();
            //            this._numberOfColumns = oldNumberOrColumns;
            //            this._ignoreColumnIndex = false;
            //}
            this._raisePopulateDynamicLookups();
            if (!this.get_modalAnchor() && this.get_lookupField())
                this._focusQuickFind();
            if (this._raiseSelectedDelayed) {
                this._raiseSelectedDelayed = false;
                this.raiseSelected();
                this._forceChanged = false;
            }
            if (this._scrollIntoView) {
                this._scrollIntoView = false;
                var bounds = $common.getBounds(this._element);
                var scrolling = $appfactory.scrolling(); // $common.getScrolling();
                if (bounds.y < scrolling.y)
                    this._element.scrollIntoView(true);
            }
            this._incorporateEmbeddedViews();
            if (this.get_isModal())
                this._adjustModalPopupSize();
            if (this.get_searchOnStart() && this.get_isGrid() /*this.get_viewType() == 'Grid'*/) {
                this._focusSearchBar();
                this.set_searchOnStart(false);
            }
            if (this.get_isDataSheet()) {
                var fc = this._get_focusedCell();
                if (this.get_isInserting() && !fc) {
                    this._startInputListenerOnCell(0, 0);
                }
                else if (fc && this._id == Web.DataView._activeDataSheetId) {
                    this._skipCellFocus = true;
                    this._focusCell(-1, -1, true);
                }
            }
            if (this.get_isGrid() && this._synced) {
                this._synced = false;
                if (this._selectedRowIndex == null) {
                    this._forgetSelectedRow(true);
                    this.refresh(true);
                }
            }
            this._syncKeyFilter();
        }
    },
    _syncKeyFilter: function () {
        var key = this.get_selectedKey();
        if (key.length > 0 && this._selectedKeyFilter.length == 0) {
            for (var i = 0; i < this._keyFields.length; i++) {
                var f = this._keyFields[i];
                Array.add(this._selectedKeyFilter, f.Name + ':=' + this.convertFieldValueToString(f, key[i]));
            }
        }
    },
    _mergeRowUpdates: function (row) {
        if (this._lastCommandName == 'BatchEdit') {
            var batchEdit = this._batchEdit = [];
            var allFields = this._allFields;
            $(this._element).find('.BatchSelect input:checkbox:checked').each(function () {
                var m = this.id.match(/BatchSelect(\d+)$/);
                if (m) {
                    var f = allFields[parseInt(m[1])];
                    Array.add(batchEdit, f.Name);
                }
            });
        }
        this._originalRow = null;
        this._useLEVs(row);
        if (this.get_isEditing() && this._ditto) {
            this._originalRow = Array.clone(row);
            for (var i = 0; i < this._ditto.length; i++) {
                var d = this._ditto[i];
                var f = this.findField(d.name);
                if (f && !(f.ReadOnly && f.IsPrimaryKey))
                    row[f.Index] = d.value;
            }
            delete this._ditto;
        }
        this._configure(row);
        this._mergedRow = row;
    },
    _removeRowUpdates: function () {
        var row = this._mergedRow;
        if (!row) return;
        if (this._originalRow) {
            for (var i = 0; i < this._originalRow.length; i++)
                row[i] = this._originalRow[i];
        }
        this._mergedRow = null;
    },
    _internalRender: function () {
        this._multipleSelection = null;
        this._dynamicActionButtons = false;
        var viewType = this.get_viewType();
        var sb = new Sys.StringBuilder();
        if (this.get_mode() == Web.DataViewMode.Lookup) {
            var field = this._fields[0];
            var v = this.get_lookupText();
            if (v == null) v = Web.DataViewResources.Lookup.SelectLink;
            var s = field.format(v);
            this._renderCreateNewBegin(sb, field);
            sb.appendFormat('<table cellpadding="0" cellspacing="0" class="DataViewLookup"><tr><td><a href="javascript:" onclick="$find(\'{0}\').showLookup({1});return false" class="Select" id="{0}_Item{1}_ShowLookupLink" title="{3}" tabindex="{7}"{8}>{2}</a><a href="#" class="Clear" onclick="$find(\'{0}\').clearLookupValue({1});return false" id="{0}_Item{1}_ClearLookupLink" title="{5}" tabindex="{7}">&nbsp;</a></td></tr></table><input type="hidden" id="{0}_Item{1}" value="{4}"/><input type="hidden" id="{0}_Text{1}" value="{6}"/>',
                this.get_id(), field.Index, this.htmlEncode(field, s), String.format(Web.DataViewResources.Lookup.SelectToolTip, field.Label), this.get_lookupValue(), String.format(Web.DataViewResources.Lookup.ClearToolTip, field.Label), Web.DataView.htmlAttributeEncode(s), $nextTabIndex(), this.get_enabled() ? '' : ' disabled="true" class="Disabled"');
            this._renderCreateNewEnd(sb, field);
            this.get_element().appendChild(this._container);
            this._container.innerHTML = sb.toString();
            if (this.get_lookupValue() == '' || !this.get_enabled()) $get(this.get_id() + '_Item0_ClearLookupLink').style.display = 'none';
        }
        else {
            var isForm = viewType == 'Form';
            sb.appendFormat('<table class="DataView {1}_{2}{3}{4} {5}Type" cellpadding="0" cellspacing="0"{0}>', this.get_isModal() ? String.format(' style="width:{0}px"', this._container.offsetWidth - 20) : '', this.get_controller(), this.get_viewId(), this._numberOfColumns > 0 ? ' MultiColumn' : '', this._tabs.length > 0 ? ' Tabbed' : '', viewType);
            if (isForm)
                this._renderFormView(sb);
            else
                this._renderGridView(sb);
            sb.append('</table>');
            if (this._mergedRow) {
                var cell = this._get_focusedCell();
                var inserting = this.get_isInserting();
                var isDataSheet = this.get_isDataSheet();
                for (var i = 0; i < this._allFields.length; i++) {
                    var f = this._allFields[i];
                    var unfocusedCell = cell && i != this._fields[cell.colIndex].Index;
                    if (f.Hidden && (!f.IsPrimaryKey || inserting) || unfocusedCell || !cell && inserting && isDataSheet) {
                        v = this._mergedRow[i];
                        if (v != null || isDataSheet && !inserting/* || isDataSheet && (!f.IsPrimaryKey || !f.Hidden)*/)
                            sb.appendFormat('<input id="{0}_Item{1}" type="hidden" value="{2}"/>', this.get_id(), i, Web.DataView.htmlAttributeEncode(v != null ? f.format(v) : ''));
                    }
                }
            }
            this._container.innerHTML = sb.toString();
            if (this._multipleSelection != null && this._multipleSelection == true)
                $get(this.get_id() + '_ToggleButton').checked = true;
            this._attachBehaviors();
            this._updateVisibility();
            if (this.get_isEditing()) {
                if (this._lastCommandName == 'BatchEdit')
                    $(this._element).find('div.BatchSelect input:checkbox:checked').each(function () {
                        Web.DataView._updateBatchSelectStatus(this, isForm);
                    });
                this._focus();
            }
        }
        sb.clear();
        this._updateChart();
        this._updateSearchBar();
        this._removeRowUpdates();
        this._fixWidthOfColumns();
        this._fixHeightOfRow(true);
        this._refreshExtension();
    },
    _refreshExtension: function () {
        var extension = this.extension();
        var lastExtension = this._lastExtension;
        if (extension != lastExtension) {
            if (lastExtension)
                lastExtension.hide();
            if (extension)
                extension.show();
            this._lastExtension = extension;
        }
        if (extension)
            extension.refresh();
    },
    _get_headerRowElement: function () {
        var rows = this._container.childNodes[0].childNodes[0].childNodes;
        var i = 0;
        while (i < rows.length) {
            if (Sys.UI.DomElement.containsCssClass(rows[i], 'HeaderRow'))
                return rows[i];
            i++;
        }
        return null;
    },
    _fixWidthOfColumns: function () {
        if ((this.get_isDataSheet() || this.get_isGrid()) && !this.extension()) {
            var headerRow = this._get_headerRowElement();
            if (headerRow) {
                if (!this._viewColumnSettings)
                    this._viewColumnSettings = [];
                var fixedColumns = this._viewColumnSettings[this.get_viewId()];
                if (!fixedColumns) {
                    fixedColumns = [];
                    $(headerRow).addClass('Fixed');
                    // firt pass
                    for (var i = 0; i < headerRow.childNodes.length; i++) {
                        var cell = headerRow.childNodes[i];
                        var b = $common.getBounds(cell);
                        if (b.width == 0) {
                            Sys.UI.DomElement.removeCssClass(headerRow, 'Fixed');
                            return;
                        }
                        var pb = $common.getPaddingBox(cell);
                        var bb = $common.getBorderBox(cell);
                        var fc = { w: b.width - pb.horizontal - bb.horizontal, h: b.height - pb.vertical - bb.vertical };
                        Array.add(fixedColumns, fc);
                        //cell.style.width = fc.w + 'px';
                    }
                    var rowBounds = $common.getBounds(headerRow);
                    for (i = 0; i < fixedColumns.length; i++)
                        fixedColumns[i].h = rowBounds.height;
                    this._viewColumnSettings[this.get_viewId()] = fixedColumns;
                    Sys.UI.DomElement.removeCssClass(headerRow, 'Fixed');
                }
                //var hb = $common.getBounds(headerRow);
                //headerRow.style.height = (fixedColumns[0].h - hb.horizontal) + 'px';
                for (i = 0; i < headerRow.childNodes.length; i++) {
                    fc = fixedColumns[i];
                    if (fc) {
                        var headerCell = headerRow.childNodes[i];
                        headerCell.style.height = fc.h + 'px';
                        headerCell.style.width = fc.w + 'px';
                    }
                }
            }
        }
    },
    _fixHeightOfRow: function (apply) {
        if ((this.get_isDataSheet() || this.get_isGrid()) && (!apply || this.get_isEditing())) {
            var headerRow = this._get_headerRowElement();
            if (!headerRow) return;
            var fc = this._get_focusedCell();
            var rowIndex = this.get_isGrid() ? this._selectedRowIndex : fc.rowIndex;
            if (rowIndex >= 0) {
                var tBody = headerRow.parentNode;
                for (var i = 0; i < tBody.childNodes.length; i++)
                    if (tBody.childNodes[i] == headerRow)
                        break;
                var rowElem = tBody.childNodes[i + rowIndex + 1];
                if (rowElem) {
                    if (apply) {
                        if (this._selectedRowHeight)
                            rowElem.style.height = this._selectedRowHeight + 'px';
                        //                        if (this._selectedRowHeight)
                        //                            for (i = 0; i < rowElem.childNodes.length; i++) {
                        //                                rowElem.childNodes[i].style.height = (this._selectedRowHeight - 7) + 'px';
                        //                            }
                    }
                    else {
                        var b = $common.getBounds(rowElem);
                        this._selectedRowHeight = b.height;
                    }
                }
            }
        }
    },
    _updateChart: function () {
        if (this.get_isChart()) {
            var chart = this._get('$Chart');
            var w = chart.offsetWidth;
            if (w < 100)
                w = chart.parentNode.offsetWidth;
            var pageRequest = this._createParams();
            delete pageRequest.Transaction;
            delete pageRequest.LookupContextFieldName;
            delete pageRequest.LookupContextController;
            delete pageRequest.LookupContextView;
            delete pageRequest.LookupContext;
            delete pageRequest.LastCommandName;
            delete pageRequest.LastCommandArgument;
            delete pageRequest.Inserting;
            delete pageRequest.DoesNotRequireData;
            var r = Sys.Serialization.JavaScriptSerializer.serialize(pageRequest);
            var chartBounds = $common.getBounds(chart);
            //if (chartBounds.height > 0 && !String.isNullOrEmpty(chart.src))
            //    chart.style.height = chartBounds.height + 'px';
            var that = this;
            if (that._chartHeight)
                chart.style.height = that._chartHeight + 'px';
            //chart.src = String.format('{0}ChartHost.aspx?c={1}_{2}&w={3}&r={4}', this.get_baseUrl(), this.get_controller(), this.get_viewId(), w, encodeURIComponent(r));
            $(chart).one('load', function () {
                try {
                    //alert($(this).height());
                    that._chartHeight = $(this).height();
                }
                catch (ex) {
                }
            }).attr('src', String.format('{0}ChartHost.aspx?c={1}_{2}&w={3}&r={4}', this.get_baseUrl(), this.get_controller(), this.get_viewId(), w, encodeURIComponent(r)));

        }
    },
    _toggleCategoryVisibility: function (categoryIndex, visible) {
        var categoryFields = $get(String.format('{0}$Category${1}', this.get_id(), categoryIndex));
        if (categoryFields) {
            var cat = this.get_categories()[categoryIndex];
            if (!visible) visible = !Sys.UI.DomElement.getVisible(categoryFields);
            Sys.UI.DomElement.setVisible(categoryFields, visible);
            var button = $get(String.format('{0}$CategoryButton${1}', this.get_id(), categoryIndex));
            cat.Collapsed = !visible;
            if (visible) {
                Sys.UI.DomElement.removeCssClass(button, 'Maximize');
                button.childNodes[0].title = Web.DataViewResources.Form.Minimize;
            }
            else {
                $(button).addClass('Maximize');
                button.childNodes[0].title = Web.DataViewResources.Form.Maximize;
            }
            _body_performResize();
        }
    },
    _processTemplatedText: function (row, text) {
        if (!text) text = '';
        var iterator = /\{(\w+)\}/g;
        var m = iterator.exec(text);
        if (!m) return text;
        var sb = new Sys.StringBuilder();
        var index = 0;
        while (m) {
            sb.append(text.substring(index, m.index));
            var fieldName = m[1];
            index = m.index + fieldName.length + 2;
            var field = this.findField(fieldName);
            if (field) {
                sb.append('<span class="FieldPlaceholder">');
                this._renderItem(sb, field, row, false, false, false, false, false, true);
                sb.append('</span>');
            }
            else
                sb.appendFormat('[{0}]', fieldName);
            m = iterator.exec(text);
        }
        var lastIndex = text.length - 1;
        if (index < lastIndex)
            sb.append(text.substring(index, lastIndex));
        return sb.toString().replace(/ (id|for)=\".+?\"/g, '');
    },
    _get_selectedTab: function () {
        return this._tabs.length > 0 ? this._tabs[this.get_categoryTabIndex()] : null;
    },
    _renderFormView: function (sb) {
        var isEditing = this.get_isEditing();
        this._renderStatusBar(sb);
        this._renderViewDescription(sb);
        if (Web.DataViewResources.Form.ShowActionBar) this._renderActionBar(sb);
        var row = this.get_currentRow();
        this._mergeRowUpdates(row);
        this._updateVisibility(row);
        if (this.get_isInserting() && this._expressions) {
            for (i = 0; i < this._expressions.length; i++) {
                var exp = this._expressions[i];
                if (exp.Scope == Web.DynamicExpressionScope.DefaultValues && exp.Type == Web.DynamicExpressionType.ClientScript) {
                    f = this.findField(exp.Target);
                    if (f) {
                        if (String.isNullOrEmpty(exp.Test))
                            row[f.Index] = exp.Result;
                        else {
                            var r = eval(exp.Test);
                            if (r)
                                row[f.Index] = String.isNullOrEmpty(exp.Result) ? r : exp.Result;
                        }
                    }
                }
            }
        }
        var fieldCount = 0;
        for (i = 0; i < this._allFields.length; i++)
            if (!this._allFields[i].Hidden) fieldCount++;
        var hasButtonsOnTop = /*fieldCount > Web.DataViewResources.Form.SingleButtonRowFieldLimit && */row != null;
        if (hasButtonsOnTop) this._renderActionButtons(sb, 'Top', 'Form');
        var selectedTab = this._get_selectedTab(); //this._tabs.length > 0 ? this._tabs[this.get_categoryTabIndex()] : null;
        if (this._tabs.length > 0) {
            sb.appendFormat('<tr class="TabsRow"><td colspan="{0}" class="TabsBar{1}">', this._get_colSpan(), !hasButtonsOnTop ? ' WithMargin' : '');
            sb.append('<table cellpadding="0" cellspacing="0" class="Tabs"><tr>');
            for (i = 0; i < this._tabs.length; i++)
                sb.appendFormat('<td id="{2}_Tab{3}" class="Tab{1}" onmouseover="$hoverTab(this,true)" onmouseout="$hoverTab(this,false)"><span class="Outer"><span class="Inner"><span class="Tab"><a href="javascript:" onclick="$find(&quot;{2}&quot;).set_categoryTabIndex({3});return false;" onfocus="$hoverTab(this,true)" onblur="$hoverTab(this,false)" tabindex="{4}">{0}</a></span></span></span></td>', Web.DataView.htmlEncode(this._tabs[i]), i == this.get_categoryTabIndex() ? ' Selected' : '', this.get_id(), i, $nextTabIndex());
            sb.append('</tr></table></td></tr>');
        }
        if (!row) this._renderNoRecordsWhenNeeded(sb);
        else {
            var t = this._get_template();
            if (t) {
                sb.appendFormat('<tr class="CategoryRow"><td valign="top" class="Fields" colspan="{0}">', this._get_colSpan());
                this._renderTemplate(t, sb, row, true, false);
                sb.append('</td></tr>');
            }
            else {
                var categories = this.get_categories();
                var fields = this.get_fields();
                var numCols = this._numberOfColumns;
                if (numCols > 0) {
                    sb.appendFormat('<tr class="Categories"><td class="Categories" colspan="{0}"><table class="Categories"><tr class="CategoryRow">', this._get_colSpan());
                    for (var k = 0; k < numCols; k++) {
                        if (k > 0)
                            sb.append('<td class="CategorySeparator">&nbsp;</td>');
                        sb.appendFormat('<td class="CategoryColumn" valign="top" style="width:{0}%">', 100 / numCols);
                        for (i = 0; i < categories.length; i++) {
                            var c = categories[i];
                            if (c.ColumnIndex == k || this._ignoreColumnIndex) {
                                if (this.get_isModal()) c.Collapsed = false;
                                sb.appendFormat('<div id="{0}_Category{1}" class="Category {3}" style="display:{2}">', this.get_id(), i, !selectedTab || selectedTab == c.Tab ? 'block' : 'none', c.Id);
                                var description = this._processTemplatedText(row, c.Description);
                                var descriptionText = this._formatViewText(Web.DataViewResources.Views.DefaultCategoryDescriptions[description], true, description);
                                sb.appendFormat('<table class="Category {8}" cellpadding="0" cellspacing="0"><tr><td class="HeaderText"><span class="Text">{0}</span><a href="javascript:" class="MinMax{6}" onclick="$find(\'{2}\')._toggleCategoryVisibility({3});return false;" id="{2}$CategoryButton${3}" style="{5}"><span title="{4}"></span></a><div style="clear:both;height:1px;margin-top:-1px;"></div></td></tr><tr><td class="Description" id="{2}$CategoryDescription${3}" style="display:{7}">{1}</td></tr></table>',
                                    c.HeaderText, descriptionText,
                                    this.get_id(), i, c.Collapsed ? Web.DataViewResources.Form.Maximize : Web.DataViewResources.Form.Minimize,
                                    categories.length > 1 && !this.get_isModal() ? '' : 'display:none', c.Collapsed ? ' Maximize' : '', String.isNullOrEmpty(descriptionText) ? 'none' : 'block', c.Id);
                                var skip = true;
                                for (j = 0; j < fields.length; j++) {
                                    var field = fields[j];
                                    if (!field.Hidden && field.CategoryIndex == c.Index) {
                                        skip = false;
                                        break;
                                    }
                                }
                                if (!skip) {
                                    sb.appendFormat('<table class="Fields" id="{0}$Category${1}" style="{2}"><tr class="FieldsRow"><td class="Fields" valign="top" width="100%">', this.get_id(), i, c.Collapsed ? 'display:none' : '');
                                    if (!String.isNullOrEmpty(c.Template))
                                        this._renderTemplate(c.Template, sb, row, true, false);
                                    else {
                                        for (j = 0; j < fields.length; j++) {
                                            field = fields[j];
                                            if (!field.Hidden && field.CategoryIndex == c.Index) {
                                                var m = field.Name.match(/^(_[A-Za-z_]+)\d/);
                                                sb.appendFormat('<table cellpadding="0" cellspacing="0" class="FieldWrapper {0}"><tr class="FieldWrapper"><td class="Header" valign="top">', m ? m[1] : field.Name);
                                                this._renderItem(sb, field, row, true, false, false, true);
                                                sb.appendFormat('</td><td class="Item{0}" valign="top">', isEditing && !field.isReadOnly() ? '' : ' ReadOnly');
                                                this._renderItem(sb, field, row, true);
                                                sb.append('</td></tr></table>');
                                            }
                                        }
                                    }
                                    sb.append('</td></tr></table>');
                                }
                                sb.append('</div>');
                            }
                        }
                        sb.append('</td>');
                    }
                    sb.append('</tr></table></td></tr>');
                }
                else {
                    for (i = 0; i < categories.length; i++) {
                        c = categories[i];
                        description = this._processTemplatedText(row, c.Description);
                        sb.appendFormat('<tr class="CategoryRow {5}" id="{2}_Category{3}" style="display:{4}"><td valign="top" class="Category {5}"><table class="Category {5}" cellpadding="0" cellspacing="0"><tr><td class="HeaderText">{0}</td></tr><tr><td class="Description" id="{2}$CategoryDescription${3}">{1}</td></tr></table></td><td valign="top" class="Fields {5}">',
                            c.HeaderText, this._formatViewText(Web.DataViewResources.Views.DefaultCategoryDescriptions[description], true, description), this.get_id(), i, !selectedTab || selectedTab == c.Tab ? 'block' : 'none', c.Id);
                        if (!String.isNullOrEmpty(c.Template))
                            this._renderTemplate(c.Template, sb, row, true, false);
                        else {
                            for (j = 0; j < fields.length; j++) {
                                field = fields[j];
                                if (!field.Hidden && field.CategoryIndex == c.Index)
                                    this._renderItem(sb, field, row, true);
                            }
                        }
                        sb.append('</td></tr>');
                    }
                }
            }
        }
        if (row) this._renderActionButtons(sb, 'Bottom', 'Form');
    },
    _updateTabbedCategoryVisibility: function () {
        if (this._tabs && this._tabs.length > 0) {
            var tab = this._tabs[this.get_categoryTabIndex()];
            for (var i = 0; i < this._tabs.length; i++) {
                var elem = this._get('_Tab', i); //$get(String.format('{0}_Tab{1}', this.get_id(), i));
                if (elem) {
                    if (i == this.get_categoryTabIndex())
                        $(elem).addClass('Selected');
                    else
                        $(elem).removeClass('Selected');
                }
            }
            for (i = 0; i < this._categories.length; i++) {
                var c = this._categories[i];
                elem = this._get('_Category', i); // $get(String.format('{0}_Category{1}', this.get_id(), i));
                if (elem) Sys.UI.DomElement.setVisible(elem, c.Tab == tab);
            }
            this._updateVisibility();
        }
        this._adjustModalHeight();
    },
    _renderItem: function (sb, field, row, isSelected, isInlineForm, isFirstRow, headerOnly, trimLongWords, templateMode) {
        var dvrd = Web.DataViewResources.Data;
        var isForm = this.get_isForm()/* this.get_view().Type == 'Form'*/ || isInlineForm;
        var v = row[field.Index];
        if (v != null) v = v.toString();
        var checkBox = null;
        var isCheckBoxList = field.ItemsStyle == 'CheckBoxList';
        var isEditing = this.get_isEditing();
        var hasAlias = field.Index != field.AliasIndex;
        if (isEditing && field.ItemsStyle == 'CheckBox' && field.Items.length == 2) {
            var fv = field.Items[0][0];
            var tv = field.Items[1][0];
            if (fv == 'true') {
                fv = 'false';
                tv = 'true';
            }
            if (v == null) v = field.Items[0][0];
            checkBox = String.format('<input type="checkbox" id="{0}_Item{1}"{2} tabindex="{3}" value="{4}" onclick="this.value=this.checked?\'{6}\':\'{5}\';$find(&quot;{0}&quot;)._valueChanged({1});" onfocus="$find(&quot;{0}&quot;)._valueFocused({1});" title="{7}"/>',
                this.get_id(), field.Index, tv && (v == 'true' || v == tv) ? ' checked' : '', $nextTabIndex(), v, fv, tv, field.ToolTip);
        }
        var readOnly = field.isReadOnly(); // field.ReadOnly || field.TextMode == 4;
        if (isForm) {
            var errorHtml = String.format('<div class="Error" id="{0}_Item{1}_Error" style="display:none"></div>', this.get_id(), field.Index);
            if (!headerOnly) sb.appendFormat('<div class="Item {2}" id="{0}_ItemContainer{1}">', this.get_id(), field.Index, field.Name);
            //if (this._numberOfColumns == 0) sb.append(errorHtml);
            var headerText = this._allFields[field.AliasIndex].HeaderText;
            if (checkBox && headerOnly) {
                sb.append('<div class="Header">&nbsp;</div>');
                return;
            }
            if (headerText.length > 0)
                if (templateMode && checkBox && this._numberOfColumns > 0)
                    sb.append('<div class="Header">&nbsp;</div>');
                else
                    sb.appendFormat('<div class="Header {5}">{3}<label for="{0}_Item{1}">{2}{4}</label></div>',
                        this.get_id(), field.Index, headerText,
                        this._numberOfColumns > 0 || templateMode ? '' : checkBox,
                        isEditing && !field.AllowNulls && !checkBox && !readOnly && Web.DataViewResources.Form.RequiredFieldMarker ? Web.DataViewResources.Form.RequiredFieldMarker : '',
                        field.Name);
            if (headerOnly) return;
            if (checkBox == null || this._numberOfColumns > 0)
                sb.append('<div class="Value">');
        }
        var needObjectRef = !isEditing && !String.isNullOrEmpty(field.ItemsDataController) && !isCheckBoxList && !isFirstRow && v && this._disableObjectRef != true && !field.tagged('lookup-details-hidden');
        if (needObjectRef && !isForm) sb.append('<table width="100%" cellpadding="0" cellspacing="0" class="ObjectRef"><tr><td>');
        if (isEditing && isSelected && !readOnly) {
            var batchEditField = field;
            if (field._LEV != null)
                sb.append('<table cellpadding="0" cellspacing="0"><tr><td>');
            if (!isForm && checkBox) sb.append(checkBox);
            var hasItemsStyle = !String.isNullOrEmpty(field.ItemsStyle);
            var isLookup = field.ItemsStyle == 'Lookup';
            var hasContextFields = !String.isNullOrEmpty(field.ContextFields);
            var isAutoComplete = field.ItemsStyle == 'AutoComplete';
            var lov = field.DynamicItems ? field.DynamicItems : field.Items;
            if (hasItemsStyle && !isLookup && !isAutoComplete && (lov.length == 0 && !isCheckBoxList) && hasContextFields) {
                lov = [];
                if (field.AllowNulls || hasContextFields)
                    Array.add(lov, ['', dvrd.NullValueInForms]);
                if (v != null)
                    Array.add(lov, [v, row[field.AliasIndex]]);
            }
            else if (field.DynamicItems && !isCheckBoxList) {
                var hasValue = false;
                for (var i = 0; i < lov.length; i++) {
                    if (lov[i][0] == v) {
                        hasValue = true;
                        break;
                    }
                }
                //if (!hasValue && !String.isNullOrEmpty(v)) Array.insert(lov, 0, [v, row[field.AliasIndex]]);
                if (!hasValue) v = null;
                if ((field.AllowNulls || !hasValue) && !String.isNullOrEmpty(lov[0][0]))
                    Array.insert(lov, 0, ['', dvrd.NullValueInForms]);
            }
            if (checkBox != null) {
                if (this._numberOfColumns > 0 || templateMode) {
                    sb.append(checkBox);
                    sb.appendFormat('<label for="{0}_Item{1}" title="{3}">{2}</label>', this.get_id(), field.Index, headerText, field.ToolTip);
                }
            }
            else
                if (lov.length > 0 || isCheckBoxList || hasItemsStyle && !isLookup && !isAutoComplete) {
                    if (field.ItemsStyle == 'RadioButtonList') {
                        sb.appendFormat('<table cellpadding="0" cellspacing="0" class="RadioButtonList" title="{0}">', field.ToolTip);
                        var columns = field.Columns == 0 ? 1 : field.Columns;
                        var rows = Math.floor(lov.length / columns) + (lov.length % columns > 0 ? 1 : 0);
                        for (var r = 0; r < rows; r++) {
                            sb.append('<tr>');
                            for (var c = 0; c < columns; c++) {
                                var itemIndex = c * rows + r; //r * columns + c;
                                if (itemIndex < lov.length) {
                                    var item = lov[itemIndex];
                                    var itemValue = item[0] == null ? '' : item[0].toString();
                                    if (v == null) v = '';
                                    sb.appendFormat(
                                        '<td class="Button"><input type="radio" id="{0}_Item{1}_{2}" name="{0}_Item{1}" value="{3}"{4} tabindex="{6}" onclick="$find(&quot;{0}&quot;)._valueChanged({1})" onfocus="$find(&quot;{0}&quot;)._valueFocused({1});"/></td><td class="Option"><label for="{0}_Item{1}_{2}">{5}<label></td>',
                                        this.get_id(), field.Index, itemIndex, itemValue, itemValue == v ? " checked" : "", this.htmlEncode(field, item[1]), $nextTabIndex());
                                }
                                else
                                    sb.append('<td class="Button">&nbsp;</td><td class="Option"></td>');
                            }
                            sb.append('</tr>');
                        }
                        sb.append('</table>');
                    }
                    else if (isCheckBoxList) {
                        var lov2 = (v ? v.split(',') : []);
                        var waitingForDynamicItems = !String.isNullOrEmpty(field.ContextFields) && !field.DynamicItems;
                        sb.appendFormat('<input type="hidden" id="{0}_Item{1}" name="{0}_Item{1}" value="{2}"/>', this.get_id(), field.Index, waitingForDynamicItems ? v : '');
                        if (waitingForDynamicItems)
                            sb.append(Web.DataViewResources.HeaderFilter.Loading);
                        else {
                            sb.appendFormat('<table cellpadding="0" cellspacing="0" class="RadioButtonList" title="{0}">', field.ToolTip);
                            columns = field.Columns == 0 ? 1 : field.Columns;
                            rows = Math.floor(lov.length / columns) + (lov.length % columns > 0 ? 1 : 0);
                            for (r = 0; r < rows; r++) {
                                sb.append('<tr>');
                                for (c = 0; c < columns; c++) {
                                    itemIndex = c * rows + r; //r * columns + c;
                                    if (itemIndex < lov.length) {
                                        item = lov[itemIndex];
                                        itemValue = item[0] == null ? '' : item[0].toString();
                                        if (v == null) v = '';
                                        sb.appendFormat(
                                        '<td class="Button"><input type="checkbox" id="{0}_Item{1}_{2}" name="{0}_Item{1}" value="{3}"{4} tabindex="{6}"  onclick="$find(&quot;{0}&quot;)._valueChanged({1})" onfocus="$find(&quot;{0}&quot;)._valueFocused({1});"/></td><td class="Option"><label for="{0}_Item{1}_{2}">{5}<label></td>',
                                        this.get_id(), field.Index, itemIndex, itemValue, Array.indexOf(lov2, itemValue) != -1 ? " checked" : "", this.htmlEncode(field, item[1]), $nextTabIndex());
                                    }
                                    else
                                        sb.append('<td class="Button">&nbsp;</td><td class="Option"></td>');
                                }
                                sb.append('</tr>');
                            }
                            sb.append('</table>');
                        }
                    }
                    else {
                        sb.appendFormat('<select id="{0}_Item{1}" size="{2}" tabindex="{3}" onchange="$find(&quot;{0}&quot;)._valueChanged({1});" onfocus="$find(&quot;{0}&quot;)._valueFocused({1});" title="{4}">', this.get_id(), field.Index, field.ItemsStyle == 'ListBox' ? (field.Rows == 0 ? 5 : field.Rows) : '1', $nextTabIndex(), field.ToolTip);
                        if (v == null) v = '';
                        v = v.toString();
                        for (i = 0; i < lov.length; i++) {
                            item = lov[i];
                            itemValue = item[0];
                            var itemText = itemValue == null && !field.AllowNulls ? Web.DataViewResources.Lookup.SelectLink : item[1];
                            if (itemValue == null) itemValue = '';
                            itemValue = itemValue.toString();
                            sb.appendFormat('<option value="{0}"{1}>{2}</option>', itemValue, itemValue == v ? ' selected' : '', this.htmlEncode(field, itemText));
                        }
                        sb.append('</select>');
                    }
                }
                else if (!String.isNullOrEmpty(field.ItemsDataController) && isLookup) {
                    v = row[field.AliasIndex];
                    if (v == null) v = Web.DataViewResources.Lookup.SelectLink;
                    var s = this._allFields[field.AliasIndex].format(v);
                    this._renderCreateNewBegin(sb, field);
                    sb.appendFormat('<table cellpadding="0" cellspacing="0" class="Lookup"><tr><td><a href="#" onclick="$find(\'{0}\').showLookup({1});return false" id="{0}_Item{1}_ShowLookupLink" title="{3}" tabindex="{5}">{2}</a><a href="#" class="Clear" onclick="$find(\'{0}\').clearLookupValue({1});return false" id="{0}_Item{1}_ClearLookupLink" title="{7}" tabindex="{6}" style="display:{8}">&nbsp;</a></td></tr></table><input type="hidden" id="{0}_Item{1}" value="{4}"/><input type="hidden" id="{0}_Item{9}" value="{2}"/>',
                    this.get_id(), field.Index, this.htmlEncode(field, s), !String.isNullOrEmpty(field.ToolTip) ? field.ToolTip : String.format(Web.DataViewResources.Lookup.SelectToolTip, field.Label), row[field.Index], $nextTabIndex(), $nextTabIndex(), String.format(Web.DataViewResources.Lookup.ClearToolTip, field.Label), row[field.Index] != null ? 'display' : 'none', field.AliasIndex);
                    this._renderCreateNewEnd(sb, field);
                }
                else if (field.OnDemand) this._renderOnDemandItem(sb, field, row, isSelected, isForm);
                else if (field.Editor) {
                    var editor = field.Editor;
                    sb.appendFormat('<input type="hidden" id="{0}_Item{1}" value="{2}"/>', this.get_id(), field.Index, Web.DataView.htmlAttributeEncode(v));
                    sb.appendFormat('<iframe src="{0}?id={1}_Item{2}&control={3}" frameborder="0" scrolling="no" id="{1}_Item{2}$Frame" class="FieldEditor {3}" tabindex="{4}"></iframe>', this.resolveClientUrl(this.get_appRootPath() + 'ControlHost.aspx'), this.get_id(), field.Index, editor, $nextTabIndex());
                }
                else if (field.Rows > 1) {
                    sb.appendFormat('<textarea id="{0}_Item{1}" tabindex="{2}" onchange="$find(&quot;{0}&quot;)._valueChanged({1})" onfocus="$find(&quot;{0}&quot;)._valueFocused({1});" title="{3}" style="', this.get_id(), field.Index, $nextTabIndex(), field.ToolTip);
                    if (field.TextMode == 3 && !String.isNullOrEmpty(v))
                        sb.append('display:none;');
                    if (!isForm)
                        sb.append('display:block;width:100%;"');
                    else
                        sb.appendFormat('" cols="{0}"', field.Columns > 0 ? field.Columns : 50);
                    sb.appendFormat(' rows="{0}"', field.Rows);
                    if ($appfactory.supportsPlaceholder && !String.isNullOrEmpty(field.Watermark))
                        sb.appendFormat(' placeholder="{0}"', Web.DataView.htmlAttributeEncode(field.Watermark));
                    sb.append('>');
                    sb.append(field.HtmlEncode ? this.htmlEncode(field, v) : v);
                    sb.append('</textarea>');
                    if (field.TextMode == 3 && !String.isNullOrEmpty(v))
                        sb.appendFormat('<div>{2}<div><a href="javascript:" onclick="var o=$get(\'{0}_Item{1}\');o.style.display=\'block\';o.focus();this.parentNode.parentNode.style.display=\'none\';return false;">{3}</a> | <a href="javascript:" onclick="if(!confirm(\'{5}\'))return;$get(\'{0}_Item{1}\').value=\'\';this.parentNode.parentNode.parentNode.parentNode.style.display=\'none\';return false;">{4}</a></div></div>', this.get_id(), field.Index, this.htmlEncode(field, v).replace(/(\r\n*)/g, '<br/>'), dvrd.NoteEditLabel, dvrd.NoteDeleteLabel, dvrd.NoteDeleteConfirm);
                }
                else {
                    columns = field.Columns > 0 ? field.Columns : 50;
                    var autoCompleteTooltip = field.ToolTip;
                    if (isAutoComplete && (!hasAlias || isEditing)) {
                        v = row[field.Index];
                        sb.appendFormat('<input type="hidden" id="{0}_Item{1}" value="{2}"/>', this.get_id(), field.Index, Web.DataView.htmlAttributeEncode(v));
                        field = this._allFields[field.AliasIndex];
                    }
                    if (field.TimeFmtStr)
                        sb.append('<table cellpadding="0" cellspacing="0" class="DateTime"><tr><td class="Date">');
                    sb.appendFormat('<input type="{3}" id="{0}_Item{1}" tabindex="{2}" onchange="$find(&quot;{0}&quot;)._valueChanged({1})" onfocus="$find(&quot;{0}&quot;)._valueFocused({1});"', this.get_id(), field.Index, $nextTabIndex(), field.TextMode != 1 ? 'text' : 'password');
                    if (!isForm)
                        sb.append(' style="display:block;width:90%;"');
                    else
                        sb.appendFormat(' size="{0}"', columns);
                    if (field.Len > 0)
                        sb.appendFormat(' maxlength="{0}"', field.Len);
                    if (isAutoComplete)
                        sb.appendFormat(' title="{0}"', autoCompleteTooltip);
                    v = row[field.Index];
                    if (v == null)
                        s = isAutoComplete ? dvrd.NullValueInForms : '';
                    else if (hasAlias)
                        s = v.toString();
                    else {
                        if (field.DateFmtStr) {
                            if (typeof (v) == 'string')
                                v = Date.parseLocale(v, field.DataFormatString.match(/\{0:([\s\S]*?)\}/)[1]);
                            field.DataFormatString = field.DateFmtStr;
                        }
                        s = field.format(v);
                        if (field.DateFmtStr)
                            field.DataFormatString = field.DataFmtStr;
                    }
                    sb.appendFormat(' value="{0}" {1}', Web.DataView.htmlAttributeEncode(s), isForm ? ' class="TextInput"' : String.format('class="TextInput {0}Type"', field.Type));
                    sb.appendFormat(' title="{0}"', field.ToolTip);
                    if ($appfactory.supportsPlaceholder && !String.isNullOrEmpty(field.Watermark))
                        sb.appendFormat(' placeholder="{0}"', Web.DataView.htmlAttributeEncode(field.Watermark));
                    sb.append('/>');
                    if (field.Type.startsWith('DateTime') && isForm && Web.DataViewResources.Form.ShowCalendarButton && !field.TimeFmtStr)
                        sb.appendFormat('<a id="{0}_Item{1}_Button" href="#" onclick="return false" class="Calendar">&nbsp;</a>', this.get_id(), field.Index);
                    if (field.TimeFmtStr) {
                        sb.appendFormat('</td><td class="Time"><input type="text" id="{0}_Item$Time{1}" tabindex="{2}" onchange="$find(&quot;{0}&quot;)._valueChanged({1})" onfocus="$find(&quot;{0}&quot;)._valueFocused({1});"', this.get_id(), field.Index, $nextTabIndex());
                        if (!isForm)
                            sb.append(' style="display:block;width:90%;"');
                        else
                            sb.appendFormat(' size="{0}"', columns);
                        if (v == null)
                            s = isAutoComplete ? dvrd.NullValueInForms : '';
                        else if (hasAlias)
                            s = v.toString();
                        else {
                            field.DataFormatString = field.TimeFmtStr;
                            s = field.format(v);
                            field.DataFormatString = field.DataFmtStr;
                        }
                        sb.appendFormat(' value="{0}" {1}/></td></table>', Web.DataView.htmlAttributeEncode(s), isForm ? '' : 'class="TimeType"');
                    }
                }
            if (field._LEV != null) {
                var lev = this._allFields[field.AliasIndex]._LEV;
                if (lev == null) lev = '';
                sb.appendFormat('</td><td class="UseLEV"><a href="javascript:" onclick="$find(\'{0}\')._applyLEV({1});return false" tabindex="{2}" title="{3}">&nbsp;</a></td></tr></table>', this.get_id(), field.Index, $nextTabIndex(), Web.DataView.htmlAttributeEncode(String.format(dvrd.UseLEV, this._allFields[field.AliasIndex].format(lev))));
            }
            if (this._lastCommandName == 'BatchEdit')
                sb.appendFormat('<div class="BatchSelect"><table cellpadding="0" cellspacing="0"><tr><td><input type="checkbox" id="{0}$BatchSelect{1}" onclick="Web.DataView._updateBatchSelectStatus(this,{3})"{4}/></td><td><label for="{0}$BatchSelect{1}">{2}</a></td></tr></table></div>',
                    this.get_id(), batchEditField.Index, dvrd.BatchUpdate, isForm == true, this._batchEdit && Array.contains(this._batchEdit, batchEditField.Name) ? ' checked="checked"' : '');
        }
        else {
            if (field.OnDemand) this._renderOnDemandItem(sb, field, row, isSelected, isForm);
            else {
                v = this.htmlEncode(field, row[field.AliasIndex]);
                if (isEditing)
                    if (readOnly && isSelected) {
                        var hv = row[field.Index]; //row[field.ReadOnly ? field.AliasIndex : field.Index];
                        sb.appendFormat('<input type="hidden" id="{0}_Item{1}" value="{2}"/>', this.get_id(), field.Index, hv != null ? Web.DataView.htmlAttributeEncode(this._allFields[field.AliasIndex].format(hv)) : '');
                    }
                var fieldItems = field.DynamicItems ? field.DynamicItems : field.Items;
                if (fieldItems.length == 0) {
                    if (field.Type == 'String' && v != null && v.length > dvrd.MaxReadOnlyStringLen && !(field.TextMode == 3 || field.TextMode == 2))
                        v = v.substring(0, dvrd.MaxReadOnlyStringLen) + '...';
                    if (v && field.TextMode == 3)
                        v = v.replace(/(\r\n*)/g, '<br/>');
                    s = String.isBlank(v) ? (isForm ? dvrd.NullValueInForms : dvrd.NullValue) : (this._allFields[field.AliasIndex].format(v));
                }
                else if (isCheckBoxList) {
                    lov = v ? v.split(',') : [];
                    var fi = true;
                    for (i = 0; i < fieldItems.length; i++) {
                        item = fieldItems[i];
                        itemValue = item[0] == null ? '' : item[0].toString();
                        if (Array.contains(lov, itemValue)) {
                            if (fi) fi = false; else sb.append(', ');
                            sb.append(Web.DataView.htmlEncode(item[1]));
                        }
                    }
                    s = lov.length == 0 ? dvrd.NullValueInForms : '';
                }
                else if (hasAlias && !isSelected)
                    s = v;
                else {
                    item = this._findItemByValue(field, !hasAlias ? v : row[field.Index]);
                    s = item[1];
                    if (!isForm && s == dvrd.NullValueInForms)
                        s = dvrd.NullValue;
                }
                if (!String.isNullOrEmpty(field.HyperlinkFormatString) && v != null) {
                    var location = this._parseLocation(field.HyperlinkFormatString, row);
                    //var m = location.match(Web.DataView.LocationRegex);
                    //s = m ? String.format('<a href="javascript:" onclick="Web.DataView._navigated=true;window.open(\'{0}\', \'{1}\');return false;">{2}</a>', m[2].replace(/\'/g, '\\\'').replace(/"/g, '&quot;'), m[1], s) : String.format('<a href="{0}" onclick="Web.DataView._navigated=true;">{1}</a>', location, s);
                    if (location && location.match(/^mailto\:/))
                        s = String.format('<a href="{0}" title="{2}">{1}</a>', location, s, field.ToolTip);
                    else if (location.match(/^javascript\:/))
                        s = String.format('<a href="javascript:" onclick="{0};return false;" title="{2}">{1}</a>', location.substring(11), s, field.ToolTip);
                    else
                        s = String.format('<a href="javascript:" onclick="$find(\'{2}\')._navigate(\'{0}\');" title="{3}">{1}</a>', location, s, this.get_id(), field.ToolTip);
                }
                if (field.TextMode == 1) s = '**********';
                if (trimLongWords == true)
                    s = String.trimLongWords(s);
                if (__designer() && s)
                    s = s.replace(/\^\w+\^/g, '');
                sb.append(s);
            }
        }
        if (needObjectRef) {
            if (!isForm) sb.append('</td><td align="right">');
            sb.appendFormat('<span class="ObjectRef" title="{0}" onclick="$find(&quot;{1}&quot;).executeCommand({{commandName: &quot;_ViewDetails&quot;, commandArgument: &quot;{2}&quot;}})">&nbsp;</span>',
                String.format(Web.DataViewResources.Lookup.DetailsToolTip, Web.DataView.htmlAttributeEncode(this._allFields[field.AliasIndex].HeaderText)), this.get_id(), field.Name);
            if (!isForm) sb.append('</td></tr></table>');
        }
        if (isForm) {
            if (checkBox == null || this._numberOfColumns > 0)
                sb.append('</div>');
            //if (this._numberOfColumns > 0) sb.append(errorHtml);
            sb.append(errorHtml);
            if (!String.isNullOrEmpty(field.FooterText))
                sb.appendFormat('<div class="Footer">{0}</div>', field.FooterText);
            sb.append('</div>');
        }
    },
    _renderOnDemandItem: function (sb, field, row, isSelected, isForm) {
        var dvrd = Web.DataViewResources.Data;
        var v = row[field.Index];
        var m = v != null ? v.toString().match(/^null\|(.+)$/) : null;
        var isNull = m != null || v == null;
        if (m) v = m[1];
        if (isNull && !isSelected && field.OnDemandStyle == 1)
            sb.append(isForm ? dvrd.NullValueInForms : dvrd.NullValue);
        else {
            var blobHref = this.resolveClientUrl(this.get_appRootPath() + dvrd.BlobHandler);
            if (isSelected && !isNull) sb.appendFormat('<a href="{0}?{1}=o|{2}" title="{3}" onclick="$find(&quot;{4}&quot;)._showDownloadProgress();open(this.href, &quot;_blank&quot;,&quot;height={5},width={6},resizable=yes&quot;);return false">', blobHref, field.OnDemandHandler, v, dvrd.BlobDownloadHint, this.get_id(), $(window).height() / 2, $(window).width() / 2);
            if (field.OnDemandStyle == 1) {
                if (isNull)
                    sb.append(isForm ? dvrd.NullValueInForms : dvrd.NullValue);
                else
                    sb.append(isSelected ? dvrd.BlobDownloadLink : dvrd.BlobDownloadLinkReadOnly);
            }
            else {
                if (!isNull)
                    sb.appendFormat('<img src="{0}?{1}=t|{2}" class="Thumbnail"/>', blobHref, field.OnDemandHandler, v);
                else
                    sb.append(isForm ? dvrd.NullValueInForms : dvrd.NullValue);
            }
            if (isSelected && !isNull) sb.append('</a>');
            if (!field.ReadOnly && (this.get_isEditing() && isSelected))
                sb.appendFormat('<iframe src="{0}?{1}=u|{2}&owner={3}&index={4}" frameborder="0" scrolling="no" id="{3}_Frame{4}" tabindex="{6}"></iframe><div style="display:none" id="{3}_ProgressBar{4}" class="UploadProgressBar">{5}</div>', blobHref, field.OnDemandHandler, v, this.get_id(), field.Index, 'Uploading...', $nextTabIndex());
        }
    },
    _showUploadProgress: function (index, blobForm) {
        var f = $get(String.format('{0}_Frame{1}', this.get_id(), index));
        var p = $get(String.format('{0}_ProgressBar{1}', this.get_id(), index));
        if (f != null && p != null) {
            var inputFile = $(blobForm).find('input:file');
            var fileName = inputFile.val().split(/(\\|\/)/);
            fileName = fileName.length > 0 ? fileName[fileName.length - 1] : null;
            var inserting = this.get_isInserting();
            var $p = $(p).show().text(fileName).focus();
            var padding = $common.getPaddingBox(p);
            var border = $common.getBorderBox(p);
            p.style.width = (f.offsetWidth - padding.horizontal - border.horizontal) + 'px';
            p.style.height = (f.offsetHeight - padding.vertical - border.vertical) + 'px';
            //Sys.UI.DomElement.setVisible(f, false);
            var $f = $(f).hide();
            if (!inserting) {
                this._showDownloadProgress();
                blobForm.submit();
            }
            else {
                var pendingUploads = this._pendingUploads;
                if (!pendingUploads)
                    pendingUploads = this._pendingUploads = [];
                pendingUploads.push({ form: blobForm, progress: p });
                $p.find('a').button('destroy');
                $p.addClass('dataview-insert').append(
                $(String.format('<a>{0}</a>', Web.DataViewResources.Data.Filters.Labels.Clear)).button({ icons: { primary: "ui-icon-close" }, text: false }).click(function () {
                    $p.hide();
                    $f.show();
                    for (var i = 0; i < pendingUploads.length; i++)
                        if (pendingUploads[i].form == blobForm) {
                            Array.removeAt(pendingUploads, i);
                            break;
                        }
                    inputFile.replaceWith(inputFile.clone(true));
                })
                );
            }
        }
    },
    _internalRenderActionButtons: function (sb, location, scope, actions) {
        if (!actions)
            actions = this._actionButtonsInScope(scope);
        this._clonedRow = this._cloneChangedRow();

        for (var i = 0; i < actions.length; i++) {
            action = actions[i];
            if (this._isActionAvailable(action)) {
                var className = !String.isNullOrEmpty(action.CssClass) ? action.CssClass : '';
                if (action.HeaderText && action.HeaderText.length > 10) {
                    if (className.length > 0) className += ' ';
                    className += 'AutoWidth';
                }
                var disabled = action.CommandName == 'None';
                sb.appendFormat('<button onclick="{6}$find(\'{0}\').executeAction(\'{5}\', {1},-1);return false" tabindex="{3}" class="{8}{4}"{7}>{2}</button>',
                    this.get_id(), i, action.HeaderText, $nextTabIndex(),
                    className,
                    scope, disabled ? 'return false;' : '', disabled ? ' disabled="disabled"' : '',
                    action.CssClassEx);
            }
            if (action._whenClientScript != null)
                this._dynamicActionButtons = true;
        }

        this._clonedRow = null;
    },
    _actionButtonsInScope: function (scope) {
        var actions = this.get_actions(scope);
        if (actions.length == 0) return;
        if (scope == 'Row') {
            var show = false;
            for (var i = 0; i < actions.length; i++) {
                if (this._isActionAvailable(actions[i])) {
                    show = true;
                    break;
                }
            }
            if (!show) return null;
        }
        return actions;
    },
    _renderActionButtons: function (sb, location, scope) {
        if (this.get_showActionButtons().indexOf(location) == -1) return;
        var actions = this._actionButtonsInScope(scope);
        if (!actions) return;
        var colSpan = this._get_colSpan();
        var actionColumnTd = '';
        if (scope == 'Row' && this._actionColumn) {
            colSpan--;
            actionColumnTd = '<td class="ActionColumn">&nbsp;</td>';
        }
        sb.appendFormat('<tr class="ActionButtonsRow {0}ButtonsRow {2}Scope">{3}<td colspan="{1}" class="ActionButtons {2}ActionButtons">', location, colSpan, scope, actionColumnTd);

        sb.append('<table style="width:100%" cellpadding="0" cellspacing="0" class="ActionButtons"><tr>');

        var actionButtonsId = String.format(' id="{0}$ActionButtons${1}"', this.get_id(), location);

        if (scope == 'Form') {
            var p = this._position;
            var allowNav = p && p.count > 1 && !this.get_isInserting();
            var allowPrevious = p && p.index > 0;
            var allowNext = p && p.index < p.count - 1;
            var printAction = this._get_specialAction('Print');
            var annotateAction = this.get_isModal() ? this._get_specialAction('Annotate') : null;
            sb.appendFormat('<td class="Left"><table class="FormNav"><tr><td class="Previous{5}{7}"><a href="javascript:" onclick="$find(\'{2}\')._advance(-1);return false;" title="{3}"><span></span></a></td><td class="Next{6}{7}"><a href="javascript:" onclick="$find(\'{2}\')._advance(1);return false;" title="{4}"><span></span></a></td><td class="Print{9}"><a href="javascript:" onclick="{10};return false;" title="{8}"><span></span></a></td><td class="Annotate{12}"><a href="javascript:" onclick="{13};return false;" title="{11}"><span></span></a></td><td class="Instruction" id="{0}_Wait" align="left">{1}</td></tr></table></td><td class="Right" align="right"{14}>&nbsp;',
                location == 'Bottom' ? this.get_id() : '',
                this.get_isEditing() && Web.DataViewResources.Form.RequiredFieldMarker ? Web.DataViewResources.Form.RequiredFiledMarkerFootnote : '',
                this.get_id(), Web.DataViewResources.Pager.Previous, Web.DataViewResources.Pager.Next,
                allowPrevious ? '' : ' Disabled', allowNext ? '' : ' Disabled', allowNav ? '' : ' Hidden',
                printAction ? printAction.text : '', printAction ? '' : ' Hidden', printAction ? printAction.script : null,
                annotateAction ? annotateAction.text : '', annotateAction ? '' : ' Hidden', annotateAction ? annotateAction.script : null,
                actionButtonsId);
        }
        else
            sb.appendFormat('<td{0}>', actionButtonsId);

        this._internalRenderActionButtons(sb, location, scope, actions);
        this._lastActionButtonsScope = scope;

        sb.append('</td></tr></table>');

        sb.append('</td></tr>');
    },
    _isActionMatched: function (action) {
        if (!action._csInitialized) {
            if (!String.isNullOrEmpty(action.WhenClientScript))
                action._whenClientScript = this._prepareJavaScriptExpressionEx(action.WhenClientScript);
            action._csInitialized = true;
        }
        var result =
            (action.WhenViewRegex == null || (action.WhenViewRegex.exec(this.get_viewId()) != null) == action.WhenViewRegexResult) &&
            (action.WhenTagRegex == null || (action.WhenTagRegex.exec(this.get_tag()) != null) == action.WhenTagRegexResult) &&
            (action.WhenHRefRegex == null || (action.WhenHRefRegex.exec(location.pathname) != null) == action.WhenHRefRegexResult) &&
            (action._whenClientScript == null || eval(action._whenClientScript) == true);
        return result;
    },
    _isActionAvailable: function (action, rowIndex) {
        var lastCommand = action.WhenLastCommandName ? action.WhenLastCommandName : '';
        if (lastCommand == 'Any')
            lastCommand = this.get_lastCommandName();
        var lastArgument = action.WhenLastCommandArgument ? action.WhenLastCommandArgument : '';
        var available = lastCommand.length == 0 || (lastCommand == this.get_lastCommandName() && (lastArgument.length == 0 || lastArgument == this.get_lastCommandArgument()));
        if (available) {
            var editing = this.get_isEditing();
            if (action.CommandName == 'DataSheet')
                return !editing && this.get_isGrid() && /*!this.get_isTree() &&*/this.get_viewType() != 'DataSheet' && this._isActionMatched(action);
            else if (action.CommandName == 'Grid')
                return !editing && this.get_isGrid() && /*!this.get_isTree() &&*/this.get_viewType() != 'Grid' && this._isActionMatched(action);
            else if (editing) {
                var isSelected = this._rowIsSelected(rowIndex == null ? this._selectedRowIndex : rowIndex);
                if (isSelected)
                    return (lastCommand == 'New' || lastCommand == 'Edit' || lastCommand == 'BatchEdit' || lastCommand == 'Duplicate') && this._isActionMatched(action);
                else if (!isSelected && rowIndex == null && (lastCommand == 'New' || lastCommand == 'Duplicate'))
                    return this._isActionMatched(action);
                else
                    return lastCommand.length == 0 && rowIndex != null && this._isActionMatched(action);
            }
        }
        return available && (!action.WhenKeySelected || action.WhenKeySelected && this._selectedKey && this._selectedKey.length > 0) && this._isActionMatched(action) && (action.CommandName != 'New' || this._hasKey());
    },
    _hasKey: function () { return this._keyFields && this._keyFields.length > 0; },
    _rowIsSelected: function (rowIndex) {
        if (!this._hasKey()) return this.get_isModal() && this.get_isForm()/* this.get_view().Type == 'Form'*/;
        var row = this._rows[rowIndex];
        return this.rowIsSelected(row);
    },
    rowIsSelected: function (row) {
        var keyFields = this._keyFields,
            selectedKey = this._selectedKey;
        if (row && keyFields.length == selectedKey.length && keyFields.length) {
            if (row == this._mergedRow) return true;
            for (var j = 0; j < keyFields.length; j++) {
                var field = keyFields[j],
                    v1 = selectedKey[j],
                    v2 = row[field.Index];
                if (field.Type.startsWith('DateTime')) {
                    if (!(v1 || v2)) return false;
                    v1 = v1.toString();
                    v2 = v2.toString();
                }
                if (v1 != v2 && !(v2 == null && String.isNullOrEmpty(v1))) return false;
            }
            return true;
        }
        else
            return false;
    },
    _get_template: function (type) {
        if (this.get_isDataSheet()) return null;
        return $get(this.get_controller() + '_' + this.get_viewId() + (type ? '_' + type : ''));
    },
    _renderTemplate: function (template, sb, row, isSelected, isInlineForm) {
        var s = typeof template == 'string' ? template : template.innerHTML;
        var iterator = /([\s\S]*?)\{([\w\d]+)(\:([\S\s]+?)){0,1}\}/g;
        var lastIndex = 0;
        var match = iterator.exec(s);
        while (match) {
            lastIndex = match.index + match[0].length;
            sb.append(match[1]);
            var field = this.findField(match[2]);
            if (field) {
                if (match[4] && match[4].length > 0)
                    sb.appendFormat('{0:' + match[4] + '}', row[field.Index]);
                else
                    this._renderItem(sb, field, row, isSelected, isInlineForm, null, null, null, true);
            }
            else {
                var dataView = Web.DataView.find(match[2]);
                if (dataView) {
                    if (!this._embeddedViews)
                        this._embeddedViews = [];
                    Array.add(this._embeddedViews, { 'view': dataView });
                    sb.appendFormat('<div id="v_{0}" class="EmbeddedViewPlaceholder"></div>', dataView.get_cookie().replace(/-/g, ''));
                }
            }

            match = iterator.exec(s);
        }
        if (lastIndex < s.length) sb.append(s.substring(lastIndex));
    },
    _renderNewRow: function (sb) {
        if (this.get_isInserting()) {
            var isDataSheet = this.get_isDataSheet();
            var hasActionColumn = this._actionColumn && !isDataSheet;
            var cell = this._get_focusedCell();
            if (!cell) cell = { colIndex: 0 };

            var t = isDataSheet ? null : this._gridTemplates.New; //this._get_template('new');
            sb.appendFormat('<tr class="Row Selected{0}{1}">', t ? ' InlineFormRow' : '', isDataSheet ? ' Inserting' : '');

            var multipleSelection = this.multiSelect();
            if (multipleSelection) sb.append('<td class="Cell Toggle First">&nbsp;</td>');
            var showIcons = this.get_showIcons();
            if (showIcons) sb.appendFormat('<td class="Cell Icons{0}"><span>&nbsp;</span></td>', !multipleSelection ? ' First' : '');
            if (this.get_isDataSheet()) sb.appendFormat('<td class="Cell Gap"><div class="Icon"></div></td>', !multipleSelection && !showIcons ? ' First' : '');
            if (hasActionColumn)
                sb.append('<td class="Cell ActionColumn">&nbsp;</td>');
            var row = this._newRow ? this._newRow : [];
            this._mergeRowUpdates(row);
            this._updateVisibility(row);
            if (t) {
                sb.appendFormat('<td class="Cell" colspan="{0}">', this.get_fields().length);
                this._renderTemplate(t, sb, row, true, true);
                sb.append('</td>');
            }
            else {
                for (var i = 0; i < this._fields.length; i++) {
                    var field = this._fields[i];
                    var af = this._allFields[field.AliasIndex];
                    var cellEvents = '';

                    if (isDataSheet) {
                        this._editing = cell && cell.colIndex == field.ColIndex;
                        if (!this._editing)
                            cellEvents = String.format(' onclick="$find(\'{0}\')._dataSheetCellFocus(event,-1,{1})"', this.get_id(), i);
                    }
                    sb.appendFormat('<td class="Cell {0} {1}Type{2}{3}"{4}>', af.Name, af.Type, i == 0 ? ' FirstColumn' : '', i == this._fields.length - 1 ? ' LastColumn' : '', cellEvents)
                    if (!field.ReadOnly) sb.appendFormat('<div class="Error" id="{0}_Item{1}_Error" style="display:none"></div>', this.get_id(), field.Index);

                    this._renderItem(sb, field, row, !field.OnDemand, null);
                    this._editing = null;
                    sb.append('</td>');
                }
            }
            sb.append('</tr>');
            if (!isDataSheet)
                this._renderActionButtons(sb, 'Bottom', 'Row')
        }
    },
    _iconClicked: function (rowIndex) {
        if (!this.get_isDataSheet() && this.get_lookupField() == null)
            if (this._icons && this._icons[rowIndex] == 'Attachment') {
                this._lastClickedIcon = 'Attachment';
                this.set_autoSelectFirstRow(true);
                this._autoSelect(rowIndex);
            }
    },
    _renderRows: function (sb, hasKey, multipleSelection) {
        var isInLookupMode = this.get_lookupField() != null;
        var isDataSheet = this.get_isDataSheet();
        var hasActionColumn = !isInLookupMode && this._actionColumn && !isDataSheet;
        var actionColumnGroup = hasActionColumn ? this.get_actionGroups('ActionColumn', true) : null;
        var expressions = this._enumerateExpressions(Web.DynamicExpressionType.Any, Web.DynamicExpressionScope.ViewRowStyle, this.get_viewId());
        sb.append('<tr class="HeaderRow">');
        var showIcons = this.get_showIcons();
        if (multipleSelection) {
            sb.appendFormat('<th class="Toggle First"><input type="checkbox" onclick="$find(&quot;{0}&quot;).toggleSelectedRow()" id="{0}_ToggleButton"/></th>', this.get_id());
            this._multipleSelection = false;
        }
        if (showIcons) sb.appendFormat('<th class="Icons{0}">&nbsp;</th>', !multipleSelection ? ' First' : '');
        if (isDataSheet) sb.appendFormat('<th class="Gap{0}">&nbsp;</th>', !multipleSelection && !showIcons ? ' First' : '');
        if (hasActionColumn) sb.appendFormat('<th class="FieldHeaderSelector ActionColumn"><span>{0}</span></th>', this._actionColumn);
        var sortExpression = this.get_sortExpression(),
            sortExprInfo = sortExpression ? sortExpression.match(/^\s*(\w+)((\s+(asc|desc))|(\s*(,|$)))/i) : null;
        for (var i = 0; i < this._fields.length; i++) {
            var field = this._fields[i],
                originalFieldName = field.Name;
            field = this._allFields[field.AliasIndex];
            if (field.Name == originalFieldName)
                originalFieldName = '';
            sb.appendFormat('<th class="FieldHeaderSelector {4} {0} {1}Type{2}{3}"', field.Name, field.Items.length > 0 ? 'String' : field.Type, i == 0 ? ' FirstColumn' : '', i == this._fields.length - 1 ? ' LastColumn' : '', originalFieldName);
            if (field.AllowSorting || field.AllowQBE)
                sb.appendFormat(' onmouseover="$showHover(this,\'{0}$FieldHeaderSelector${1}\',\'FieldHeaderSelector\')" onmouseout="$hideHover(this)" onclick="$toggleHover()"', this.get_id(), i);
            sb.append('>');
            if (field.AllowSorting) {
                sb.appendFormat('<a href="#" onclick="$find(\'{0}\').sort(\'{1}\');$preventToggleHover();return false" title="{3}" onfocus="$showHover(this,\'{0}$FieldHeaderSelector${4}\',\'FieldHeaderSelector\',1)" onblur="$hideHover(this)" tabindex="{5}">{2}</a>',
                    this.get_id(), field.Name, field.HeaderText, String.format(Web.DataViewResources.HeaderFilter.SortBy, field.HeaderText), i, $nextTabIndex());
                if (sortExprInfo && sortExprInfo[1] == field.Name)
                    sb.append(String.format('<span class="{0}">&nbsp;</span>', sortExprInfo[4] ? (sortExprInfo[4].toLowerCase() == 'asc' ? 'SortUp' : 'SortDown') : 'SortUp'));
                if (this.filterOf(field) != null)
                    sb.append('<span class="Filter">&nbsp;</span>');
            }
            else
                sb.appendFormat('<span>{0}</span>', field.HeaderText);
            sb.append('</th>');
        }
        sb.append('</tr>');
        var cell = this._get_focusedCell();
        var isEditing = this.get_isEditing();
        var isInserting = this.get_isInserting();
        var newRowIndex = this._lastSelectedRowIndex;
        if (!this._gridTemplates) {
            var gt = { 'Default': this._get_template(), 'Edit': this._get_template('edit'), 'New': this._get_template('new') };
            if (gt.Default)
                gt.Default = gt.Default.innerHTML;
            gt.Edit = gt.Edit ? gt.Edit.innerHTML : gt.Default;
            gt.New = gt.New ? gt.New.innerHTML : gt.Default;
            this._gridTemplates = gt;
        }
        var t = isDataSheet ? null : this._gridTemplates.Edit; //isEditing ? this._get_template('edit') : null;
        var ts = isDataSheet ? null : this._gridTemplates.Default;
        var family = null;
        this._registerRowSelectorItems();
        var mouseOverEvents = 'onmouseover="$(this).addClass(\'Highlight\');" onmouseout="$(this).removeClass(\'Highlight\')"';
        var showRowNumber = this.get_showRowNumber();
        var hasSelectedRow = false;
        for (i = 0; i < this.get_rows().length; i++) {
            var row = this.get_rows()[i];
            var customCssClasses = ' ' + this._evaluateJavaScriptExpressions(expressions, row, true);
            var isSelectedRow = this._rowIsSelected(i);
            if (isSelectedRow)
                hasSelectedRow = true;
            if (isSelectedRow) this._selectedRowIndex = i;
            var checkBoxCell = null;
            var multiSelectedRowClass = '';
            if (multipleSelection) {
                var selected = Array.indexOf(this._selectedKeyList, this._createRowKey(i)) != -1;
                if (selected) this._multipleSelection = true;
                checkBoxCell = String.format('<td class="Cell Toggle First"><input type="checkbox" id="{0}_CheckBox{1}" onclick="$find(&quot;{0}&quot;).toggleSelectedRow({1})"{2} class="MultiSelect{3}"/></td>', this.get_id(), i, selected ? ' checked="checked"' : null, selected ? ' Selected' : '');
                if (selected) multiSelectedRowClass = ' MultiSelectedRow';
            }
            var iconCell = showIcons ? String.format('<td class="Cell Icons {0}{1}"><span onclick="$find(\'{3}\')._iconClicked({4});">{2}</span></td>', this._icons ? this._icons[i] : '', !multipleSelection ? ' First' : '', showRowNumber ? this.get_pageSize() * this.get_pageIndex() + i + 1 + (this._pageOffset ? this._pageOffset : 0) : '&nbsp;', this.get_id(), i) : '';
            if (isDataSheet)
                iconCell += String.format('<td class="Cell Gap{2}" onclick="$find(\'{0}\')._dataSheetCellFocus(event,{1},-1)"><div class="Icon"></div></td>', this.get_id(), i, !multipleSelection && !showIcons ? ' First' : '');
            if (hasActionColumn)
                iconCell += this._renderActionColumnCell(row, i, isSelectedRow, actionColumnGroup)
            if (isEditing && isSelectedRow) {
                this._mergeRowUpdates(row);
                this._updateVisibility(row);
            }
            if (isSelectedRow && (isEditing && t || ts)) {
                sb.appendFormat('<tr id="{0}_Row{1}" class="{2}Row{3} Selected{7}">{5}{6}<td class="Cell" colspan="{4}">', this.get_id(), i, i % 2 == 0 ? '' : 'Alternating', ' InlineFormRow', this.get_fields().length, checkBoxCell, iconCell, isEditing ? ' Editing' : '');
                this._renderTemplate(isEditing && t ? t : ts, sb, row, true, true);
                sb.append('</td>');
            }
            else {
                sb.appendFormat('<tr id="{0}_Row{1}" class="{2}Row{3}{4}{7}" {6}>', this.get_id(), i, i % 2 == 0 ? '' : 'Alternating', isSelectedRow ? ' Selected' + customCssClasses : customCssClasses, multiSelectedRowClass, hasKey ? '' : ' ReadOnlyRow', isDataSheet && !isInLookupMode ? '' : mouseOverEvents, isSelectedRow && isEditing ? ' Editing' : ''/*,
                    !isEditing && isDataSheet ? String.format(' onmousewheel="$find(\'{0}\')._scrollToRow(event.wheelDelta);return false;"', this.get_id()) : ''*/);
                if (checkBoxCell) sb.append(checkBoxCell);
                sb.append(iconCell);
                for (j = 0; j < this._fields.length; j++) {
                    field = this._fields[j];
                    var af = this._allFields[field.AliasIndex];
                    originalFieldName = field.Name == af.Name ? '' : field.Name;
                    if (cell)
                        this._editing = isEditing && cell.rowIndex == i && cell.colIndex == field.ColIndex;
                    var allowRowSelector = j == 0 && hasKey;
                    if (allowRowSelector) {
                        family = Web.HoverMonitor.Families[String.format('{0}$RowSelector${1}', this.get_id(), i)];
                        if (!family || family.items.length == 0)
                            allowRowSelector = false;
                    }
                    var firstColumnClass = j == 0 ? ' FirstColumn' : '';
                    var cellClickEvent = String.format(' onclick="$find(\'{0}\')._{3}CellFocus(event,{1},{2})"', this.get_id(), i, j, isDataSheet && !isInLookupMode ? 'dataSheet' : 'gridView');
                    //if (isDataSheet)
                    //    cellClickEvent += String.format(' onclick="$find(\'{0}\')._dataSheetCellEdit(event,{1},{2})"', this.get_id(), i, j, isDataSheet ? 'dataSheet' : 'gridView');
                    var lastColumnClass = j == this._fields.length - 1 ? ' LastColumn' : '';
                    if (allowRowSelector && !isInLookupMode || isSelectedRow && isEditing || field.OnDemand && isSelectedRow)
                        sb.appendFormat('<td class="Cell {5} {0} {1}Type{2}{4}"{3}>', af.Name, field.Items.length > 0 ? 'String' : af.Type, firstColumnClass, isSelectedRow && isEditing && (!isDataSheet || cell && cell.colIndex == field.ColIndex) ? '' : cellClickEvent, lastColumnClass, originalFieldName);
                    else
                        sb.appendFormat('<td class="Cell {7} {2} {3}Type{4}{6}" style="cursor:default;"{5}>', this.get_id(), i, af.Name, af.Type == 'Byte[]' ? 'Binary' : (field.Items.length > 0 ? 'String' : af.Type), firstColumnClass, cellClickEvent, lastColumnClass, originalFieldName);
                    if (isSelectedRow && isEditing && !field.ReadOnly) sb.appendFormat('<div class="Error" id="{0}_Item{1}_Error" style="display:none"></div>', this.get_id(), field.Index);
                    if (allowRowSelector) {
                        //var family = Web.HoverMonitor.Families[String.format('{0}$RowSelector${1}', this.get_id(), i)];
                        if (!isInLookupMode && family && family.items.length > 1)
                            sb.appendFormat('<div id="{0}_RowSelector{1}" class="RowSelector" onmouseover="$showHover(this, \'{0}$RowSelector${1}\', \'RowSelector\')" onmouseout="$hideHover(this)" onclick="$toggleHover()">', this.get_id(), i);
                        if (!(isSelectedRow && isEditing)) {
                            var focusEvents = isInLookupMode || !family || family.items.length == 1 ? '' : String.format(' onfocus="$showHover(this, \'{0}$RowSelector${1}\', \'RowSelector\', 1)" onblur="$hideHover(this)" ', this.get_id(), i);
                            if (!isInLookupMode) sb.appendFormat('<a href="#" onclick="$hoverOver(this, 2);$find(\'{0}\').executeAction(\'Grid\',-1,{1});$preventToggleHover();return false" tabindex="{2}"{3}>', this.get_id(), i, $nextTabIndex(), focusEvents); else sb.appendFormat('<a href="javascript:" onclick="return false" tabindex="{0}">', $nextTabIndex());
                        }
                    }
                    this._renderItem(sb, field, row, isSelectedRow, null, allowRowSelector);
                    if (allowRowSelector && !isEditing) {
                        if (!(isSelectedRow && isEditing)) sb.append('</a>');
                        if (!isInLookupMode && family && family.items.length > 1) sb.append('</div>');
                    }
                    sb.append('</td>');
                    if (cell)
                        this._editing = null;
                }
            }
            sb.append('</tr>');
            if (isSelectedRow && cell == null)
                this._renderActionButtons(sb, 'Bottom', 'Row');
            if (isInserting && newRowIndex == i) {
                newRowIndex = -2;
                this._renderNewRow(sb);
            }
            if (this._syncFocusedCell && cell && isSelectedRow)
                cell.rowIndex = i;
        }
        if (isInserting && newRowIndex != -2) this._renderNewRow(sb);
        if (this._saveAndNew) {
            this._saveAndNew = false;
            if (this._syncFocusedCell)
                this.newDataSheetRow();
            else {
                cell = this._get_focusedCell();
                if (cell) {
                    cell.colIndex = 0;
                    this._moveFocusToNextRow(cell, this.get_pageSize());
                }
            }
        }
        this._syncFocusedCell = false;
        if (!hasSelectedRow)
            this._selectedRowIndex = null;
    },
    _renderActionColumnCell: function (row, rowIndex, isSelectedRow, actionGroups) {
        this._clonedRow = row;
        if (!isSelectedRow) {
            var lastCommandName = this.get_lastCommandName();
            var lastCommandArgument = this.get_lastCommandArgument();
            this.set_lastCommandName('Select')
            this.set_lastCommandArgument(null);
        }
        var sb = new Sys.StringBuilder();
        sb.append('<td class="Cell ActionColumn">');
        //sb.append('Edit | Del');
        var first = true;
        for (var i = 0; i < actionGroups.length; i++) {
            var ag = actionGroups[i];
            for (var j = 0; j < ag.Actions.length; j++) {
                var a = ag.Actions[j];
                if (this._isActionAvailable(a)) {
                    if (first)
                        first = false;
                    else
                        sb.append('<span class="Divider">&nbsp;</span>');
                    //this.executeAction(scope, actionindex, rowindex, groupindex);
                    sb.appendFormat('<a href="javascript:" onclick="var dv=$find(\'{0}\');dv.executeAction(\'ActionColumn\',{2},{4},{3});return false;" class="{6}"><span class="Outer"><span class="Inner"><span class="Self" title="{5}">{1}</span></span></span></a>',
                        this.get_id(), Web.DataView.htmlEncode(a.HeaderText), j, i, rowIndex, Web.DataView.htmlEncode(a.Description), a.CssClass);
                }
            }
        }
        if (first)
            sb.append('&nbsp;');
        sb.append('</td>');
        var result = sb.toString();
        sb.clear();
        this._clonedRow = null;
        if (!isSelectedRow) {
            this.set_lastCommandName(lastCommandName);
            this.set_lastCommandArgument(lastCommandArgument);
        }
        return result;
    },
    extension: function () {
        var result = null;
        var wdve = Web.DataView.Extensions;
        if (wdve) {
            var viewType = this.get_viewType();
            var viewExtensions = this._extensions;
            if (viewExtensions == null)
                viewExtensions = this._extensions = {};
            result = viewExtensions[viewType];
            if (result == null) {
                var extensionType = wdve ? wdve[viewType] : null;
                result = this._extensions[viewType] = extensionType ? new extensionType(this) : 0;
                if (result)
                    result.initialize();
            }
        }
        return result;
    },
    _renderGridView: function (sb) {
        this._renderViewDescription(sb);
        this._renderActionBar(sb);
        this._renderSearchBar(sb);
        var pagerLocation = this.get_showPager();
        var dataViewExtension = this.extension();
        this._renderPager(sb, 'Top');
        if (this.get_isChart()) {
            this._renderInfoBar(sb);
            this._sortingDisabled = false;
            var sorted = false;
            for (var i = 0; i < this._fields.length; i++) {
                var f = this._fields[i];
                if (f.Aggregate != 0)
                    this._sortingDisabled = true;
                else if (!sorted) {
                    sorted = true;
                    this.set_sortExpression(null);
                    this.set_sortExpression(f.Name);
                }
            }
            if (!dataViewExtension)
                sb.appendFormat('<tr class="ChartRow"><td colspan="{1}" class="ChartCell"><img id="{0}$Chart" class="Chart" onload="if(this.readyState==\'complete\'){{this.style.height=\'\';_body_performResize()}}"/></td></tr>', this.get_id(), this._get_colSpan());
        }
        else {
            var hasKey = this._hasKey();
            var multipleSelection = this.multiSelect() && hasKey;
            if (!this.get_searchOnStart()) {
                this._renderInfoBar(sb);
                if (!dataViewExtension)
                    this._renderRows(sb, hasKey, multipleSelection);
            }
            if (!dataViewExtension) {
                this._renderAggregates(sb, multipleSelection);
                this._renderNoRecordsWhenNeeded(sb);
            }
        }
        if (!dataViewExtension)
            this._renderPager(sb, 'Bottom');
    },
    _renderAggregates: function (sb, multipleSelection) {
        var aggregates = this.get_aggregates();
        if (this._totalRowCount == 0 || aggregates == null) return;
        sb.append('<tr class="AggregateRow">');
        if (multipleSelection) sb.append('<td class="Aggregate">&nbsp;</td>');
        if (this.get_showIcons()) sb.append('<td class="Aggregate">&nbsp;</td>');
        if (this.get_isDataSheet()) sb.append('<td class="Aggregate">&nbsp;</td>');
        if (this._actionColumn) sb.append('<td class="Aggregate">&nbsp;</td>');
        for (var i = 0; i < this.get_fields().length; i++) {
            var field = this.get_fields()[i];
            if (field.Aggregate == 0) sb.append('<td class="None">&nbsp;</td>');
            else {
                var v = aggregates[field.Index];
                if (v == null) v = Web.DataViewResources.Data.NullValue;
                else v = field.format(v);
                var f = this._allFields[field.AliasIndex];
                if (f.IsMirror)
                    v = aggregates[field.AliasIndex];
                var a = Web.DataViewResources.Grid.Aggregates[Web.DataViewAggregates[field.Aggregate]];
                sb.appendFormat('<td class="Aggregate {0} {1}Type" title="', f.Name, f.Type);
                sb.appendFormat(a.ToolTip, f.HeaderText);
                sb.append('">');
                sb.appendFormat(a.FmtStr, v);
                sb.append('</td>');
            }
        }
        sb.append('</tr>');
    },
    _renderSearchBar: function (sb) {
        if (!this.get_showSearchBar()) return;
        if (__tf != 4) return;
        this._searchBarInitialized = false;
        sb.appendFormat('<tr class="SearchBarRow" id="{0}$SearchBar" style="{2}"><td colspan="{1}" class="SearchBarCell" id="{0}$SearchBarContent">Search bar goes here.<br/><br/><br/><br/></td></tr>', this.get_id(), this._get_colSpan(), this.get_searchBarIsVisible() ? '' : 'display:none');
    },
    _renderNoRecordsWhenNeeded: function (sb) {
        if (this._totalRowCount == 0) {
            var newRowLink = this.get_isDataSheet() && this._keyFields.length > 0 && this.executeActionInScope(['Row', 'ActionBar'], 'New', null, null, true) ? String.format(' <a href="javascript:" class="NewRowLink" onclick="$find(\'{0}\').newDataSheetRow();return false;" title="{2}">{1}</a>', this.get_id(), Web.DataViewResources.Grid.NewRowLink, Web.DataViewResources.Lookup.GenericNewToolTip) : '';
            sb.appendFormat('<tr class="Row NoRecords"><td colspan="{0}" class="Cell">{1}{2}</td></tr>', this._get_colSpan(), Web.DataViewResources.Data.NoRecords, newRowLink);
        }
    },
    _attachBehaviors: function () {
        if ($appfactory.mobile) return;
        this._detachBehaviors();
        this._attachFieldBehaviors();
        var e = this.get_quickFindElement();
        if (e) $addHandlers(e, this._quickFindHandlers, this);
    },
    _get: function (family, index) {
        return index == null ? $get(this.get_id() + family) : $get(this.get_id() + family + index);
    },
    _attachTimeOptions: function (field, element) {
        var c = $create(Web.AutoComplete, {
            'completionInterval': 500,
            'contextKey': '', //String.format('{0},{1},{2}', this.get_controller(), this.get_viewId(), field.Name),
            'delimiterCharacters': '',
            'id': this.get_id() + '_AutoComplete$Time' + field.Index,
            'minimumPrefixLength': field.AutoCompletePrefixLength,
            //'serviceMethod': 'GetCompletionList',
            //'servicePath': this.get_servicePath(),
            //'useContextKey': true,
            'typeCssClass': 'AutoComplete'
        },
                                    null, null, element);
        Sys.UI.DomElement.addCssClass(c._completionListElement, 'Time');
        var dtf = Sys.CultureInfo.CurrentCulture.dateTimeFormat;
        var cache = null;
        if (field.Type == 'TimeSpan') {
            cache = Web.DataView._timeSpanOptions;
            if (!cache) {
                cache = [];
                var dt = new Date();
                dt.setHours(0, 0, 0, 0);
                while (cache.length < 24 * 4) {
                    Array.add(cache, String.format('{0:d2}{1}{2:d2}', dt.getHours(), dtf.TimeSeparator, dt.getMinutes()));
                    dt.setMinutes(dt.getMinutes() + 15);
                }
                Web.DataView._timeSpanOptions = cache;
            }
        }
        else {
            cache = Web.DataView._timeOptions;
            if (!cache) {
                cache = [];
                dt = new Date();
                dt.setHours(dt.getHours(), 0, 0, 0);
                while (cache.length < 24 * 2) {
                    Array.add(cache, String.localeFormat('{0:' + dtf.ShortTimePattern + '}', dt));
                    dt.setMinutes(dt.getMinutes() + 30);
                }
                Web.DataView._timeOptions = cache;
            }
        }
        (c._cache = [])['%'] = cache;
        return c;
    },
    _executeClientEditorFactories: function (field, element, attach) {
        var editors = element == null ? field.Editor : field.ClientEditor;
        if (!String.isNullOrEmpty(editors)) {
            var factories = editors.split(Web.DataView._simpleListRegex);
            for (var j = 0; j < factories.length; j++) {
                var editorFactory = factories[j];
                var factoryName = editorFactory.replace(/\W/g, '$');
                var factoryInstance = Web.DataView.EditorFactories[factoryName];
                if (factoryInstance == null) {
                    try {
                        factoryInstance = eval(String.format('typeof {0}!="undefined"?new {0}():""', factoryName));
                    }
                    catch (ex) {
                        factoryInstance = '';
                    }
                    Web.DataView.EditorFactories[factoryName] = factoryInstance;
                }
                if (element == null)
                    return factoryInstance != '';
                if (factoryInstance != '') {
                    if (!attach && Web.DataView._customInputElements.indexOf(element.id) < 0)
                        return;
                    var viewType = this.get_viewType();
                    var result = attach ? factoryInstance.attach(element, viewType) : factoryInstance.detach(element, viewType);
                    if (result) {
                        if (attach)
                            Array.add(Web.DataView._customInputElements, element.id);
                        else
                            Array.remove(Web.DataView._customInputElements, element.id);
                        return true;
                    }
                }
            }
        }
        return false;
    },
    _attachFieldBehaviors: function () {
        if (this.get_isEditing()) {
            for (var i = 0; i < this.get_fields().length; i++) {
                var field = this.get_fields()[i];
                var element = this._get('_Item', field.Index); // $get(this.get_id() + '_Item' + field.Index);
                var c = null;
                if (element && !field.ReadOnly && !this._executeClientEditorFactories(field, element, true)) {
                    if (element.tagName == 'TEXTAREA' && field.Len > 0) {
                        element.setAttribute('maxlength', field.Len);
                        $addHandler(element, 'keyup', this._checkMaxLengthHandler)
                        $addHandler(element, 'blur', this._checkMaxLengthHandler)
                    }
                    if (!String.isNullOrEmpty(field.Mask)) {
                        var cc = Sys.CultureInfo.CurrentCulture;
                        var sdp = cc.dateTimeFormat.ShortDatePattern.toUpperCase().split(cc.dateTimeFormat.DateSeparator);
                        var m = $create(AjaxControlToolkit.MaskedEditBehavior, {
                            'CultureAMPMPlaceholder': cc.dateTimeFormat.AMDesignator + ';' + cc.dateTimeFormat.PMDesignator,
                            'CultureCurrencySymbolPlaceholder': cc.numberFormat.CurrencySymbol,
                            'CultureDateFormat': sdp[0].substring(0, 1) + sdp[1].substring(0, 1) + sdp[2].substring(0, 1),
                            'CultureDatePlaceholder': cc.dateTimeFormat.DateSeparator,
                            'CultureDecimalPlaceholder': cc.numberFormat.NumberDecimalSeparator,
                            'CultureName': cc.name,
                            'CultureThousandsPlaceholder': cc.numberFormat.NumberGroupSeparator,
                            'CultureTimePlaceholder': cc.dateTimeFormat.TimeSeparator,
                            'DisplayMoney': field.DataFormatString == '{0:c}',
                            'Mask': field.Mask,
                            'MaskType': field.MaskType,
                            'ClearMaskOnLostFocus': field.MaskType > 0,
                            'id': this.get_id() + '_MaskedEdit' + field.Index
                        },
                            null, null, element);
                        if (field.MaskType == 2) m.set_InputDirection(1);
                        Array.add(field.Behaviors, m);

                    }
                    if (field.Type.startsWith('Date')) {
                        c = $create(AjaxControlToolkit.CalendarBehavior, { id: this._get('_Calendar', field.Index)/* this.get_id() + '_Calendar' + field.Index*/ }, null, null, element);
                        c.set_format((field.DateFmtStr ? field.DateFmtStr : field.DataFormatString).match(/\{0:([\s\S]*?)\}/)[1]);
                        var button = $get(element.id + '_Button');
                        if (button) c.set_button(button);
                        if (field.TimeFmtStr) {
                            element = this._get('_Item$Time', field.Index);
                            if (element) {
                                Array.add(field.Behaviors, c);
                                c = this._attachTimeOptions(field, element);
                            }
                            //                            if (element) {
                            //                                Array.add(field.Behaviors, c);
                            //                                c = $create(Web.AutoComplete, {
                            //                                    'completionInterval': 500,
                            //                                    'contextKey': '', //String.format('{0},{1},{2}', this.get_controller(), this.get_viewId(), field.Name),
                            //                                    'delimiterCharacters': '',
                            //                                    'id': this.get_id() + '_AutoComplete$Time' + field.Index,
                            //                                    'minimumPrefixLength': field.AutoCompletePrefixLength,
                            //                                    //'serviceMethod': 'GetCompletionList',
                            //                                    //'servicePath': this.get_servicePath(),
                            //                                    //'useContextKey': true,
                            //                                    'typeCssClass': 'AutoComplete'
                            //                                },
                            //                                    null, null, element);
                            //                                Sys.UI.DomElement.addCssClass(c._completionListElement, 'Time');
                            //                                var cache = Web.DataView._timeOptions;
                            //                                if (!cache) {
                            //                                    cache = [];
                            //                                    var dt = new Date();
                            //                                    dt.setHours(dt.getHours(), 0, 0, 0);
                            //                                    while (cache.length < 24 * 2) {
                            //                                        Array.add(cache, String.localeFormat('{0:' + Sys.CultureInfo.CurrentCulture.dateTimeFormat.ShortTimePattern + '}', dt));
                            //                                        dt.setMinutes(dt.getMinutes() + 30);
                            //                                    }
                            //                                    Web.DataView._timeOptions = cache;
                            //                                }
                            //                                (c._cache = [])['%'] = cache;
                            //                            }
                        }
                    }
                    else if (field.Type == 'TimeSpan')
                        c = this._attachTimeOptions(field, element);
                    else if (element.type == 'text' && field.AutoCompletePrefixLength > 0) {
                        c = $create(Web.AutoComplete, {
                            'completionInterval': 500,
                            'contextKey': String.format('{0},{1},{2}', this.get_controller(), this.get_viewId(), field.Name),
                            'delimiterCharacters': ',;',
                            'id': this.get_id() + '_AutoComplete' + field.Index,
                            'minimumPrefixLength': field.AutoCompletePrefixLength,
                            'serviceMethod': 'GetCompletionList',
                            'servicePath': this.get_servicePath(),
                            'useContextKey': true,
                            'typeCssClass': 'AutoComplete'
                        },
                            null, null, element);
                    }
                    else if (field.ItemsStyle == 'AutoComplete') {
                        var aliasField = this._allFields[field.AliasIndex];
                        element = this._get('_Item', aliasField.Index);
                        if (element && element.type == 'text')
                            c = $create(Web.AutoComplete, {
                                'completionInterval': 500,
                                'contextKey': String.format('Field:{0},{1}', this.get_id(), aliasField.Name),
                                'delimiterCharacters': '',
                                'id': this.get_id() + '_AutoComplete' + field.Index,
                                'minimumPrefixLength': field.AutoCompletePrefixLength == 0 ? 1 : field.AutoCompletePrefixLength,
                                'serviceMethod': 'GetPage',
                                'servicePath': this.get_servicePath(),
                                'useContextKey': true,
                                'fieldName': field.Name,
                                'enableCaching': false,
                                'typeCssClass': 'Lookup'
                            },
                            null, null, element);
                    }

                    if (c)
                        Array.add(field.Behaviors, c);
                }
            }
        }
    },
    _detachBehaviors: function () {
        // detach quick find
        if ($appfactory.mobile) return;
        var e = this.get_quickFindElement();
        if (e) $clearHandlers(e);
        // detach row header drop downs and field behaviors
        //var editing = this.get_isEditing();
        if (this.get_fields() != null) {
            for (i = 0; i < this.get_fields().length; i++) {
                var field = this.get_fields()[i];
                var element = this._get('_Item', field.Index);
                if (element && this._executeClientEditorFactories(field, element, false))
                    continue;
                if (field.Len > 0 && field.Rows > 1) {
                    if (element && element.tagName == 'TEXTAREA' && element._events) {
                        $removeHandler(element, 'keyup', this._checkMaxLengthHandler);
                        $removeHandler(element, 'blur', this._checkMaxLengthHandler);
                    }
                }
                if (field._lookupModalBehavior != null) {
                    field._lookupModalBehavior.dispose();
                    field._lookupModalPanel.parentNode.removeChild(field._lookupModalPanel);
                    delete field._lookupModalPanel;
                    field._lookupModalBehavior = null;
                }
                if (field._lookupDataControllerBehavior != null) {
                    field._lookupDataControllerBehavior.dispose();
                    field._lookupDataControllerBehavior = null;
                }
                for (var j = 0; j < field.Behaviors.length; j++)
                    field.Behaviors[j].dispose();
                Array.clear(field.Behaviors);
                if (field.Editor)
                    Web.DataView.Editors[field.EditorId] = null;
            }
        }
    },
    _registerDataTypeFilterItems: function (family, parentItem, filterDef, activeFunc, field) {
        var item = null;
        for (var i = 0; i < filterDef.length; i++) {
            var fd = filterDef[i];
            if (!fd) {
                if (!field.SearchOptions) {
                    item = new Web.Item(family);
                    parentItem.addChild(item);
                }
            }
            else if (!fd.Hidden && (!field.SearchOptions || Array.indexOf(field.SearchOptions, fd.Function) >= 0)) {
                item = new Web.Item(family, fd.Prompt ? fd.Text + '...' : fd.Text);
                parentItem.addChild(item);
                if (fd.List)
                    this._registerDataTypeFilterItems(family, item, fd.List, activeFunc, field);
                else
                    if (fd.Prompt)
                        item.set_script('$find("{0}").showFieldFilter({1},"{2}","{3}")', this.get_id(), field.Index, fd.Function, fd.Text);
                    else
                        item.set_script('$find("{0}").applyFieldFilter({1},"{2}")', this.get_id(), field.Index, fd.Function);
                if (activeFunc && fd.Function == activeFunc) {
                    var currItem = item;
                    while (currItem) {
                        currItem.set_selected(true);
                        currItem = currItem.get_parent();
                    }
                }
            }
        }
    },
    _registerFieldHeaderItems: function (fieldIndex, containerFamily, containerItems, ignoreAggregates) {
        var startIndex = fieldIndex == null ? 0 : fieldIndex;
        var endIndex = fieldIndex == null ? this.get_fields().length - 1 : fieldIndex;
        var sort = this.get_sortExpression();
        if (sort) sort = sort.match(/^(\w+)\s+(asc|desc)/);
        for (var i = startIndex; i <= endIndex; i++) {
            var fieldFilter = null;
            var items = new Array();
            var family = containerFamily ? containerFamily : String.format('{0}$FieldHeaderSelector${1}', this.get_id(), i);
            var originalField = this.get_fields()[i];
            var field = this._allFields[originalField.AliasIndex];
            if (ignoreAggregates && field.Aggregate != 0) continue;
            if (field.AllowSorting || field.AllowQBE) {
                var ascending = Web.DataViewResources.HeaderFilter.GenericSortAscending;
                var descending = Web.DataViewResources.HeaderFilter.GenericSortDescending;
                switch (field.FilterType) {
                    case 'Text':
                        ascending = Web.DataViewResources.HeaderFilter.StringSortAscending;
                        descending = Web.DataViewResources.HeaderFilter.StringSortDescending;
                        break;
                    case 'Date':
                        ascending = Web.DataViewResources.HeaderFilter.DateSortAscending;
                        descending = Web.DataViewResources.HeaderFilter.DateSortDescending;
                        break;
                }
                var allowSorting = field.AllowSorting && !this._sortingDisabled;
                if (allowSorting) {
                    var sortedBy = sort && sort[1] == field.Name;
                    var item = new Web.Item(family, ascending);
                    if (sortedBy && sort[2] == 'asc')
                        item.set_selected(true);
                    else
                        item.set_cssClass('SortAscending');
                    item.set_script('$find("{0}").sort("{1} asc")', this.get_id(), field.Name);
                    Array.add(items, item);
                    item = new Web.Item(family, descending);
                    if (sortedBy && sort[2] == 'desc')
                        item.set_selected(true);
                    else
                        item.set_cssClass('SortDescending');
                    item.set_script('$find("{0}").sort("{1} desc")', this.get_id(), field.Name);
                    Array.add(items, item);
                }
                if (field.AllowQBE) {
                    fieldFilter = this.filterOf(field);
                    if (allowSorting) Array.add(items, new Web.Item())
                    item = new Web.Item(family, String.format(Web.DataViewResources.HeaderFilter.ClearFilter, field.HeaderText));
                    item.set_cssClass('FilterOff');
                    if (!fieldFilter) item.set_disabled(true);
                    item.set_script('$find("{0}").applyFilterByIndex({1},-1)', this.get_id(), originalField.AliasIndex);
                    Array.add(items, item);
                    var activeFunc = null;
                    if (!__designer()) {
                        var filterDef = Web.DataViewResources.Data.Filters[field.FilterType];
                        if (field.Items.length == 0) {
                            item = new Web.Item(family, filterDef.Text);
                            Array.add(items, item);
                            activeFunc = this.get_fieldFilter(field, true);
                            this._registerDataTypeFilterItems(family, item, filterDef.List, activeFunc, field);
                        }
                        if (field.FilterType != 'Boolean' && (!field.SearchOptions || Array.indexOf(field.SearchOptions, '$in') >= 0) && field.AllowMultipleValues != false) {
                            item = new Web.Item(family, Web.DataViewResources.HeaderFilter.CustomFilterOption);
                            if (fieldFilter && fieldFilter.match(/\$(in|out)\$/))
                                item.set_selected(true);
                            else
                                item.set_cssClass('CustomFilter');
                            item.set_script('$find("{0}").showCustomFilter({1})', this.get_id(), originalField.AliasIndex);
                            Array.add(items, item);
                        }
                    }
                    if (originalField.AllowSamples != false)
                        if (originalField._listOfValues) {
                            if (fieldFilter && fieldFilter.startsWith('=')) {
                                fieldFilter = fieldFilter.substring(1);
                                if (fieldFilter.endsWith('\0'))
                                    fieldFilter = fieldFilter.substring(0, fieldFilter.length - 1);
                            }
                            for (var j = 0; j < originalField._listOfValues.length; j++) {
                                if (j == 0) Array.add(items, new Web.Item());
                                var v = originalField._listOfValues[j];
                                var isSelected = false;
                                var text = v;
                                if (v == null)
                                    text = Web.DataViewResources.HeaderFilter.EmptyValue;
                                else if (field.Items.length > 0) {
                                    item = this._findItemByValue(field, v);
                                    text = item[1];
                                }
                                else {
                                    if (field.Type == 'String' && v.length == 0)
                                        text = Web.DataViewResources.HeaderFilter.BlankValue;
                                    else if (!String.isNullOrEmpty(field.DataFormatString))
                                        text = field.Type.startsWith('DateTime') ? String.localeFormat('{0:d}', v) : field.format(v);
                                }
                                v = this.convertFieldValueToString(field, v); // == null ? 'null' : this.convertFieldValueToString(field, v);
                                isSelected = activeFunc == '=' && fieldFilter && v == fieldFilter;
                                if (text.length > Web.DataViewResources.HeaderFilter.MaxSampleTextLen) text = text.substring(0, Web.DataViewResources.HeaderFilter.MaxSampleTextLen) + '...';
                                if (typeof (text) != 'string') text = text.toString();
                                item = new Web.Item(family, text);
                                if (isSelected) item.set_selected(true);
                                item.set_script("$find(\'{0}\').applyFilterByIndex({1},{2});", this.get_id(), originalField.AliasIndex, j);
                                item.set_group(1);
                                Array.add(items, item);
                            }
                        }
                        else if (!field.SearchOptions || Array.indexOf(field.SearchOptions, '=') >= 0) {
                            item = new Web.Item(family, Web.DataViewResources.HeaderFilter.Loading);
                            item.set_dynamic(true);
                            item.set_script('$find("{0}")._loadListOfValues("{1}","{2}","{3}")', this.get_id(), family, originalField.Name, field.Name);
                            Array.add(items, item);
                        }
                }
            }
            if (containerFamily) {
                item = new Web.Item(containerFamily, field.HeaderText);
                Array.add(containerItems, item);
                for (j = 0; j < items.length; j++) {
                    var child = items[j];
                    item.addChild(child);
                }
                if (child.get_selected())
                    item.set_selected(true);
                if (fieldFilter)
                    item.set_selected(true);
            }
            else
                $registerItems(family, items, Web.HoverStyle.Click, Web.PopupPosition.Right, Web.ItemDescriptionStyle.ToolTip);
        }
    },
    _get_specialAction: function (type) {
        if (!this._specialActions) return null;
        var text = this._specialActions[type + 'Text'];
        var script = this._specialActions[type + 'Script'];
        return String.isNullOrEmpty(script) ? null : { 'text': text, 'script': script };
    },
    _registerSpecialAction: function (a, groupIndex, actionIndex, available) {
        if (!this._specialActions.PrintText && a.CommandName.match(/^Report/)) {
            if (available == null && !this._isActionAvailable(a)) return;
            this._specialActions.PrintText = a.HeaderText;
            this._specialActions.PrintScript = String.format('$find(\'{0}\').executeAction(\'ActionBar\',{1},-1,{2})', this.get_id(), actionIndex, groupIndex);
        }
        else if (a.CssClass == 'AttachIcon') {
            if (available == null && !this._isActionAvailable(a)) return;
            this._specialActions.AnnotateText = a.HeaderText;
            this._specialActions.AnnotateScript = String.format('$find(\'{0}\').executeAction(\'ActionBar\',{1},0,{2})', this.get_id(), actionIndex, groupIndex);
        }
    },
    _registerActionBarItems: function () {
        var groups = this.get_actionGroups('ActionBar');
        var isChart = this.get_isChart();
        if (isChart && !this.get_showViewSelector()) {
            var family = String.format('{0}${1}$ActionGroup$Chart', this.get_id(), this.get_viewId());
            var items = [];
            this._registerFieldHeaderItems(null, family, items, true);
            $registerItems(family, items, Web.HoverStyle.ClickAndStay, Web.PopupPosition.Left, Web.ItemDescriptionStyle.None);
        }
        this._specialActions = { 'PrintText': null, 'PrintScript': null, 'AnnotateText': null, 'AnnotateScript': null };
        for (var i = 0; i < groups.length; i++) {
            var group = groups[i];
            family = String.format('{0}${1}$ActionGroup${2}', this.get_id(), this.get_viewId(), i);
            if (!group.Flat) {
                items = new Array();
                for (var j = 0; j < group.Actions.length; j++) {
                    var a = group.Actions[j];
                    if (this._isActionAvailable(a)) {
                        var item = new Web.Item(family, a.HeaderText, a.Description);
                        item.set_cssClass(a.CssClassEx + (String.isNullOrEmpty(a.CssClass) ? a.CommandName + 'LargeIcon' : a.CssClass));
                        Array.add(items, item);
                        item.set_script(String.format('$find(\'{0}\').executeAction(\'ActionBar\',{1},null,{2})', this.get_id(), j, i));
                        this._registerSpecialAction(a, i, j, true);
                    }
                }
                $registerItems(family, items, Web.HoverStyle.ClickAndStay, Web.PopupPosition.Left, Web.ItemDescriptionStyle.Inline);
            }
            else {
                $unregisterItems(family);
                for (j = 0; j < group.Actions.length; j++)
                    this._registerSpecialAction(group.Actions[j], i, j);
            }
        }
        Array.clear(groups);
    },
    _registerViewSelectorItems: function () {
        var items = new Array(),
            that = this,
            family = that.get_id() + '$ViewSelector';
        for (var i = 0; i < that.get_views().length; i++) {
            var view = that.get_views()[i];
            if (view.Type != 'Form' && view.ShowInSelector || view.Id == that.get_viewId()) {
                var item = new Web.Item(family, view.Label);
                if (view.Id == this.get_viewId())
                    item.set_selected(true);
                //item.set_script('$find("{0}").executeCommand({{commandName:"Select",commandArgument:"{1}"}})', this.get_id(), view.Id);
                item.set_script(function (context) {
                    that.executeCommand({ commandName: 'Select', commandArgument: context.Id });
                });
                item.context(view);
                Array.add(items, item);
            }
        }
        if (that.get_isChart()) {
            Array.add(items, new Web.Item());
            that._registerFieldHeaderItems(null, family, items, true);
        }
        $registerItems(family, items, Web.HoverStyle.ClickAndStay, Web.PopupPosition.Right, Web.ItemDescriptionStyle.None);
    },
    _registerRowSelectorItems: function () {
        var actions = this.get_actions('Grid');
        if (actions && actions.length > 0) {
            for (var i = 0; i < this._rows.length; i++) {
                var items = new Array();
                var family = String.format('{0}$RowSelector${1}', this.get_id(), i);
                for (var j = 0; j < actions.length; j++) {
                    var a = actions[j];
                    if (this._isActionAvailable(a, i)) {
                        var item = new Web.Item(family, a.HeaderText, a.Description);
                        item.set_cssClass(a.CssClassEx + (String.isNullOrEmpty(a.CssClass) ? a.CommandName + 'Icon' : a.CssClass) + (items.length == 0 ? ' Default' : ''));
                        Array.add(items, item);
                        item.set_script(String.format('$find("{0}").executeAction("Grid", {1},{2})', this.get_id(), j, i));
                    }
                }
                $registerItems(family, items, Web.HoverStyle.Click, Web.PopupPosition.Right, Web.ItemDescriptionStyle.ToolTip);
            }
        }
        else
            for (i = 0; i < this._rows.length; i++)
                $unregisterItems(String.format('{0}$RowSelector${1}', this.get_id(), i));
    },
    _get_searchBarSettings: function () {
        if (!this._searchBarSettings) this._searchBarSettings = [];
        var settings = this._searchBarSettings[this.get_viewId()];
        if (!settings) {
            var availableFields = [];
            var visibleFields = [];
            var currentFilter = this.get_filter();
            if (currentFilter.length > 0 && !this.filterIsExternal()) {
                for (var i = 0; i < currentFilter.length; i++) {
                    var filter = currentFilter[i].match(Web.DataView._fieldFilterRegex);
                    var field = this.findField(filter[1]);
                    if (!field || this._fieldIsInExternalFilter(field)) continue;
                    var aliasField = this._allFields[field.AliasIndex];
                    var m = filter[2].match(Web.DataView._filterRegex);
                    if (!filter[2].startsWith('~')) {
                        field._renderedOnSearchBar = true;
                        var item = this._findItemByValue(field, m[3]);
                        var v = m[3]; // item == null ? m[3] : item[1];
                        if (v == 'null') v = '';
                        var vm = v.match(/^([\s\S]+?)\0?$/);
                        if (vm) v = vm[1];
                        var func = field.Items.length == 0 ? m[1] : '$in';
                        var fd = this._findFilterDefByFunction(Web.DataViewResources.Data.Filters[field.FilterType].List, field.FilterType == 'Boolean' && m[3].length > 1 ? (m[3] == '%js%true' ? '$true' : '$false') : func);
                        if (fd) {
                            var m2 = v.match(/^(.+?)\$and\$(.+?)$/);
                            Array.add(visibleFields, { 'Index': field.Index, 'Function': String.format('{0},{1}', fd.Function, fd.Prompt ? 'true' : 'false'), 'Value': m2 ? m2[1] : v, 'Value2': m2 ? m2[2] : '' });
                        }
                    }
                }
            }
            var customSearch = false;
            for (i = 0; i < this._allFields.length; i++) {
                field = this._allFields[i];
                customSearch = field.Search == Web.FieldSearchMode.Required || field.Search == Web.FieldSearchMode.Suggested;
                if (customSearch) break;
            }
            for (i = 0; i < this._allFields.length; i++) {
                var originalField = this._allFields[i];
                field = this._allFields[originalField.AliasIndex];
                if (field.AllowQBE && field.Search != Web.FieldSearchMode.Forbidden && (!originalField.Hidden || field.Search != Web.FieldSearchMode.Default)) {
                    var visible = !customSearch && visibleFields.length < Web.DataViewResources.Grid.VisibleSearchBarFields || (customSearch && (originalField.Search == Web.FieldSearchMode.Required || originalField.Search == Web.FieldSearchMode.Suggested));
                    if (!field._renderedOnSearchBar) {
                        var defaultFunction = field.Items.length == 0 || field.FilterType == 'Boolean' ? null : '$in';
                        if (field.SearchOptions)
                            defaultFunction = field.SearchOptions[0];
                        var dataFiltersList = Web.DataViewResources.Data.Filters[field.FilterType].List;
                        for (var k = 0; k < dataFiltersList.length; k++) {
                            fd = dataFiltersList[k];
                            if (defaultFunction == null || fd.Function == defaultFunction)
                                break;
                        }
                        var f = { 'Index': field.Index, 'Function': String.format('{0},{1}', fd.Function, fd.Prompt ? 'true' : 'false') };
                        if (visible || (this.findFieldUnderAlias(field) == field || field.VisibleOnSearchBar == null))
                            Array.add(visible ? visibleFields : availableFields, f);
                        field.VisibleOnSearchBar = visible;
                    }
                    field._renderedOnSearchBar = false;
                }
            }
            settings = { 'visibleFields': visibleFields, 'availableFields': availableFields };
            this._searchBarSettings[this.get_viewId()] = settings;
        }
        return settings;
    },
    _lookupActionProcessing: function (enable) {
        if (enable != null)
            this._standardActionProcessing = !enable;
        return this._standardActionProcessing != true;
    },
    search: function () {
        this._lookupActionProcessing(false);
        var result = this._hasSearchAction && this.executeActionInScope(['ActionBar', 'Form'], 'Search', null, -1);
        this._lookupActionProcessing(true);
        return result;
    },
    _toggleSearchBar: function () {
        if (this._hasSearchShortcut && this.search())
            return;
        this.set_searchBarIsVisible(!this.get_searchBarIsVisible());
        this._updateSearchBar();
        if (this.get_searchBarIsVisible()) {
            if (this.get_lookupField())
                this._adjustLookupSize();
            this._focusSearchBar();
        }
        _body_performResize();
    },
    _renderSearchBarFieldNameOptions: function (sb, field, settings) {
        if (field.Search == Web.FieldSearchMode.Required) return;
        for (var i = 0; i < settings.availableFields.length; i++) {
            var fieldInfo = settings.availableFields[i];
            var f = this._allFields[fieldInfo.Index];
            sb.appendFormat('<option value="{0}">{1}</option>', i, Web.DataView.htmlEncode(f.HeaderText));
        }
        //if (settings.visibleFields.length > 1)
        //    sb.appendFormat('<option value="{0}" class="Delete">{0}</option>', Web.DataViewResources.Grid.DeleteSearchBarField);
    },
    _renderSearchBarFunctionOptions: function (sb, field, filterDefs, fieldInfo, allowedFunction) {
        for (var i = 0; i < filterDefs.length; i++) {
            var fd = filterDefs[i];
            if (fd) {
                if (fd.List)
                    this._renderSearchBarFunctionOptions(sb, field, fd.List, fieldInfo);
                else if (allowedFunction == null || fd.Function == allowedFunction) {
                    var v = String.format('{0},{1}', Web.DataView.htmlAttributeEncode(fd.Function), fd.Prompt ? 'true' : 'false')
                    var selected = v == fieldInfo.Function ? ' selected="selected"' : '';
                    var option = String.format('<option value="{0}"{1}>{2}{3}</option>', v, selected, (fd.Prompt ? '' : Web.DataViewResources.Data.Filters.Labels.Equals + ' '), !fd.Function.match(Web.DataView._keepCapitalization) ? fd.Text.toLowerCase() : fd.Text);
                    if (field.SearchOptions) {
                        var functionIndex = Array.indexOf(field.SearchOptions, fd.Function);
                        if (functionIndex >= 0)
                            field.SearchOptionSet[functionIndex] = option;
                    }
                    else
                        sb.append(option);
                }
            }
        }
    },
    _renderSearchBarField: function (sb, settings, visibleIndex) {
        var fieldInfo = settings.visibleFields[visibleIndex];
        var field = this._allFields[fieldInfo.Index];
        var allowedFunction = field.Items.length == 0 || field.FilterType == 'Boolean' ? null : '$in';
        var funcInfo = fieldInfo.Function.match(/^(.+?),(true|false)$/);
        sb.appendFormat('<tr id="{0}$SearchBarField${1}"><td class="Control"><select id="{0}$SearchBarName${1}" tabindex="{3}" onchange="$find(\'{0}\')._searchBarNameChanged({1})"><option value="{1}" selected="selected">{2}</option>', this.get_id(), visibleIndex, Web.DataView.htmlEncode(field.HeaderText), $nextTabIndex());
        this._renderSearchBarFieldNameOptions(sb, field, settings);
        sb.append('</select></td>');
        sb.appendFormat('<td class="Control"><select id="{0}$SearchBarFunction${1}" class="Function" tabindex="{2}" onchange="$find(\'{0}\')._searchBarFuncChanged({1})">', this.get_id(), visibleIndex, $nextTabIndex());
        if (field.SearchOptions)
            field.SearchOptionSet = [];
        this._renderSearchBarFunctionOptions(sb, field, Web.DataViewResources.Data.Filters[field.FilterType].List, fieldInfo, allowedFunction);
        if (field.SearchOptions)
            for (var i = 0; i < field.SearchOptionSet.length; i++)
                sb.append(field.SearchOptionSet[i]);
        sb.append('</select></td>');
        var button = field.Type.startsWith('DateTime') ? '<a class="Calendar" href="javascript:" onclick="return false">&nbsp;</a>' : '';
        var isFilter = funcInfo[1] == '$in' || funcInfo[1] == '$notin';
        var fieldValue = fieldInfo.Value;
        if (isFilter) {
            var fsb = new Sys.StringBuilder();
            var hasValues = !String.isNullOrEmpty(fieldValue)
            fsb.appendFormat('<table class="FilterValues{3}" cellpadding="0" cellspacing="0" onmouseover="Web.DataView.highlightFilterValues(this,true,\'Active\')" onmouseout="Web.DataView.highlightFilterValues(this,false,\'Active\')"><tr><td class="Values" valign="top"><div><a class="Link" onclick="$find(\'{0}\')._showSearchBarFilter({1},{2});return false;" tabindex="{4}" href="javascript:" onfocus="Web.DataView.highlightFilterValues(this,true,\'Focused\')" onblur="Web.DataView.highlightFilterValues(this,false,\'Focused\')" title="{5}">', this.get_id(), field.Index, visibleIndex, hasValues ? '' : ' Empty', $nextTabIndex(), Web.DataViewResources.Data.Filters.Labels.FilterToolTip);
            if (hasValues) {
                var values = fieldValue.split(/\$or\$/);
                for (i = 0; i < values.length; i++) {
                    if (i > 0)
                        fsb.append('<span class="Highlight">, </span>');
                    var v = values[i];
                    if (String.isJavaScriptNull(v))
                        v = Web.DataViewResources.HeaderFilter.EmptyValue;
                    else {
                        v = this.convertStringToFieldValue(field, v);
                        var item = this._findItemByValue(field, v);
                        v = item ? item[1] : field.format(v);
                    }
                    fsb.append(v);
                }
            }
            else
                fsb.append(Web.DataViewResources.Lookup.SelectLink);
            fsb.appendFormat('</a></div></td><td class="Button{5}" valign="top"><a href="javascript:" onclick="$find(\'{0}\')._showSearchBarFilter({1},{2});return false" title="{3}" tabindex="{4}" onfocus="Web.DataView.highlightFilterValues(this,true,\'Focused\')" onblur="Web.DataView.highlightFilterValues(this,false,\'Focused\')" >&nbsp;</a></td></tr></table>', this.get_id(), hasValues ? -1 : field.Index, visibleIndex, hasValues ? Web.DataViewResources.Data.Filters.Labels.Clear : Web.DataViewResources.Data.Filters.Labels.FilterToolTip, $nextTabIndex(), hasValues ? ' Clear' : '');
            button = fsb.toString();
        }
        else if (!String.isNullOrEmpty(fieldValue))
            fieldValue = fieldValue.split(/\$or\$/)[0];
        if (funcInfo[2] == 'true') {
            if (typeof (fieldValue) == 'string' && !isFilter)
                fieldValue = field.format(this.convertStringToFieldValue(field, fieldValue));
            sb.appendFormat('<td class="Control"><input id="{0}$SearchBarValue${1}" type="{6}" class="{2} {7}" value="{3}" tabindex="{4}"/>{5}</td>', this.get_id(), visibleIndex, field.FilterType, Web.DataView.htmlAttributeEncode(fieldValue == 'null' ? Web.DataViewResources.HeaderFilter.EmptyValue : fieldValue), $nextTabIndex(), button, isFilter ? 'hidden' : 'text', field.AllowAutoComplete != false ? ' AutoComplete' : '');
        }
        else
            sb.append('<td>&nbsp;</td>');
        var tabIndex = $nextTabIndex();
        if (funcInfo[1] == '$between')
            tabIndex = $nextTabIndex();
        sb.appendFormat('<td class="FieldAction"><a href="javascript:" tabindex="{1}" title="{2}" class="Remove" onclick="$find(\'{0}\')._searchBarNameChanged({3}, true)"><span></span</a></td>',
            this.get_id(), tabIndex, Web.DataViewResources.Grid.RemoveCondition, visibleIndex);
        sb.append('</tr>');
        if (field.FilterType != 'Text' && funcInfo[1] == '$between') {
            var fieldValue2 = fieldInfo.Value2;
            if (typeof (fieldValue2) == 'string')
                fieldValue2 = field.format(this.convertStringToFieldValue(field, fieldValue2));
            sb.appendFormat('<tr><td colspan="2" class="Control AndLabel">{4}</td><td><input id="{0}$SearchBarValue2${1}" type="text" class="{2}" value="{3}" tabindex="{5}"/>{6}</td><td>&nbsp;</td></tr>', this.get_id(), visibleIndex, field.FilterType, Web.DataView.htmlAttributeEncode(fieldValue2), Web.DataViewResources.Data.Filters.Labels.And, tabIndex - 1, button);
        }
    },
    _focusSearchBar: function (visibleIndex) {
        var indexSpecified = visibleIndex != null;
        if (!indexSpecified) visibleIndex = 0;
        var funcElem = this._get_searchBarControl('Function', visibleIndex);
        if (!funcElem) {
            visibleIndex = 0;
            funcElem = this._get_searchBarControl('Function', 0);
        }
        var valElem = this._get_searchBarControl('Value', visibleIndex);
        if (valElem) {
            if (valElem.type == 'hidden') {
                var a = valElem.parentNode.getElementsByTagName('a')[0];
                a.focus();
                if (indexSpecified && this._searchBarVisibleIndex == null && String.isNullOrEmpty(valElem.value))
                    a.click();
            }
            else {
                Sys.UI.DomElement.setFocus(valElem);
                //valElem.focus();
                //valElem.select();
            }
        }
        else if (funcElem)
            funcElem.focus();
    },
    _searchBarNameChanged: function (visibleIndex, remove) {
        this._saveSearchBarSettings();
        var settings = this._get_searchBarSettings();
        var fieldInfo = settings.visibleFields[visibleIndex];

        if (!remove) {
            var nameElem = this._get_searchBarControl('Name', visibleIndex);
            var availableIndex = parseInt(nameElem.value);
            settings.visibleFields[visibleIndex] = settings.availableFields[availableIndex];
            Array.removeAt(settings.availableFields, availableIndex);
        }
        else
            Array.removeAt(settings.visibleFields, visibleIndex);

        Array.insert(settings.availableFields, 0, fieldInfo);
        this._renderSearchBarControls(true);
        this._focusSearchBar(visibleIndex);
    },
    _searchBarFuncChanged: function (visibleIndex) {
        this._saveSearchBarSettings();
        var settings = this._get_searchBarSettings();
        var fieldInfo = settings.visibleFields[visibleIndex];
        var funcElem = this._get_searchBarControl('Function', visibleIndex);
        fieldInfo.Function = funcElem.value;
        this._renderSearchBarControls(true);
        this._focusSearchBar(visibleIndex);
    },
    _searchBarAddField: function () {
        this._saveSearchBarSettings();
        var settings = this._get_searchBarSettings();
        Array.add(settings.visibleFields, settings.availableFields[0]);
        Array.removeAt(settings.availableFields, 0);
        this._renderSearchBarControls(true);
        this._focusSearchBar(settings.visibleFields.length - 1);
    },
    _createSearchBarFilter: function (silent) {
        var oldFilter = Array.clone(this._filter);
        var settings = this._get_searchBarSettings();
        var filter = [];
        var success = true;
        for (var i = 0; i < settings.visibleFields.length; i++) {
            var fieldInfo = settings.visibleFields[i];
            var field = this._allFields[fieldInfo.Index];
            this.removeFromFilter(field);
            var funcInfo = fieldInfo.Function.match(/^(.+?),(true|false)$/);
            var values = [];
            if (funcInfo[2] == 'true') {
                var valElem = this._get_searchBarControl('Value', i);
                var val2Elem = this._get_searchBarControl('Value2', i);
                if (String.isBlank(valElem.value) && (!val2Elem || String.isBlank(val2Elem.value)) && field.Search != Web.FieldSearchMode.Required)
                    continue;
                if (funcInfo[1] == '$in' || funcInfo[1] == '$notin') {
                    Array.add(filter, { 'Index': field.Index, 'Function': funcInfo[1], 'Values': [valElem.value] });
                    continue;
                }
                if (String.isBlank(valElem.value)) {
                    if (silent)
                        continue;
                    else {
                        alert(Web.DataViewResources.Validator.RequiredField);
                        Sys.UI.DomElement.setFocus(valElem);
                        //valElem.focus();
                        //valElem.select();
                        success = false;
                    }
                    break;
                }
                var v = { NewValue: valElem.value.trim() };
                var error = this._validateFieldValueFormat(field, v);
                if (error) {
                    if (silent)
                        continue;
                    else {
                        alert(error);
                        Sys.UI.DomElement.setFocus(valElem);
                        //valElem.focus();
                        //valElem.select();
                        success = false;
                        break;
                    }
                }
                else
                    Array.add(values, field.Type.startsWith('DateTime') ? valElem.value.trim() : v.NewValue);
                if (funcInfo[1] == '$between') {
                    if (String.isBlank(val2Elem.value)) {
                        if (silent)
                            continue;
                        else {
                            alert(Web.DataViewResources.Validator.RequiredField);
                            Sys.UI.DomElement.setFocus(val2Elem);
                            //val2Elem.focus();
                            //val2Elem.select();
                            success = false;
                        }
                        break;
                    }
                    v = { NewValue: val2Elem.value.trim() };
                    error = this._validateFieldValueFormat(field, v);
                    if (error) {
                        if (silent)
                            continue;
                        else {
                            alert(error);
                            Sys.UI.DomElement.setFocus(val2Elem);
                            //val2Elem.focus();
                            //val2Elem.select();
                            success = false;
                            break;
                        }
                    }
                    else
                        Array.add(values, field.Type.startsWith('DateTime') ? val2Elem.value.trim() : v.NewValue);
                }
                Array.add(filter, { 'Index': field.Index, 'Function': funcInfo[1], 'Values': values });
            }
            else
                Array.add(filter, { 'Index': field.Index, 'Function': funcInfo[1], 'Values': null });
        }
        if (!success)
            return null;
        for (i = 0; i < settings.availableFields.length; i++) {
            fieldInfo = settings.availableFields[i];
            field = this._allFields[fieldInfo.Index];
            this.removeFromFilter(field);
        }
        for (i = 0; i < filter.length; i++) {
            var f = filter[i];
            this.applyFieldFilter(f.Index, f.Function, f.Values, true);
        }
        var newFilter = this._filter;
        this._filter = oldFilter;
        return newFilter;
    },
    _executeSearch: function (path) {
        var searchAction = this.get_action(path);
        if (searchAction && (!searchAction.Confirmation || !searchAction.Confirmation.match(/_controller\s*=/))) {
            var list = Sys.Application.getComponents();
            for (var i = 0; i < list.length; i++) {
                var dataView = list[i];
                if (Web.DataView.isInstanceOfType(dataView) && dataView._hasSearchAction) {
                    var searchAction2 = dataView.get_action(dataView._hasSearchAction);
                    if (searchAction2 && searchAction2.Confirmation) {
                        var m = searchAction2.Confirmation.match(/_controller\s*=\s*(\w+)/);
                        if (m && m[1] == this._controller)
                            dataView.search();
                    }
                }
            }
        }
        else {
            this._clearSelectedKey();
            this._cancelConfirmation();
            this.refreshAndResize();
        }
    },
    _performSearch: function () {
        if (this._isBusy) return;
        this._saveSearchBarSettings();
        var filter = this._createSearchBarFilter(false);
        if (filter) {
            this.set_filter(filter);
            //            this.set_pageIndex(-2);
            //            this._loadPage();
            this.refreshData();
            this._setFocusOnSearchBar = true;
        }
        this._forgetSelectedRow(true);
    },
    _resetSearchBar: function () {
        if (this._isBusy) return;
        this.clearFilter();
        this._searchBarSettings[this.get_viewId()] = null;
        this._renderSearchBarControls(true);
        this._focusSearchBar();
    },
    _get_searchBarControl: function (type, visibleIndex) {
        return $get(String.format('{0}$SearchBar{1}${2}', this.get_id(), type, visibleIndex));
    },
    _saveSearchBarSettings: function () {
        var settings = this._get_searchBarSettings();
        for (var i = 0; i < settings.visibleFields.length; i++) {
            var fieldInfo = settings.visibleFields[i];
            var funcElem = this._get_searchBarControl('Function', i);
            var valElem = this._get_searchBarControl('Value', i);
            var val2Elem = this._get_searchBarControl('Value2', i);
            fieldInfo.Function = funcElem.value;
            if (valElem) {
                valElem.value == Web.DataViewResources.HeaderFilter.EmptyValue ? 'null' : valElem.value;
                fieldInfo.Value = this._formatSearchField(valElem, fieldInfo.Index);
            }
            if (val2Elem)
                fieldInfo.Value2 = this._formatSearchField(val2Elem, fieldInfo.Index);
        }
    },
    _formatSearchField: function (input, fieldIndex) {
        var field = this._allFields[fieldIndex];
        if (field.Type.startsWith('Date')) {
            var d = Date.tryParseFuzzyDate(input.value, field.DataFormatString);
            if (d != null)
                input.value = field.format(d);
        }
        else if (field.Type != 'String') {
            var n = Number.tryParse(input.value, field.DataFormatString);
            if (n != null)
                input.value = field.format(n);
        }
        return input.value;
    },
    _renderSearchBarControls: function (force) {
        if (this._searchBarInitialized && !force) return;
        var sbc = $get(this.get_id() + '$SearchBarContent');
        this._searchBarInitialized = true;
        var sb = new Sys.StringBuilder();
        sb.append('<table class="SearchBarFrame">');

        var settings = this._get_searchBarSettings();

        for (var i = 0; i < settings.visibleFields.length; i++)
            this._renderSearchBarField(sb, settings, i);
        if (settings.availableFields.length > 0)
            sb.appendFormat('<tr><td colspan="3" class="AddConditionText"><a href="javascript:" onclick="$find(\'{0}\')._searchBarAddField();return false;">{3}</a></td><td class="FieldAction"><a href="javascript:" class="Add" tabindex="{1}" title="{2}" onclick="$find(\'{0}\')._searchBarAddField();return false;"><span></span></a></td>', this.get_id(), $nextTabIndex(), Web.DataViewResources.Grid.AddCondition, Web.DataViewResources.Grid.AddConditionText);

        sb.appendFormat('<tr><td><div id="{0}$SearchBarNameStub" class="Stub"></div></td><td><div id="{0}$SearchBarFuncStub" class="Stub"></div></td><td></td></tr>', this.get_id());

        sb.append('</table>');
        var gridSettings = Web.DataViewResources.Grid;
        sb.appendFormat('<div class="SearchButtons"><button onclick="$find(\'{0}\')._performSearch();return false" tabindex="{3}" class="Search">{1}</button><br/><button onclick="$find(\'{0}\')._resetSearchBar();return false" tabindex="{4}" class="Reset">{2}</button></div>',
            this.get_id(), gridSettings.PerformAdvancedSearch, Web.DataViewResources.Data.Filters.Labels.Clear, $nextTabIndex(), $nextTabIndex());
        //if (settings.availableFields.length > 0)
        //    sb.appendFormat('<div class="SearchBarSize"><a href="javascript:" onclick="$find(\'{0}\')._searchBarAddField();return false;" class="More" tabindex="{2}"><span title="{1}"></span></a></div>', this.get_id(), Web.DataViewResources.Grid.AddSearchBarField, $nextTabIndex());

        sbc.innerHTML = sb.toString();
        sb.clear();
        var stub = $get(this.get_id() + '$SearchBarNameStub');
        stub.style.width = stub.offsetWidth + 'px';
        stub = $get(this.get_id() + '$SearchBarFuncStub');
        stub.style.width = stub.offsetWidth + 'px';
        var selectors = sbc.getElementsByTagName('select');
        for (i = 0; i < selectors.length; i++)
            selectors[i].style.width = '100%';
        if (!this._searchBarExtenders) this._searchBarExtenders = [];
        for (i = 0; i < settings.visibleFields.length; i++) {
            var fieldInfo = settings.visibleFields[i];
            var field = this._allFields[fieldInfo.Index];
            var valElem = this._get_searchBarControl('Value', i);
            if (valElem) {
                if (fieldInfo.Function.match(/\$(in|notin),/) == null) {
                    var c = this._createFieldInputExtender('SearchBar', field, valElem, i);
                    if (c) Array.add(this._searchBarExtenders, c);
                }
                else {
                    var parentRow = valElem;
                    while (parentRow && parentRow.tagName != 'TR')
                        parentRow = parentRow.parentNode;
                    for (var j = 0; j < parentRow.childNodes.length; j++)
                        parentRow.childNodes[j].vAlign = 'top';
                }
            }
            var val2Elem = this._get_searchBarControl('Value2', i);
            if (val2Elem) {
                c = this._createFieldInputExtender('SearchBar', field, val2Elem, i + '$2');
                if (c) Array.add(this._searchBarExtenders, c);
            }
        }
    },
    _updateSearchBar: function () {
        var searchBar = this._get('$SearchBar');
        if (!searchBar) return;
        var isVisible = this.get_searchBarIsVisible();
        var sba = this._get('$SearchBarActivator');
        if (sba)
            if (isVisible)
                Sys.UI.DomElement.addCssClass(sba, 'Activated');
            else
                Sys.UI.DomElement.removeCssClass(sba, 'Activated');
        Sys.UI.DomElement.setVisible(searchBar, isVisible);
        if (isVisible)
            this._renderSearchBarControls(searchBar);
        if (sba) {
            Sys.UI.DomElement.setVisible(this._get('$QuickFind'), !isVisible);
            var searchToggle = this._get('$SearchToggle');
            if (this._hasSearchAction && this._hasSearchShortcut)
                searchToggle.title = Web.DataViewResources.Grid.PerformAdvancedSearch;
            else
                searchToggle.title = this.get_searchBarIsVisible() ? Web.DataViewResources.Grid.HideAdvancedSearch : Web.DataViewResources.Grid.ShowAdvancedSearch;
        }
        var infoRow = this._get('$InfoRow');
        if (infoRow) {
            if (isVisible)
                Sys.UI.DomElement.addCssClass(infoRow, 'WithSearchBar');
            else
                Sys.UI.DomElement.removeCssClass(infoRow, 'WithSearchBar');
        }
        if (this._setFocusOnSearchBar) {
            this._setFocusOnSearchBar = false;
            this._focusSearchBar();
        }
    },
    _renderSearchBarActivator: function (sb) {
        if (!this.get_showSearchBar() || (!this.get_showQuickFind() && this.get_searchOnStart())) return;
        sb.appendFormat('<td class="SearchBarActivator{1}" id="{0}$SearchBarActivator"><a href="javascript:" onclick="$find(\'{0}\')._toggleSearchBar();return false;" id="{0}$SearchToggle"><span></span></a></td>', this.get_id(), this._hasSearchAction && this._hasSearchShortcut ? ' Search' : '');
        if (!this.get_showQuickFind())
            sb.append('<td class="Divider"><div></div></td>');
    },
    _internalRenderActionBar: function (sb) {
        var groups = this.get_actionGroups('ActionBar');
        sb.append('<table cellpadding="0" cellspacing="0" class="Groups"><tr>');
        var isGrid = this.get_isGrid();
        if (isGrid/*view.Type == 'Grid'*/)
            this._renderSearchBarActivator(sb);
        if (isGrid/*view.Type == 'Grid'*/ && this.get_showQuickFind()) {
            var s = this.get_quickFindText();
            sb.appendFormat('<td class="QuickFind" title="{2}" id="{0}$QuickFind"><div class="QuickFind"><table cellpadding="0" cellspacing="0"><tr><td><input type="text" id="{0}_QuickFind" value="{1}" class="{3}" tabindex="{4}"/></td><td class="Button"><a href="#" onclick="$find(\'{0}\').quickFind();return false;"><span>&nbsp;</span></a></td></tr></table></div></td>',
                this.get_id(), Web.DataView.htmlAttributeEncode(s), Web.DataViewResources.Grid.QuickFindToolTip, s == Web.DataViewResources.Grid.QuickFindText ? 'Empty' : 'NonEmpty', $nextTabIndex());
            sb.append('<td class="Divider"><div></div></td>');
            if (this.get_lookupField() && !String.isNullOrEmpty(this.get_lookupField().ItemsNewDataView)) {
                sb.appendFormat('<td class="QuickCreateNew"><a href="javascript:" onclick="$find(\'{0}\').closeLookupAndCreateNew();return false;" class="CreateNew" title="{1}" tabindex="{2}><span class="Placeholder"></span></a></td>', this.get_id(), Web.DataViewResources.Lookup.GenericNewToolTip, $nextTabIndex());
            }
        }
        else {
            if (groups.length == 0 || this.get_lookupField())
                sb.append('<td class="Divider"><div style="visibility:hidden"></div></td>');
        }


        if (!this.get_lookupField()) {
            // create action bar items
            this._registerActionBarItems();
            // render action group
            var showChartGroup = this.get_isChart() && !this.get_showViewSelector();
            if (showChartGroup)
                sb.appendFormat('<td class="Group Main" onmouseover="$showHover(this,&quot;{0}${1}$ActionGroup$Chart&quot;,&quot;ActionGroup&quot;)" onmouseout="$hideHover(this)" onclick="$toggleHover()"><span class="Outer"><a href="javascript:" onfocus="$showHover(this,&quot;{0}${1}$ActionGroup$Chart&quot;,&quot;ActionGroup&quot;,2)" onblur="$hideHover(this)" tabindex="{3}" onclick="$hoverOver(this, 2);return false;">{2}</a></span></td>',
                        this.get_id(), this.get_viewId(), Web.DataView.htmlEncode(this.get_view().Label), $nextTabIndex());
            for (var i = 0; i < groups.length; i++) {
                if (i > 0 || showChartGroup)
                    sb.append('<td class="Divider"><div></div></td>');
                var group = groups[i];
                if (group.Flat) {
                    var firstIndex = -1;
                    var lastIndex = -1;
                    for (var j = 0; j < group.Actions.length; j++) {
                        var a = group.Actions[j];
                        a._isAvailable = this._isActionAvailable(a) && !String.isNullOrEmpty(a.HeaderText);
                        a._isFirst = false;
                        a._isLast = false;
                        if (a._isAvailable) {
                            if (firstIndex == -1)
                                firstIndex = j;
                            lastIndex = j;
                        }
                    }
                    if (firstIndex >= 0) {
                        group.Actions[firstIndex]._isFirst = true;
                        group.Actions[lastIndex]._isLast = true;
                    }
                    for (j = 0; j < group.Actions.length; j++) {
                        a = group.Actions[j];
                        if (a._isAvailable)
                            sb.appendFormat(
                                '<td class="{7}Group FlatGroup{6}{8}{9}" onmouseover="$showHover(this,&quot;{0}${2}$ActionGroup${1}&quot;,&quot;ActionGroup&quot;)" onmouseout="$hideHover(this)" onclick="if(this._skip)this._skip=null;else $find(\'{0}\').executeAction(\'ActionBar\',{1},null,{2})" title="{10}"><span class="Outer">{5}<a href="javascript:" tabindex="{4}" onclick="this.parentNode.parentNode._skip=true;$find(\'{0}\').executeAction(\'ActionBar\',{1},null,{2});return false;" onfocus="$showHover(this,&quot;{0}${2}$ActionGroup${1}&quot;,&quot;ActionGroup&quot;,2)" onblur="$hideHover(this)">{3}</a></span></td>',
                                    this.get_id(), j, i, Web.DataView.htmlEncode(a.HeaderText), $nextTabIndex(),
                                    !String.isNullOrEmpty(a.CssClass) ? String.format('<span class="FlatGroupIcon {0}">&nbsp;</span>', a.CssClass) : '',
                                    !String.isNullOrEmpty(a.CssClass) ? ' FlatGroupWithIcon' : '',
                                    a.CssClassEx,
                                    a._isFirst ? ' First' : '',
                                    a._isLast ? ' Last' : '', a.Description);
                    }
                }
                else
                    sb.appendFormat('<td class="{5}Group" onmouseover="$showHover(this,&quot;{0}${1}$ActionGroup${2}&quot;,&quot;ActionGroup&quot;)" onmouseout="$hideHover(this)" onclick="$toggleHover()"><span class="Outer"><a href="javascript:" onfocus="$showHover(this,&quot;{0}${1}$ActionGroup${2}&quot;,&quot;ActionGroup&quot;,2)" onblur="$hideHover(this)" tabindex="{4}" onclick="$hoverOver(this, 2);return false;">{3}</a></span></td>',
                        this.get_id(), this.get_viewId(), i, group.HeaderText, $nextTabIndex(), group.CssClassEx);
            }
        }
        sb.append('</tr></table>');
    },
    _renderActionBar: function (sb) {
        if (!this.get_showActionBar()) {
            this._registerActionBarItems();
            return;
        }
        sb.appendFormat('<tr class="ActionRow"><td colspan="{0}"  class="ActionBar">', this._get_colSpan());
        sb.appendFormat('<table style="width:100%" cellpadding="0" cellspacing="0"><tr><td style="width:100%" id="{0}$ActionBar">', this.get_id());

        this._internalRenderActionBar(sb);

        this._registerViewSelectorItems();
        sb.append('</td><td class="ViewSelectorControl">');
        if (this.get_showViewSelector()) {
            sb.appendFormat('<table cellpadding="0" cellspacing="0"><tr><td class="ViewSelectorLabel">{0}:</td><td>', Web.DataViewResources.ActionBar.View);
            sb.appendFormat('<span class="ViewSelector" onmouseover="$showHover(this,&quot;{0}$ViewSelector&quot;,&quot;ViewSelector&quot;)" onmouseout="$hideHover(this)" onclick="$toggleHover()"><span class="Outer"><span class="Inner"><a href="javascript:" class="Link" tabindex="{2}" onfocus="$showHover(this,&quot;{0}$ViewSelector&quot;,&quot;ViewSelector&quot;,3)" onblur="$hideHover(this)">{1}</a></span></span></span>',
            this.get_id(), Web.DataView.htmlEncode(this.get_view().Label), $nextTabIndex());
            sb.append('</td></tr></table>');
        }
        sb.append('</td></tr></table>');
        sb.append('</td></tr>');
    },
    get_statusBar: function () {
        return this._statusBar;
    },
    _renderStatusBar: function (sb) {
        sb.appendFormat('<tr class="StatusBarRow" style="display:none"><td colspan="{1}" class="StatusBar" id="{0}$StatusBar"></td></tr>', this.get_id(), this._get_colSpan());
    },
    statusBar: function () {
        var statusBar = this.get_statusBar(),
            smb;
        if (!String.isNullOrEmpty(statusBar)) {
            var iterator = /((\w+)\.)?((\w+)\.)?(\w+):\s*(.+?)\s*\n\s*(((.+?)\s*>\s*)+)/g,
                m = iterator.exec(statusBar);
            while (m) {
                var v = this.fieldValue(m[5]);
                if (v == null) v = 'null';
                if ((m[6] == v || m[6] == '*') && (String.isNullOrEmpty(m[2]) || m[2] == this.get_controller()) && (String.isNullOrEmpty(m[3]) || m[4] == this.get_viewId())) {
                    iterator = /(\[)?\s*(.+?)\s*(\])?\s*>\s*/g;
                    var segmentList = [];
                    var m2 = iterator.exec(m[7]);
                    while (m2) {
                        Array.add(segmentList, { 'Text': m2[2], 'Current': m2[1] == '[' && m2[3] == ']' });
                        m2 = iterator.exec(m[7]);
                    }
                    if (segmentList.length > 0 && !(__tf != 4)) {
                        smb = new Sys.StringBuilder('<ul class="StatusBar">');
                        var past = false;
                        var future = true;
                        for (var i = 0; i < segmentList.length; i++)
                            if (segmentList[i].Current) {
                                past = true;
                                future = false;
                                break;
                            }

                        for (i = 0; i < segmentList.length; i++) {
                            var segment = segmentList[i];
                            var age = segment.Current ? 'Current' : (past ? 'Past' : (future ? 'Future' : ''));

                            var nextSegment = i < segmentList.length - 1 ? segmentList[i + 1] : null;
                            var transition = '';
                            if (nextSegment) {
                                if (nextSegment.Current)
                                    transition = age + 'ToCurrent';
                                else if (segment.Current)
                                    if (nextSegment.Current)
                                        transition = age + 'ToCurrent';
                                    else
                                        transition = age + 'ToFuture';
                            }

                            if (segment.Current) {
                                past = false;
                                future = true;
                            }
                            smb.appendFormat('<li class="Segment {1}{2}{3} {4}"><span class="Outer"><span class="Inner"><span class="Self">{0}</span></span></span></li>', Web.DataView.htmlEncode(segment.Text), age, i == 0 ? ' First' : '', i == segmentList.length - 1 ? ' Last' : '', transition);
                        }
                        smb.append('</ul>');
                    }
                    break;
                }
                m = iterator.exec(statusBar);
            }
        }
        return smb ? smb.toString() : null;
    },
    _updateStatusBar: function () {
        var statusBar = this.get_statusBar(),
            html,
            statusBarCell;
        if (!String.isNullOrEmpty(statusBar)) {
            statusBarCell = $(this._get('$StatusBar'));
            if (statusBarCell.length) {
                html = this.statusBar();
                if (html)
                    statusBarCell.html(html).parent().show();
                else
                    statusBarCell.parent().hide();
            }
        }
    },
    filterByFirstLetter: function (index) {
        var fieldName = this._firstLetters[0];
        var letter = this._firstLetters[index]
        this.applyFieldFilter(this.findField(fieldName).Index, "$beginswith", [letter]);
    },
    _renderViewDescription: function (sb) {
        var showLetters = this._firstLetters && this._firstLetters.length > 2;
        var showDescription = this.get_showDescription();
        if (!showDescription && !showLetters) return;
        var t = showDescription ? this.get_description() : '';
        var lt = null;
        if (showLetters) {
            var lsb = new Sys.StringBuilder();
            lsb.append('<div class="Letters">');
            var field = this.findField(this._firstLetters[0]);
            var selectedLetter = null;
            for (var i = 0; i < this._filter.length; i++) {
                var m = this._filter[i].match(Web.DataView._fieldFilterRegex);
                if (m && m[1] == field.Name) {
                    m = m[2].match(/^\$beginswith\$(.+?)\0$/);
                    if (m)
                        selectedLetter = this.convertStringToFieldValue(field, m[1]);
                    break;
                }
            }
            var beginsWith = String.format('{0} {1} ', Web.DataView.htmlAttributeEncode(field.Label), Web.DataViewResources.Data.Filters.Text.List[2].Text.toLowerCase());
            for (i = 1; i < this._firstLetters.length; i++) {
                var letter = this._firstLetters[i];
                lsb.appendFormat('<a href="javascript:" onclick="$find(\'{0}\').filterByFirstLetter({1});return false;" class="Letter{5}" title="{3}{4}">{2}</a> ',
                    this.get_id(), i, letter, beginsWith, Web.DataView.htmlAttributeEncode(letter), selectedLetter == letter ? ' Selected' : '');
            }
            lsb.append('</div>');
            lt = lsb.toString();
            lsb.clear();
        }
        if (showDescription && String.isNullOrEmpty(t))
            t = this.get_view().HeaderText;
        //var isTree = this.get_isTree();
        if (!String.isNullOrEmpty(t) || this.get_lookupField() || /*isTree || */lt) {
            sb.appendFormat('<tr class="HeaderTextRow"><td colspan="{0}" class="HeaderText">', this._get_colSpan());
            if (this.get_lookupField() != null)
                sb.append('<table style="width:100%" cellpadding="0" cellspacing="0"><tr><td style="padding:0px">');
            sb.appendFormat('<div id="{0}$HeaderText">', this.get_id());
            sb.append(this._formatViewText(Web.DataViewResources.Views.DefaultDescriptions[t], true, t));
            sb.append('</div>');
            if (lt)
                sb.append(lt);
            if (this.get_lookupField() != null)
                sb.appendFormat('</td><td align="right" style="padding:0px"><a href="javascript:" class="Close" onclick="$find(\'{0}\').hideLookup();return false" tabindex="{2}" title="{1}">&nbsp;</a></td></tr></table>', this.get_id(), Web.DataViewResources.ModalPopup.Close, $nextTabIndex());
            /*if (isTree) {
            var path = this.get_path();
            sb.append('<div class="Path">');
            sb.appendFormat('<a href="javascript:" onclick="return false" class="Toggle" title="{1}"><span>&nbsp;</span></a>', this.get_id(), Web.DataView.htmlAttributeEncode(Web.DataViewResources.Grid.FlatTreeToggle));
            for (i = 0; i < path.length; i++) {
            var levelInfo = path[i];
            sb.appendFormat('<span class="Divider"></span><a href="javascript:" class="Node{4}" onclick="$find(\'{0}\').drillIn({1})" title="{3}">{2}</a>', this.get_id(), i,
            Web.DataView.htmlEncode(levelInfo.text),
            Web.DataView.htmlAttributeEncode(String.format(Web.DataViewResources.Lookup.SelectToolTip, '"' + levelInfo.text + '"')),
            i == path.length - 1 ? ' Selected' : '');
            }
            sb.append('</div>');
            }*/
            sb.append('</td></tr>');
        }
    },
    _renderInfoBar: function (sb) {
        var filter = this.get_filter();
        if (filter.length > 0 && !this.filterIsExternal()) {
            var fsb = new Sys.StringBuilder();
            if (this.get_viewType() != "Form")
                this._renderFilterDetails(fsb, filter);
            if (this.get_viewType() != "Form" && !fsb.isEmpty()) {
                sb.appendFormat('<tr class="InfoRow {2}" id="{0}$InfoRow"><td colspan="{1}">', this.get_id(), this._get_colSpan(), this.get_viewType());
                sb.append(fsb.toString());
                sb.append('</td></tr>');
            }
            fsb.clear();
        }
    },
    _findFilterDefByFunction: function (filterDefs, func) {
        if (func.endsWith('$')) func = func.substring(0, func.length - 1);
        for (var i = 0; i < filterDefs.length; i++) {
            var fd = filterDefs[i];
            if (fd) {
                if (fd.List) {
                    var result = this._findFilterDefByFunction(fd.List, func);
                    if (result) return result;
                }
                else if (fd.Function == func)
                    return fd;
            }
        }
        return null;
    },
    _renderFilterDetails: function (sb, currentFilter) {
        var bannerRendered = false;
        //var checkRecursive = true;
        for (var i = 0; i < currentFilter.length; i++) {
            var filter = currentFilter[i].match(Web.DataView._fieldFilterRegex);
            var field = this.findField(filter[1]);
            //var recursive = field && field.ItemsDataController == this.get_controller() && this.get_isTree() && checkRecursive;
            //if (recursive)
            //    checkRecursive = false;
            if (!field || this._fieldIsInExternalFilter(field)/* || recursive*/) continue;
            if (!bannerRendered) {
                sb.appendFormat('<a href="javascript:" onclick="$find(\'{0}\').clearFilter();return false" class="Close" tabindex="{3}" title="{2}">&nbsp;</a><span class="Details"><span class="Information">&nbsp;</span>{1} ', this.get_id(), Web.DataViewResources.InfoBar.FilterApplied, Web.DataViewResources.ModalPopup.Close, $nextTabIndex());
                bannerRendered = true;
            }
            var aliasField = this._allFields[field.AliasIndex];
            var m = Web.DataView._filterIteratorRegex.exec(filter[2]); //var m = filter[2].match(Web.DataView._filterRegex);
            var first = true;
            while (m && !(field.Index == field.AliasIndex && field.IsPrimaryKey && field.Hidden)) {
                if (!first)
                    sb.append(', ');
                else
                    sb.appendFormat('<span class="FilterElement" onclick="$find(\'{0}\').removeFromFilterByIndex({1})" title="{2}">', this.get_id(), field.Index, Web.DataView.htmlAttributeEncode(String.format(Web.DataViewResources.HeaderFilter.ClearFilter, field.Label)));

                if (m[1].startsWith('~'))
                    sb.appendFormat(String.format('{0} <b class="String">{1}</b>', Web.DataViewResources.InfoBar.QuickFind, this.convertStringToFieldValue(field, m[3])));
                else {
                    sb.appendFormat('<span class="Highlight">{0}</span>', aliasField.HeaderText);
                    var fd = this._findFilterDefByFunction(Web.DataViewResources.Data.Filters[field.FilterType].List, field.FilterType == 'Boolean' && m[3].length > 1 ? (m[3] == '%js%true' ? '$true' : '$false') : m[1]);
                    if (!fd) {
                        switch (m[1]) {
                            case '=':
                                sb.append(String.isJavaScriptNull(m[2]) ? Web.DataViewResources.InfoBar.Empty : Web.DataViewResources.InfoBar.EqualTo);
                                break;
                            case '<':
                                sb.append(Web.DataViewResources.InfoBar.LessThan);
                                break;
                            case '<=':
                                sb.append(Web.DataViewResources.InfoBar.LessThanOrEqual);
                                break;
                            case '>':
                                sb.append(Web.DataViewResources.InfoBar.GreaterThan);
                                break;
                            case '>=':
                                sb.append(Web.DataViewResources.InfoBar.GreaterThanOrEqual);
                                break;
                            case '*':
                                sb.append(m[2].startsWith('%') ? Web.DataViewResources.InfoBar.Like : Web.DataViewResources.InfoBar.StartsWith);
                                break;
                        }
                        var item = this._findItemByValue(field, this.convertStringToFieldValue(field, m[3]));
                        var v = item == null ? m[3] : item[1];
                        if (String.isJavaScriptNull(m[3]) || String.isBlank(v))
                            v = Web.DataViewResources.InfoBar.Empty;
                        else
                            v = this.convertStringToFieldValue(field, v);
                        sb.appendFormat('<b>{0}</b>', String.htmlEncode(v));
                    }
                    else if (fd.Prompt) {
                        sb.appendFormat(' {0} ', fd.Text.toLowerCase());
                        //item = m[1].match(/\$(in|notin|between)\$/) ? null : this._findItemByValue(field, this.convertStringToFieldValue(field, m[3]));
                        //v = m[3] : item[1];
                        v = m[3];
                        var values = v.split(Web.DataView._listRegex);
                        if (String.isJavaScriptNull(values[0])) values[0] = Web.DataViewResources.InfoBar.Empty;
                        if (!String.isJavaScriptNull(m[2])) {
                            var vm = values[0].match(/^([\s\S]+?)\0?$/);
                            if (vm) values[0] = vm[1];
                            v = this.convertStringToFieldValue(field, values[0]);
                            item = this._findItemByValue(field, v);
                            sb.appendFormat('<b>{0}</b>', String.htmlEncode(item ? item[1] : field.format(v)));
                            for (var j = 1; j < values.length; j++) {
                                sb.appendFormat('{0} ', m[1] == '$between$' ? ' ' + Web.DataViewResources.Data.Filters.Labels.And : ', ');
                                v = this.convertStringToFieldValue(field, values[j]);
                                if (v == null)
                                    v = Web.DataViewResources.HeaderFilter.EmptyValue;
                                else {
                                    item = this._findItemByValue(field, v);
                                    v = item ? item[1] : field.format(v);
                                }
                                sb.appendFormat('<b class="{1}">{0}</b>', String.htmlEncode(v));
                                if (j > 5) {
                                    sb.append(', ..');
                                    break;
                                }
                            }
                        }
                    }
                    else
                        sb.appendFormat(' {0} <b>{1}</b>', Web.DataViewResources.Data.Filters.Labels.Equals, fd.Function.match(Web.DataView._keepCapitalization) ? fd.Text : fd.Text.toLowerCase());
                }
                m = Web.DataView._filterIteratorRegex.exec(filter[2]);
                first = false;
            }
            if (!first)
                sb.append('.');
            sb.append('</span> ');
        }
        sb.append('</span>');
    },
    _findItemByValue: function (field, value) {
        var lov = field.DynamicItems ? field.DynamicItems : field.Items
        if (lov.length == 0) return null;
        value = value == null ? '' : value.toString();
        for (var i = 0; i < lov.length; i++) {
            var item = lov[i];
            var itemValue = item[0] == null ? "" : item[0].toString();
            if (itemValue == value)
                return item;
        }
        return [null, this.get_isForm() /* this.get_viewType() == 'Form'*/ ? Web.DataViewResources.Data.NullValueInForms : Web.DataViewResources.Data.NullValue];
    },
    _renderPager: function (sb, location) {
        if (this.get_showPager().indexOf(location) == -1) return;
        var isChart = this.get_isChart();
        sb.appendFormat('<tr class="FooterRow {2}PagerRow"><td colspan="{0}" class="Footer"><table cellpadding="0" cellspacing="0" style="width:100%"><tr><td align="left" class="Pager PageButtons{1}">', this._get_colSpan(), isChart ? ' Print' : '', location);
        var pageCount = this.get_pageCount();
        var pageSize = this.get_pageSize();
        if (isChart) {
            pageCount = 1;
            pageSize = this._totalRowCount;
            var printAction = this._get_specialAction('Print');
            if (printAction)
                sb.appendFormat('<a href="javascript:" onclick="{1};return false;" title="{0}" class="Print"><span></span></a></td><td>', printAction.text, printAction.script);
        }
        if (pageCount > 1) {
            var buttonIndex = this._firstPageButtonIndex;
            var pagerButtonCount = this.get_pagerButtonCount();
            var buttonCount = pagerButtonCount;
            if (this.get_pageIndex() > 0)
                sb.appendFormat('<a href="#" onclick="$find(\'{1}\').goToPage({0},true);return false" class="PaddedLink" tabindex="{3}">{2}</a>', this.get_pageIndex() - 1, this.get_id(), Web.DataViewResources.Pager.Previous, $nextTabIndex());
            else
                sb.appendFormat('<span class="Disabled">{0}</span>', Web.DataViewResources.Pager.Previous);
            sb.appendFormat(' | {0}: ', Web.DataViewResources.Pager.Page);
            if (buttonIndex > 0)
                sb.appendFormat('<a href="#" onclick="$find(\'{1}\').goToPage(0,true);return false" class="PaddedLink" tabindex="{2}">1</a><a href="#" onclick="$find(\'{1}\').goToPage({0},true);return false" class="PaddedLink" tabindex="{3}">...</a>', buttonIndex - 1, this.get_id(), $nextTabIndex(), $nextTabIndex());
            while (buttonCount > 0 && buttonIndex < pageCount) {
                if (buttonIndex == this.get_pageIndex())
                    sb.appendFormat('<span class="Selected">{0}</span>', buttonIndex + 1);
                else
                    sb.appendFormat('<a href="#" onclick="$find(\'{1}\').goToPage({0},true);return false" class="PaddedLink" tabindex="{3}">{2}</a>', buttonIndex, this.get_id(), buttonIndex + 1, $nextTabIndex());
                buttonIndex++;
                buttonCount--;
            }
            if (buttonIndex <= pageCount - 1)
                sb.appendFormat('<a href="#" onclick="$find(\'{1}\').goToPage({0},true);return false" class="PaddedLink" tabindex="{2}">...</a><a href="#" onclick="$find(\'{1}\').goToPage({3}-1,true);return false" class="PaddedLink" tabindex="{4}">{3}</a>', this._firstPageButtonIndex + pagerButtonCount, this.get_id(), $nextTabIndex(), pageCount, $nextTabIndex());
            sb.append(' | ');
            if (this.get_pageIndex() < pageCount - 1)
                sb.appendFormat('<a href="#" onclick="$find(\'{1}\').goToPage({0},true);return false" class="PaddedLink" tabindex="{3}">{2}</a>', this.get_pageIndex() + 1, this.get_id(), Web.DataViewResources.Pager.Next, $nextTabIndex());
            else
                sb.appendFormat('<span class="Disabled">{0}</span>', Web.DataViewResources.Pager.Next);
        }
        sb.append('</td><td align="right" class="Pager PageSize">&nbsp;');
        var showPageSize = this.get_showPageSize();
        var pageSizes = this._pageSizes;
        if (showPageSize && this._totalRowCount > pageSize) {
            sb.append(Web.DataViewResources.Pager.ItemsPerPage);
            for (i = 0; i < pageSizes.length; i++) {
                if (i > 0) sb.append(', ');
                if (pageSize == pageSizes[i])
                    sb.appendFormat('<b>{0}</b>', pageSize);
                else
                    sb.appendFormat('<a href="#" onclick="$find(\'{0}\').set_pageSize({1},true);return false" tabindex="{2}">{1}</a>', this.get_id(), pageSizes[i], $nextTabIndex());
            }
            sb.append(' | ');
        }
        if (this._totalRowCount > 0) {
            var lastVisibleItemIndex = (this.get_pageIndex() + 1) * pageSize;
            if (lastVisibleItemIndex > this._totalRowCount) lastVisibleItemIndex = this._totalRowCount;
            if (showPageSize)
                sb.appendFormat(Web.DataViewResources.Pager.ShowingItems, this.get_pageIndex() * pageSize + 1, lastVisibleItemIndex, this._totalRowCount);
            var multipleSelection = this.multiSelect();
            if (multipleSelection) {
                sb.appendFormat('<span id="{0}$SelectionInfo">', this.get_id());
                if (this._selectedKeyList.length > 0) sb.appendFormat(Web.DataViewResources.Pager.SelectionInfo, this._selectedKeyList.length);
                sb.append('</span>');
            }
            if (showPageSize || multipleSelection)
                sb.append(' | ');
        }
        sb.appendFormat('</td><td align="center" class="Pager Refresh" id="{0}_Wait">', this.get_id());
        if (!this.get_searchOnStart())
            sb.appendFormat('<a href="#" onclick="$find(\'{0}\').{3}();return false" tabindex="{2}" title="{1}"><span>&nbsp;</span></a>', this.get_id(), Web.DataViewResources.Pager.Refresh, $nextTabIndex(), this._hasSearchAction ? 'search' : 'sync');
        sb.append('</td></tr></table>');
        sb.append('</td></tr>');
    },
    refreshAndResize: function () {
        this.cancelDataSheetEdit();
        this.goToPage(-1);
        delete this._viewColumnSettings;
    },
    refreshData: function () {
        this._clearCache();
        this.set_pageIndex(-2);
        this._loadPage();
    },
    _dittoCollectedValues: function (newValues, fieldToIgnore) {
        if (this.get_isEditing()) {
            var ignoreRegex = fieldToIgnore ? new RegExp(String.format('^{0}(Length|ContentType|FileName|FullFileName)?$', fieldToIgnore)) : null;
            var values = this._collectFieldValues(true);
            var ditto = [];
            for (var i = 0; i < values.length; i++) {
                var v = values[i];
                if (!ignoreRegex || !v.Name.match(ignoreRegex))
                    Array.add(ditto, { 'name': v.Name, 'value': v.Modified ? v.NewValue : v.OldValue });
            }
            if (newValues) {
                for (i = 0; i < newValues.length; i++) {
                    v = newValues[i];
                    for (var j = 0; j < ditto.length; j++) {
                        var name = v.Name ? v.Name : v.name;
                        if (ditto[j].name == name) {
                            Array.removeAt(ditto, j);
                            break;
                        }
                    }
                    Array.add(ditto, v.Name ? { 'name': v.Name, 'value': v.NewValue} : v);
                }
            }
            this._ditto = ditto;
        }
    },
    refresh: function (noFetch, newValues, fieldToIgnore) {
        this._dittoCollectedValues(newValues, fieldToIgnore);
        this._lastSelectedCategoryTabIndex = this.get_categoryTabIndex();
        if (noFetch)
            this._render();
        else
            this.goToView(this.get_viewId());
    },
    //    _initContext: function () {
    //        if (this._context == null) {
    //            var c = $get('__COTSTATE'); // $get(this.get_id() + '$Context');//
    //            if (c && !String.isNullOrEmpty(c.value))
    //                this._context = Sys.Serialization.JavaScriptSerializer.deserialize(c.value);
    //            else
    //                this._context = {};
    //        }
    //    },
    //    _saveContext: function () {
    //        var c = $get('__COTSTATE'); // $get(this.get_id() + '$Context'); // 
    //        if (c)
    //            c.value = Sys.Serialization.JavaScriptSerializer.serialize(this._context);
    //    },
    _cname: function (name) {
        var viewId = this.get_viewId();
        if (viewId == null)
            viewId = 'grid1';
        return String.format('{0}${1}${2}', this._id, viewId, name);
    },
    readContext: function (name) {
        return Web.PageState.read(this._cname(name));
    },
    writeContext: function (name, value) {
        Web.PageState.write(this._cname(name), value);
    },
    _saveViewVitals: function () {
        this.writeContext('vitals', {
            'PageIndex': this.get_pageIndex(),
            'PageSize': this.get_pageSize(),
            'Filter': this.get_filter(),
            'SortExpression': this.get_sortExpression(),
            'Tag': this.get_tag()
        });
    },
    _restoreViewVitals: function (request) {
        if (request.PageIndex >= 0) return;
        var vitals = this.readContext('vitals');
        if (vitals == null) return;
        request.RequiresRowCount = true;
        request.RequiresMetaData = true;
        if (request.PageIndex == -1 && vitals.Filter && request.Filter) {
            request.Tag = vitals.Tag;
            request.PageIndex = vitals.PageIndex;
            request.PageSize = vitals.PageSize;
            if (request.FilterIsExternal) {
                var newFilter = request.Filter;
                for (var i = 0; i < vitals.Filter.length; i++) {
                    var lastFilterExpression = vitals.Filter[i];
                    var lastFilterExpressionFieldName = lastFilterExpression.substring(0, lastFilterExpression.indexOf(':'));
                    var found = false;
                    for (var j = 0; j < request.Filter.length; j++) {
                        var newFilterExpression = request.Filter[j];
                        var newExpressionFilterName = newFilterExpression.substring(0, newFilterExpression.indexOf(':'));
                        if (newExpressionFilterName == lastFilterExpressionFieldName) {
                            found = true;
                            break;
                        }
                    }
                    if (!found)
                        Array.add(newFilter, lastFilterExpression);
                }
                request.Filter = Array.clone(newFilter);
            }
            else
                if (request.Filter == null || request.Filter.length == 0)
                    request.Filter = Array.clone(vitals.Filter);
            request.SortExpression = vitals.SortExpression;
            if (!this.get_isDataSheet() || !this._get_focusedCell()) {
                var gridType = this.readContext('GridType');
                if (gridType != null)
                    this.changeViewType(gridType);
            }
        }
    },
    _useSearchParams: function (params) {
        var paramValues = this._paramValues;
        if (paramValues) {
            this._searchParamValues = paramValues;
            this._paramValues = null;
        }
        else
            paramValues = this._searchParamValues;
        if (paramValues) {
            var values = Array.clone(params.ExternalFilter);
            for (var i = 0; i < paramValues.length; i++) {
                var v = paramValues[i];
                Array.add(values, { Name: v.Name, Value: v.NewValue });
            }
            params.ExternalFilter = values;
        }
    },
    _forceSync: function () {
        if (this._skipSync)
            this._skipSync = false;
        else
            this._syncKey = this.get_selectedKey();
    },
    sync: function (keyValues) {
        this._clearCache();
        if (keyValues != null) {
            if (!Array.isInstanceOfType(keyValues))
                keyValues = [keyValues];
            var row = [];
            for (var i = 0; i < this._keyFields.length; i++) {
                var f = this._keyFields[i];
                row[this._keyFields[i].Index] = keyValues[i];
            }
            this._raiseSelectedDelayed = true;
            this._pendingSelectedEvent = true
            this._selectKeyByRow(row);
        }
        this._forceSync()
        this.refreshAndResize();
        this._synced = true;
    },
    _sync: function () {
        var settings = this._viewColumnSettings;
        this._viewColumnSettings = [];
        this.sync();
        this._viewColumnSettings = settings;
    },
    _createParams: function (filterByPosition) {
        var lc = this.get_lookupContext();
        var viewType = this.get_viewType();
        if (String.isNullOrEmpty(viewType))
            viewType = this.readContext('GridType');
        var extension = this.extension();
        var params = {
            PageIndex: this.get_pageIndex(), PageSize: this.get_pageSize(), PageOffset: this.get_pageOffset(), SortExpression: this.get_sortExpression(),
            Filter: this.get_filter(), ContextKey: this.get_id(), Cookie: this.get_cookie(), FilterIsExternal: this._externalFilter.length > 0,
            LookupContextFieldName: lc ? lc.FieldName : null, LookupContextController: lc ? lc.Controller : null, LookupContextView: lc ? lc.View : null,
            LookupContext: lc, Inserting: this.get_isInserting(), LastCommandName: this.get_lastCommandName(), LastCommandArgument: this.get_lastCommandArgument(),
            /*SelectedValues: this.get_selectedValues(),*/ExternalFilter: this.get_externalFilter(), Transaction: this.get_transaction(),
            DoesNotRequireData: this.get_searchOnStart(), LastView: this.get_lastViewId(), Tag: this.get_tag(), RequiresFirstLetters: this.get_showFirstLetters(),
            ViewType: viewType, SupportsCaching: Sys.Browser.agent != Sys.Browser.InternetExplorer || Sys.Browser.version > 7,
            SystemFilter: extension ? extension.systemFilter() : null, RequiresRowCount: this._requiresRowCount == true
        };
        var confirmContext = this.get_confirmContext();
        if (confirmContext) {
            var values = Array.clone(params.ExternalFilter);
            Array.addRange(values, confirmContext.Values);
            params.ExternalFilter = values;
        }
        this._useSearchParams(params);
        if (this._position) {
            if (this._position.changing) {
                params.PageIndex = this._position.index;
                params.PageSize = 1;
                params.Filter = this._position.filter;
                params.SortExpression = this._position.sortExpression;
                params.RequiresMetaData = true;
            }
            if (filterByPosition)
                params.Filter = this._selectedKeyFilter;
        }
        // assign syncKey and clear them up
        params.SyncKey = this._syncKey;
        if (this._syncKey)
            this._syncKey = null;
        return params;
    },
    _createArguments: function (args, view, values) {
        if (!values)
            values = this._collectFieldValues();
        if (!view)
            view = this.get_viewId();
        if (args.values)
            values = Array.clone(args.values);
        if (this._paramValues) {
            values = Array.clone(values);
            Array.addRange(values, this._paramValues);
            delete this._paramVlaues;
        }
        var actionArgs = {
            CommandName: args.commandName, CommandArgument: args.commandArgument, Path: args.path, LastCommandName: this.get_lastCommandName(), Values:
            values, ContextKey: this.get_id(), Cookie: this.get_cookie(), Controller: this.get_controller(), View: view, LastView: this.get_lastViewId(), Tag: this.get_tag(), Trigger: args.trigger
        };
        actionArgs.Filter = this.get_filter();
        actionArgs.SortExpression = this.get_sortExpression();
        actionArgs.SelectedValues = this.get_selectedValues();
        actionArgs.ExternalFilter = Array.clone(this.get_externalFilter());
        actionArgs.Transaction = this.get_transaction();
        if (args.commandName == 'PopulateDynamicLookups')
            for (var i = 0; i < this._allFields.length; i++) {
                var contextFilter = this.get_contextFilter(this._allFields[i], values);
                if (contextFilter.length > 0)
                    Array.addRange(actionArgs.ExternalFilter, contextFilter);
            }
        if (!String.isNullOrEmpty(actionArgs.Transaction) && !this.get_isModal() && !this.get_filterSource() && actionArgs.CommandName.match(/Insert|Update|Delete/))
            actionArgs.Transaction += ':complete';
        actionArgs.SaveLEVs = this._allowLEVs == true;
        return actionArgs;
    },
    _loadPage: function () {
        if (this._isBusy)
            this._cancelWSRequest();
        this._delayedLoading = false;
        if (this._source) return;
        if (this.get_mode() != Web.DataViewMode.View) {
            this._allFields = [{ Index: 0, Label: '', DataFormatString: '', AliasIndex: 0, ItemsDataController: this.get_controller(), ItemsNewDataView: this.get_newViewId(), ItemsDataView: this.get_viewId(), _dataView: this, Behaviors: [], format: _field_format, isReadOnly: _field_isReadOnly, isNumber: _field_isNumber}];
            this._fields = this._allFields;
            this._render();
        }
        else {
            this._busy(true);
            this._detachBehaviors();
            this._showWait();
            var r = this._createParams();
            this._restoreViewVitals(r);
            var pageArgs = { controller: this.get_controller(), view: this.get_viewId(), request: r };
            var rules = new Web.BusinessRules(this);
            rules.before({ commandName: 'Select', commandArgument: pageArgs.view });
            rules.dispose();
            this._invoke('GetPage', pageArgs, Function.createDelegate(this, this._onGetPageComplete));
        }
    },
    _cancelWSRequest: function () {
        var webServiceRequest = this._wsRequest;
        if (webServiceRequest) {
            this._wsRequest = null;
            if (webServiceRequest.get_executor && !webServiceRequest.completed())
                webServiceRequest.get_executor().abort();
        }
    },
    _invoke: function (methodName, params, onSuccess, userContext) {
        var that = this;
        this._autoRefresh(true);
        var servicePath = this.get_servicePath();
        if (servicePath.startsWith('http')) {
            switch (methodName) {
                case 'GetPage':
                case 'GetListOfValues':
                    params.request.Controller = params.controller;
                    params.request.View = params.view;
                    params = params.request;
                    break;
                case 'Execute':
                    params = params.args;
                    break;
            }
            $.ajax({
                url: this.get_baseUrl() + 'appservices/_invoke',
                type: 'GET',
                cache: false,
                data: { method: methodName, args: Sys.Serialization.JavaScriptSerializer.serialize(params) },
                dataType: 'jsonp',
                success: function (result) {
                    onSuccess(result, userContext);
                },
                error: function (e) {
                    that._onMethodFailed(e.message, e.response, userContext);
                }
            });
        }
        else
            this._wsRequest = Sys.Net.WebServiceProxy.invoke(this.get_servicePath(), methodName, false, params, onSuccess, Function.createDelegate(this, this._onMethodFailed), userContext);
    },
    _disposeFields: function () {
        if (this._allFields) {
            for (var i = 0; i < this._allFields.length; i++) {
                var f = this._allFields[i];
                f._dataView = null;
                if (f._listOfValues) Array.clear(f._listOfValues);
            }
        }
    },
    _formatViewText: function (text, lowerCase, altText) {
        var vl = this._views.length > 0 ? this._views[0].Label : (this._view ? this._view.Label : '');
        return !String.isNullOrEmpty(text) ? String.format(text, lowerCase == true ? vl.toLowerCase() : vl) : altText;
    },
    _autoRefresh: function (stop) {
        if (this._refreshInterval > 0) {
            if (this._riTimeout) {
                clearTimeout(this._riTimeout);
                this._riTimeout = null;
            }
            if (!stop) {
                var self = this;
                this._riTimeout = setTimeout(function () {
                    if (!self.get_isForm())
                        self.sync();
                }, this._refreshInterval * 1000);
            }
        }
    },
    _clearCache: function (reset) {
        var cachedPages = this._cachedPages;
        if (cachedPages) {
            for (var i = 0; i < cachedPages.length; i++) {
                var p = cachedPages[i];
                Array.clear(p.rows);
                delete p.rows;
            }
            Array.clear(cachedPages);
            delete this._cachedPages;
        }
        var extension = this.extension();
        if (extension)
            extension.reset(reset == null || reset == true);
    },
    _supportsCaching: function (viewType) {
        return viewType == 'DataSheet' || viewType == 'Grid' && $appfactory.mobile; ;
    },
    _cacheResult: function (result) {
        var pageSize = result.PageSize;
        var doCaching = result.PageSize < result.Rows.length;
        var viewType = this.get_viewType();
        if (!doCaching && !viewType)
            viewType = this.readContext('GridType');
        if (!doCaching)
            doCaching = this._supportsCaching(viewType);
        if (!doCaching && !viewType && result.Views)
            for (var i = 0; i < result.Views.length; i++) {
                var v = result.Views[i];
                if (v.Id == result.View) {
                    doCaching = this._supportsCaching(v.Type);
                    break;
                }
            }

        if (doCaching && result.SupportsCaching) {
            var rows = result.Rows;
            result.Rows = [];
            var cachedPages = this._cachedPages;
            if (!cachedPages)
                cachedPages = this._cachedPages = [];
            var pageIndex = result.PageIndex;
            var startIndex = 0;
            var endIndex = pageSize - 1;
            if (pageIndex > 0)
                if (rows.length <= pageSize * 2) {
                    startIndex = pageSize;
                    endIndex = rows.length - 1;
                }
                else {
                    startIndex += pageSize;
                    endIndex += pageSize;
                }
            // copy the request page back to the result 
            var page = { index: pageIndex, rows: [] };
            for (i = startIndex; i <= endIndex; i++) {
                var r = rows[i];
                if (r) {
                    Array.add(result.Rows, Array.clone(r));
                    Array.add(page.rows, r);
                }
            }
            // cache the previous page
            var prevPage = null;
            if (startIndex > 0) {
                prevPage = { index: pageIndex - 1, rows: [] };
                for (i = 0; i < startIndex; i++)
                    Array.add(prevPage.rows, rows[i]);
            }
            // cache the next page
            var nextPage = null;
            if (endIndex < rows.length - 1) {
                nextPage = { index: pageIndex + 1, rows: [] };
                for (i = endIndex + 1; i < rows.length; i++)
                    Array.add(nextPage.rows, rows[i]);
            }
            i = 0;
            while (i < cachedPages.length) {
                var p = cachedPages[i];
                if (page != null && p.index == page.index) {
                    cachedPages[i] = page;
                    page = null;
                }
                else if (prevPage != null && p.index == prevPage.index) {
                    cachedPages[i] = prevPage;
                    prevPage = null;
                }
                else if (nextPage != null && p.index == nextPage.index) {
                    cachedPages[i] = nextPage;
                    nextPage = null;
                }
                else
                    i++;
            }
            if (page || prevPage || nextPage) {
                if (cachedPages.length > 100) {
                    Array.removeAt(cachedPages, 0);
                    Array.removeAt(cachedPages, 0);
                    Array.removeAt(cachedPages, 0);
                }
                if (page)
                    Array.add(cachedPages, page);
                if (prevPage)
                    Array.add(cachedPages, prevPage);
                if (nextPage)
                    Array.add(cachedPages, nextPage);
            }
        }
    },
    _onGetPageComplete: function (result, context) {
        this._busy(false);
        if (Sys.Services && Sys.Services.AuthenticationService && Sys.Services.AuthenticationService.get_isLoggedIn && Sys.Services.AuthenticationService.get_isLoggedIn() && !result.IsAuthenticated) {
            //window.location.reload();
            location.replace($appfactory.unanchor(location.href));
            return;
        }
        if (this._containerIsHidden) {
            Sys.UI.DomElement.setVisible(this._container, true);
            this._containerIsHidden = false;
        }
        this.set_tag(result.Tag);
        if (result.FirstLetters != '')
            this._firstLetters = result.FirstLetters ? result.FirstLetters.split(/,/) : null;
        var positionChanged = this._position && this._position.changed;
        this._cacheResult(result);
        if (this._pageIndex < 0 || positionChanged) {
            if (this._pageIndex == -1 || positionChanged) {
                this._disposeFields();
                this._expressions = result.Expressions;
                this._detachBehaviors();
                this._allFields = result.Fields;
                this._fields = [];
                var selectedKeyMap = [];
                if (this._keyFields && this._selectedKey.length > 0) {
                    for (var i = 0; i < this._keyFields.length; i++)
                        selectedKeyMap[i] = { 'name': this._keyFields[i].Name, 'value': this._selectedKey[i] };
                    this._selectedKey = [];
                }
                this._keyFields = [];
                var hasStatusField = false;
                //            if (FindField("Status") == null)
                //            {
                //                DataField field = new DataField();
                //                field.Name = "Status";
                //                field.ReadOnly = true;
                //                field.Type = "String";
                //                field.AllowNulls = true;
                //                field.Hidden = true;
                //                Fields.Add(field);
                //            }                
                for (i = 0; i < result.Fields.length; i++) {
                    var field = result.Fields[i];
                    field.Index = i;
                    if (field.Name == 'Status')
                        hasStatusField = true;
                }
                if (!hasStatusField)
                    result.Fields[result.Fields.length] = { 'Name': 'Status', 'ReadOnly': true, 'Type': 'String', 'AllowNulls': true, 'Hidden': true, 'Index': result.Fields.length, '_system': true };
                var displayFieldList = Web.DataView._commandLine.match(/\W_display=(.+?)(&|$)/);
                for (i = 0; i < result.Fields.length; i++) {
                    field = result.Fields[i];
                    var fa = !String.isNullOrEmpty(field.AliasName) ? this.findField(field.AliasName) : null;
                    field.AliasIndex = fa ? fa.Index : i;
                    if ((!field.Hidden || displayFieldList) && this._fieldIsInExternalFilter(field) && this.get_hideExternalFilterFields()) {
                        var isHidden = field.Hidden;
                        field.Hidden = true;
                        if (displayFieldList && Array.indexOfCaseInsensitive(displayFieldList[1].split(','), field.Name) != -1) {
                            if (!isHidden)
                                field.Hidden = false;
                            if (this.get_isInserting()) {
                                var valueRegex = new RegExp(String.format('\\W{0}=(.*?)(&|$)', field.Name));
                                var valueMatch = Web.DataView._commandLine.match(valueRegex);
                                if (valueMatch) {
                                    if (!result.NewRow)
                                        result.NewRow = [];
                                    result.NewRow[i] = decodeURIComponent(valueMatch[1]);
                                }
                            }
                        }
                    }
                    if (!String.isNullOrEmpty(field.ToolTip))
                        field.ToolTip = Web.DataView.htmlAttributeEncode(field.ToolTip);
                    field.Behaviors = [];
                }
                if (result.NewRow && this._ditto)
                    for (i = 0; i < result.Fields.length; i++) {
                        field = result.Fields[i];
                        if (result.NewRow[i] != null)
                            for (var j = 0; j < this._ditto.length; j++)
                                if (this._ditto[j].name == field.Name) {
                                    Array.removeAt(this._ditto, j);
                                    break;
                                }
                    }
                this._hasDynamicLookups = false;
                this._requiresConfiguration = false;
                var colIndex = 0;
                for (i = 0; i < result.Fields.length; i++) {
                    field = result.Fields[i];
                    field._dataView = this;
                    if (!field.Hidden) Array.add(this._fields, field);
                    if (field.IsPrimaryKey) {
                        Array.add(this._keyFields, field);
                        for (j = 0; j < selectedKeyMap.length; j++) {
                            if (selectedKeyMap[j].name == field.Name) {
                                Array.add(this._selectedKey, selectedKeyMap[j].value);
                                break;
                            }
                        }
                    }
                    if (String.isNullOrEmpty(field.HeaderText)) field.HeaderText = field.Label;
                    if (String.isNullOrEmpty(field.HeaderText)) field.HeaderText = field.Name;
                    field.FilterType = 'Number';
                    switch (field.Type) {
                        case 'Time':
                        case 'String':
                            field.FilterType = 'Text';
                            break;
                        case 'DateTime':
                        case 'DateTimeOffset':
                            field.FilterType = 'Date';
                            break;
                        case 'Boolean':
                            field.FilterType = 'Boolean'
                            break;
                    }
                    if (!String.isBlank(field.SearchOptions) && !(__tf != 4)) {
                        var searchOptions = field.SearchOptions.replace(/\s+/g, ',').split(/,/);
                        field.AllowAutoComplete = !Array.contains(searchOptions, '$disableautocomplete');
                        if (!field.AllowAutoComplete)
                            Array.remove(searchOptions, '$disableautocomplete');
                        field.AllowSamples = !Array.contains(searchOptions, '$disablesamples');
                        if (!field.AllowSamples)
                            Array.remove(searchOptions, '$disablesamples');
                        field.AllowMultipleValues = !Array.contains(searchOptions, '$disablemultiplevalues');
                        if (!field.AllowMultipleValues)
                            Array.remove(searchOptions, '$disablemultiplevalues');
                        field.AutoCompleteAnywhere = Array.contains(searchOptions, '$autocompleteanywhere');
                        if (field.AutoCompleteAnywhere) {
                            Array.remove(searchOptions, '$autocompleteanywhere');
                            result.Fields[field.AliasIndex].AutoCompleteAnywhere = true;
                        }
                        j = 0;
                        var includeMissingOptions = false;
                        while (j < searchOptions.length) {
                            var so = searchOptions[j] = searchOptions[j].trim();
                            if (so == '*')
                                includeMissingOptions = true;
                            if (so.length > 0 && so != '*')
                                j++;
                            else
                                Array.removeAt(searchOptions, j);
                        }
                        if (includeMissingOptions && searchOptions.length > 0) {
                            var filterDef = Web.DataViewResources.Data.Filters[field.FilterType]
                            this._enumerateMissingSearchOptions(searchOptions, filterDef.List);
                        }
                        if (Array.contains(searchOptions, '$in') && !Array.contains(searchOptions, '$notin'))
                            Array.add(searchOptions, '$notin');
                        field.SearchOptions = searchOptions.length == 0 ? null : searchOptions;
                    }
                    else
                        field.SearchOptions = null;
                    field.format = _field_format;
                    field.isReadOnly = _field_isReadOnly;
                    field.isNumber = _field_isNumber;
                    field.text = _field_text;
                    field.tagged = function () {
                        var tag = this.Tag;
                        if (tag)
                            for (var i = 0; i < arguments.length; i++)
                                if (tag.indexOf(arguments[i]) >= 0)
                                    return true;
                        return false;
                    }
                    if (field.DataFormatString && field.DataFormatString.indexOf('{') == -1) field.DataFormatString = '{0:' + field.DataFormatString + '}';
                    if (field.DataFormatString) field.DataFormatString = this.resolveClientUrl(field.DataFormatString);
                    if (field.Type.startsWith('DateTime')) {
                        if (!field.DataFormatString) field.DataFormatString = '{0:d}';
                        else {
                            m = field.DataFormatString.match(/{0:(g)}/i);
                            if (m) {
                                var dtf = Sys.CultureInfo.CurrentCulture.dateTimeFormat;
                                field.DateFmtStr = '{0:' + dtf.ShortDatePattern + '}';
                                field.TimeFmtStr = '{0:' + (m[1] == 'g' ? dtf.ShortTimePattern : dtf.LongTimePattern) + '}';
                            }
                            var fmt = Web.DataView.dateFormatStrings[field.DataFormatString];
                            if (fmt) field.DataFormatString = '{0:' + fmt + '}';
                            if (field.DateFmtStr)
                                field.DataFmtStr = field.DataFormatString;
                        }
                    }
                    if (field.Type == 'Boolean' && field.Items.length == 0) {
                        field.Items = Array.clone(field.AllowNulls ? Web.DataViewResources.Data.BooleanOptionalDefaultItems : Web.DataViewResources.Data.BooleanDefaultItems);
                        if (!field.ItemsStyle) field.ItemsStyle = Web.DataViewResources.Data.BooleanDefaultStyle;
                    }
                    if (field.Items && field.Items.length > 0 && (field.AllowNulls || field.ItemsStyle == 'DropDownList') && !String.isNullOrEmpty(field.Items[0][0]) && field.ItemsStyle != 'CheckBoxList')
                        Array.insert(field.Items, 0, [null, Web.DataViewResources.Data.NullValueInForms]);
                    if (!String.isNullOrEmpty(field.ItemsStyle))
                        if (!String.isNullOrEmpty(field.ContextFields) && field.ItemsStyle != 'Lookup' && field.ItemsStyle != 'AutoComplete' && !String.isNullOrEmpty(field.ItemsDataController)) {
                            this._hasDynamicLookups = true;
                            field.ItemsAreDynamic = true;
                        }
                        else if (field.ItemsStyle == 'UserNameLookup') {
                            field.ItemsStyle = 'Lookup';
                            field.ItemsDataController = 'aspnet_Membership';
                            field.ItemsDataTextField = 'UserName';
                            field.ItemsDataValueField = 'UserUserName';
                            if (Web.Menu.findNode('/Membership.aspx'))
                                field.ItemsNewDataView = 'createForm1';
                        }
                        else if (field.ItemsStyle == 'UserIdLookup') {
                            field.ItemsStyle = 'Lookup';
                            field.ItemsDataController = 'aspnet_Membership';
                            field.ItemsDataTextField = 'UserUserName';
                            field.ItemsDataValueField = 'UserId';
                            if (Web.Menu.findNode('/Membership.aspx'))
                                field.ItemsNewDataView = 'createForm1';
                        }
                    if (!String.isNullOrEmpty(field.Configuration))
                        this._requiresConfiguration = true;
                    if (field.AllowLEV) this._allowLEVs = true;
                    if (field.TextMode == 2 && String.isNullOrEmpty(field.Editor) && !$appfactory.mobile) {
                        if (Sys.Extended.UI.HtmlEditorExtenderBehavior || typeof CKEDITOR != 'undefined')
                            field.ClientEditor = 'Web$DataView$RichText';
                        else
                            field.Editor = 'RichEditor';
                        field.HtmlEncode = false;
                    }

                    if (field.Editor)
                        if (this._executeClientEditorFactories(field)) {
                            field.ClientEditor = field.Editor;
                            field.Editor = null;
                        }
                        else
                            field.EditorId = String.format('{0}_Item{1}', this.get_id(), field.Index);
                    field.ColIndex = !field.Hidden ? colIndex++ : -1;
                    var wdvg = Web.DataView.Geo;
                    if (field.tagged('modified-', 'created-') && field.tagged('modified-latitude', 'modified-longitude', 'modified-coords', 'created-latitude', 'created-longitude', 'created-coords')) {
                        if (!wdvg || wdvg.latitude < 0) {
                            wdvg = Web.DataView.Geo = { latitude: -1, longitude: -1 };
                            var geolocation = navigator.geolocation;
                            if (geolocation)
                                geolocation.watchPosition(function (position) {
                                    wdvg.latitude = position.coords.latitude;
                                    wdvg.longitude = position.coords.longitude;
                                },
                            function (error) {
                                wdvg.error = error;
                            });
                        }
                        field.TextMode = 4;
                    }
                }
                if (result.LEVs) this._recordLEVs(result.LEVs);
                this._views = result.Views;
                this._view = null;
                if (!this._lastViewId && !this.get_isForm()/* this.get_view().Type != 'Form'*/)
                    this._lastViewId = result.View;
                this._actionGroups = result.ActionGroups ? result.ActionGroups : [];
                this._statusBar = result.StatusBar;
                var whenTest = /^(true|false)\:(.+)$/;
                this._actionColumn = null;
                for (i = 0; i < this._actionGroups.length; i++) {
                    var ag = this._actionGroups[i];
                    //if (ag.Scope == 'Grid' && this.get_isTree())
                    //    Array.insert(ag.Actions, 0, { 'CommandName': 'Open' });
                    var agt = Web.DataViewResources.Actions.Scopes[ag.Scope];
                    if (agt._Self) {
                        var ast = agt._Self[ag.HeaderText];
                        if (ast) ag.HeaderText = ast.HeaderText;
                    }
                    if (ag.Scope == 'ActionColumn')
                        this._actionColumn = !String.isNullOrEmpty(ag.HeaderText) ? ag.HeaderText : Web.DataViewResources.Grid.ActionColumnHeaderText;
                    ag.CssClassEx = String.format('Actions-g-{0} ', ag.Id);
                    for (j = 0; j < ag.Actions.length; j++) {
                        var action = ag.Actions[j];
                        action.Path = String.format('{0}/{1}', ag.Id, action.Id);
                        var confirmation = action.Confirmation;
                        if (action.CommandName == 'Search') {
                            this._hasSearchAction = action.Path;
                            this._hasSearchShortcut = confirmation && confirmation.match(/_shortcut\s*=\s*true/);
                        }
                        action.CssClassEx = String.format('Actions-g-{0}-a-{1} ', ag.Id, action.Id);
                        if (String.isNullOrEmpty(action.HeaderText)) {
                            var at = agt[action.CommandName];
                            if (at) {
                                if (at.CommandArgument) {
                                    var at2 = at.CommandArgument[action.CommandArgument];
                                    if (at2) at = at2;
                                }
                                if (at.WhenLastCommandName) {
                                    at2 = at.WhenLastCommandName[action.WhenLastCommandName];
                                    if (at2) at = at2;
                                }
                                action.HeaderText = at.HeaderText;
                                if (!String.isNullOrEmpty(at.HeaderText) && at.HeaderText.indexOf('{') >= 0)
                                    action.HeaderText = at.VarMaxLen != null && result.Views[0].Label.length > at.VarMaxLen ? at.HeaderText2 : this._formatViewText(at.HeaderText);
                                if (String.isNullOrEmpty(action.Description))
                                    action.Description = this._formatViewText(at.Description);
                                if (String.isNullOrEmpty(confirmation))
                                    action.Confirmation = at.Confirmation;
                            }
                            else
                                action.HeaderText = action.CommandName;
                        }
                        if (String.isNullOrEmpty(action.WhenView))
                            action.WhenViewRegex = null;
                        else {
                            var m = whenTest.exec(action.WhenView);
                            action.WhenViewRegex = new RegExp(m ? m[2] : action.WhenView);
                            action.WhenViewRegexResult = m ? m[1] != 'false' : true;
                        }
                        if (String.isNullOrEmpty(action.WhenTag))
                            action.WhenTagRegex = null;
                        else {
                            m = whenTest.exec(action.WhenTag);
                            action.WhenTagRegex = new RegExp(m ? m[2] : action.WhenTag);
                            action.WhenTagRegexResult = m ? m[1] != 'false' : true;
                        }
                        if (String.isNullOrEmpty(action.WhenHRef))
                            action.WhenHRefRegex = null;
                        else {
                            m = whenTest.exec(action.WhenHRef);
                            action.WhenHRefRegex = new RegExp(m ? m[2] : action.WhenHRef);
                            action.WhenHRefRegexResult = m ? m[1] != 'false' : true;
                        }
                    }
                }
                var numberOfColumns = 1;
                var hasColumns = false;
                var categories = this._categories = result.Categories;
                this._tabs = [];
                for (i = 0; i < categories.length; i++) {
                    var c = categories[i];
                    c.Index = i;
                    if (!String.isNullOrEmpty(c.Tab) && !Array.contains(this._tabs, c.Tab))
                        Array.add(this._tabs, c.Tab);
                    if (c.NewColumn) {
                        if (i > 0) numberOfColumns++;
                        hasColumns = true;
                    }
                    c.ColumnIndex = numberOfColumns - 1;
                    if (c.Id) {
                        var t = $get(String.format('{0}_{1}_{2}', result.Controller, result.View, c.Id));
                        if (t)
                            c.Template = t.innerHTML;
                    }
                    if (c.Floating && String.isNullOrEmpty(c.Template)) {
                        var sb = new Sys.StringBuilder('<div class="FloatingCategoryHeader"></div>');
                        for (j = 0; j < this._allFields.length; j++) {
                            var f = this._allFields[j];
                            if (!f.Hidden && i == f.CategoryIndex)
                                sb.appendFormat('<div class="FieldPlaceholder">{{{0}}}</div>', f.Name);
                        }
                        c.Template = sb.toString();
                    }
                }
                if (this._tabs.length > 0) {
                    for (i = 0; i < categories.length; i++) {
                        c = categories[i];
                        if (String.isNullOrEmpty(c.Tab)) {
                            if (!String.isNullOrEmpty(categories[0].Tab))
                                c.Tab = categories[0].Tab;
                            else {
                                c.Tab = Web.DataViewResources.Form.GeneralTabText;
                                if (this._tabs[0] != Web.DataViewResources.Form.GeneralTabText)
                                    Array.insert(this._tabs, 0, Web.DataViewResources.Form.GeneralTabText);
                            }
                        }
                        c.ColumnIndex = 0;
                    }
                    if (this._lastSelectedCategoryTabIndex != null) {
                        var focusedFieldName = this._focusedFieldName;
                        this.set_categoryTabIndex(!(this._lastSelectedCategoryTabIndex >= 0) || focusedFieldName && focusedFieldName.startsWith('_Annotation_') ? this._tabs.length - 1 : 0);
                        delete this._lastSelectedCategoryTabIndex;
                    }
                    else
                        this.set_categoryTabIndex(0);
                    var iconDataView = this.get_parentDataView(this); // this._parentDataViewId ? Web.DataView.find(this._parentDataViewId) : this;
                    if (iconDataView._lastClickedIcon == 'Attachment')
                        this.set_categoryTabIndex(this._tabs.length - 1);
                    iconDataView._lastClickedIcon = null;
                    numberOfColumns = 1;
                }
                else
                    this.set_categoryTabIndex(-1);
                this._numberOfColumns = hasColumns && !this._get_template() ? numberOfColumns : 0;
            }
            this._filter = result.Filter;
            this._sortExpression = result.SortExpression;
            //this._totalRowCount = result.TotalRowCount;
            //if (this._position && this._position.count == -1)
            //    this._position.count = result.TotalRowCount;
            //this._pageIndex = result.PageIndex;
            //if (!positionChanged) {
            //    this._pageSize = result.PageSize;
            //    this._pageCount = Math.floor(result.TotalRowCount / result.PageSize);
            //    if (result.TotalRowCount % result.PageSize != 0)
            //        this._pageCount++;
            //}
            this._updatePageCount(result, positionChanged);
            var pagerButtonCount = this.get_pagerButtonCount(true);
            this._firstPageButtonIndex = Math.floor(result.PageIndex / pagerButtonCount) * pagerButtonCount;
        }
        else if (this._requiresRowCount) {
            this._requiresRowCount = false;
            this._updatePageCount(result, false);
        }
        for (i = 0; i < result.Fields.length; i++) {
            field = result.Fields[i];
            var aliasField = result.Fields[field.AliasIndex];
            if (field.AllowAutoComplete == false)
                aliasField.AllowAutoComplete = false;
            if (field.AllowSamples == false)
                aliasField.AllowSamples = false;
            if (field.AllowMultipleValues == false)
                aliasField.AllowMultipleValues = false;
        }
        this._icons = result.Icons;
        if (!this.get_isInserting()) {
            var identifySelectedRow = false;
            if (this._rows) {
                if (this._rows.length == 0 || result.Rows.length == 0)
                    delete this._viewColumnSettings;
                for (i = 0; i < this._rows.length; i++)
                    Array.clear(this._rows[i]);
                Array.clear(this._rows);
                identifySelectedRow = this.get_isGrid();
            }
            this._rows = result.Rows;
            if (identifySelectedRow) {
                this._selectedRowIndex = null;
                for (i = 0; i < this._rows.length; i++)
                    if (this._rowIsSelected(i)) {
                        this._selectedRowIndex = i;
                        break;
                    }
            }
        }
        this._newRow = result.NewRow ? result.NewRow : [];
        if (result.Aggregates) this._aggregates = result.Aggregates;
        if (this.get_isForm()/* this.get_view().Type == 'Form'*/ && this._selectedRowIndex == null && this._totalRowCount > 0) {
            this._selectedRowIndex = 0;
            this._selectKeyByRowIndex(0);
        }
        //        if (this.get_startCommandName()) {
        //            var command = this.get_startCommandName();
        //            var argument = this.get_startCommandArgument();
        //            this.set_startCommandName(null);
        //            this.set_startCommandArgument(null);
        //            this.executeCommand({ commandName: command, commandArgument: argument ? argument : '' });
        //            if (this._skipRender) {
        //                this._skiprender = false;
        //                return;
        //            }
        //        }
        if (positionChanged) {
            this._position.changed = true;
            this._selectKeyByRowIndex(0);
        }
        this._render(true);
        if (!$appfactory.mobile) {
            //        if (this.get_modalAnchor())
            //            this._adjustModalPopupSize();
            //        else
            //            this._adjustLookupSize();
            if (this.get_lookupField())
                this._adjustLookupSize();
            if (this._isInInstantDetailsMode()) {
                var size = $common.getClientBounds();
                var contentSize = $common.getContentSize(document.body);
                resizeBy(0, contentSize.height - size.height);
            }
            this._saveViewVitals();
            if (this._pendingSelectedEvent) {
                this._pendingSelectedEvent = false;
                this.updateSummary();
            }
            this._registerFieldHeaderItems();
            _body_performResize();
        }
        this._executeSecondCommand();
        this._autoRefresh();
        this._autoSelect();
        if (!String.isNullOrEmpty(result.ClientScript))
            eval(result.ClientScript);
        var rules = new Web.BusinessRules(this);
        rules.after({ commandName: result.NewRow ? 'New' : 'Select', commandArgument: result.View });
        rules.dispose();
    },
    _updatePageCount: function (result, positionChanged) {
        this._totalRowCount = result.TotalRowCount;
        if (this._position && this._position.count == -1)
            this._position.count = result.TotalRowCount;
        this._pageIndex = result.PageIndex;
        if (!positionChanged) {
            this._pageSize = result.PageSize;
            this._pageCount = Math.floor(result.TotalRowCount / result.PageSize);
            if (result.TotalRowCount % result.PageSize != 0)
                this._pageCount++;
        }
    },
    _autoSelect: function (rowIndex) {
        var commandName = null,
            commandArgument = null,
            tapAction,
            hideContainer = false;
        if (this.get_autoHighlightFirstRow()) {
            this.set_autoHighlightFirstRow(false);
            commandName = 'Select';
            tapAction = 'highlight';
        }
        if (this.get_autoSelectFirstRow()) {
            this.set_autoSelectFirstRow(false);
            tapAction = 'select';
            var groups = this.get_actionGroups('Grid');
            if (groups.length > 0)
                for (var i = 0; i < groups[0].Actions.length; i++) {
                    var a = groups[0].Actions[i];
                    if (a.CommandName) {
                        commandName = a.CommandName;
                        commandArgument = a.CommandArgument;
                        hideContainer = !String.isNullOrEmpty(commandArgument) & !this.get_showModalForms() && rowIndex == null;
                        break;
                    }
                }
        }
        if (commandName && this.get_viewType() != 'Form' && this._rows.length > 0) {
            if (hideContainer)
                this._hideContainer();
            var extension = this.extension();
            if (extension && extension.tap)
                extension.tap(this._rows[rowIndex || 0], tapAction);
            else
                this.executeRowCommand(rowIndex || 0, commandName, commandArgument);
        }
        if (!this._tryFocusDataSheet || this._forceFocusDataSheet) {
            this._tryFocusDataSheet = true;
            if (this.get_isDataSheet() && !this.get_lookupField() & (!this.get_filterSource() || this._forceFocusDataSheet) && this._rows.length > 0 && !$appfactory.mobile)
                this.executeRowCommand(this.get_selectedKey().length > 0 ? null : 0, 'Select');
            this._forceFocusDataSheet = false;
        }
    },
    _hideContainer: function () {
        this._containerIsHidden = true;
        this._container.style.display = 'none';
    },
    _enumerateMissingSearchOptions: function (searchOptions, filterList) {
        for (var i = 0; i < filterList.length; i++) {
            var fd = filterList[i];
            if (fd && !fd.Hidden)
                if (fd.List)
                    this._enumerateExpressions(searchOptions, filterList);
                else
                    if (!Array.contains(searchOptions, fd.Function))
                        Array.add(searchOptions, fd.Function);
        }
    },
    _executeSecondCommand: function (force) {
        if (force) {
            var m = Web.DataView._commandLine.match(/_commandName2=(\w+)(.*?_commandArgument2=(.*?)(&|$))?/);
            if (m)
                this.executeActionInScope([this.get_viewType(), 'ActionBar'], m[1], m[3]);
        }
        else if (this._trySecondCommand) {
            this._trySecondCommand = false;
            if (this.get_viewType() != 'Form' || this._totalRowCount > 0) {
                var self = this;
                setTimeout(function () {
                    self._executeSecondCommand(true);
                }, 50);
            }
        }
    },
    _skipNextInputListenerClickEvent: function () {
        if (Sys.Browser.agent != Sys.Browser.InternetExplorer || Sys.Browser.version >= 9)
            this._skipClickEvent = true;
    },
    _gridViewCellFocus: function (event, rowIndex, colIndex) {
        try {
            var ev = new Sys.UI.DomEvent(event);
            var eventTarget = ev.target;
            if ((eventTarget.tagName == 'A' || eventTarget.parentNode.tagName == 'A') && !this.get_lookupField() || Sys.UI.DomElement.containsCssClass(eventTarget, 'RowSelector')) return false;
            if (eventTarget.tagName == 'SPAN' && eventTarget.className == 'ObjectRef')
                return false;
            if (this.get_lookupField()) {
                ev.stopPropagation();
                ev.preventDefault();
            }
            this._skipNextInputListenerClickEvent();
        }
        catch (ex) {
        }
        this.executeRowCommand(rowIndex, 'Select');
        return true;
    },
    _dataSheetCellFocus: function (event, rowIndex, colIndex) {
        var fc = this._get_focusedCell();
        var inserting = this.get_isInserting();
        if (inserting && rowIndex != -1)
            rowIndex = -1;
        if (colIndex == -1)
            colIndex = fc != null ? fc.colIndex : 0;
        if (this.get_isEditing() && fc) {
            this._focusCell(-1, -1, false);
            this._focusCell(rowIndex, colIndex);
            var thisRow = rowIndex == fc.rowIndex || inserting && rowIndex == -1;
            if (!thisRow && !this._updateFocusedRow(fc) || !this._updateFocusedCell(fc)) {
                this._focusCell(rowIndex, colIndex, false);
                this._focusCell(fc.rowIndex, fc.colIndex);
            }
            else if (thisRow && (rowIndex != this._selectedRowIndex && !inserting))
                this.cancelDataSheetEdit();
            this._skipNextInputListenerClickEvent();
            return;
        }
        if (!event)
            this._skipNextInputListenerClickEvent();
        else if (!this._gridViewCellFocus(event, rowIndex, colIndex))
            return;
        if (fc != null && fc.rowIndex == rowIndex && fc.colIndex == colIndex && !this.get_isEditing() && !this.get_lookupField()) {
            if (document.selection)
                document.selection.clear();
            if (this._skipEditOnClick != true && this._allowEdit())
                this.editDataSheetRow(fc.rowIndex);
        }
        else
            this._startInputListenerOnCell(rowIndex, colIndex);
        this._skipEditOnClick = false;
    },
    _startInputListenerOnCell: function (rowIndex, colIndex) {
        this._startInputListener();
        this._focusCell(-1, -1, false);
        this._focusCell(rowIndex, colIndex);
        if (!this.get_lookupField()) {
            if (Web.DataView._activeDataSheetId != this.get_id()) {
                var dv = $find(Web.DataView._activeDataSheetId);
                if (dv)
                    dv.cancelDataSheet();
                Web.DataView._activeDataSheetId = this.get_id();
            }
            this._lostFocus = false;
        }
    },
    _startInputListener: function () {
        this._stopInputListener();
        if (!this._inputListenerKeyDownHandler) {
            this._inputListenerKeyDownHandler = Function.createDelegate(this, this._inputListenerKeyDown);
            this._inputListenerKeyPressHandler = Function.createDelegate(this, this._inputListenerKeyPress);
            this._inputListenerClickHandler = Function.createDelegate(this, this._inputListenerClick);
            this._inputListenerDblClickHandler = Function.createDelegate(this, this._inputListenerDblClick);
            this._focusedCell = null;
        }
        $addHandler(document, 'keydown', this._inputListenerKeyDownHandler);
        $addHandler(document, 'keypress', this._inputListenerKeyPressHandler);
        $addHandler(document, 'click', this._inputListenerClickHandler);
        $addHandler(document, 'dblclick', this._inputListenerDblClickHandler);
        this._trackingInput = true;
    },
    _stopInputListener: function () {
        if (!this._trackingInput) return;
        $removeHandler(document, 'keydown', this._inputListenerKeyDownHandler);
        $removeHandler(document, 'keypress', this._inputListenerKeyPressHandler);
        $removeHandler(document, 'click', this._inputListenerClickHandler);
        $removeHandler(document, 'dblclick', this._inputListenerDblClickHandler);
        this._lostFocus = true;
        this._trackingInput = false;
    },
    _allowEdit: function () {
        return this._findActionsByCommandName('Edit').length > 0;
    },
    _allowNew: function () {
        return this._findActionsByCommandName('New').length > 0;
    },
    get_interactiveActionGroups: function () {
        var actionGroups = this.get_actionGroups('Grid');
        Array.addRange(actionGroups, this.get_actionGroups('ActionBar'));
        Array.addRange(actionGroups, this.get_actionGroups('Form'));
        Array.addRange(actionGroups, this.get_actionGroups('ActionColumn'));
        return actionGroups;
    },
    _findActionsByCommandName: function (commandName) {
        var result = [];
        var actionGroups = this.get_interactiveActionGroups();
        for (var i = 0; i < actionGroups.length; i++) {
            actions = actionGroups[i].Actions;
            for (var j = 0; j < actions.length; j++) {
                var a = actions[j];
                if (a.CommandName == commandName)
                    Array.add(result, a);
            }
        }
        return result;
    },
    _inputListenerKeyPress: function (e) {
        if (e.rawEvent && e.rawEvent.charCode == 0) // Firefox fix
            return;
        if (this._lostFocus) return;

        if (this.get_isEditing()) {
            if (this._pendingChars)
                this._pendingChars += String.fromCharCode(e.charCode);
            return;
        }
        if (this._isBusy) return;
        var fc = this._get_focusedCell();
        if (fc == null) return;
        var field = this._fields[fc.colIndex];
        if (field.ReadOnly) return;
        if (!this._allowEdit()) return;
        this.executeRowCommand(fc.rowIndex, 'Select');
        if (!field.isReadOnly()) {
            this._pendingChars = String.fromCharCode(e.charCode);
            this.editDataSheetRow(fc.rowIndex);
        }
        //        e.stopPropagation();
        //        e.preventDefault();
    },
    cancelDataSheet: function () {
        if (this.get_isDataSheet()) {
            this._focusCell(-1, -1, false);
            this._stopInputListener();
            this.set_ditto(null);
            Web.DataView._activeDataSheetId = null;
            this.cancelDataSheetEdit();
            this._lostFocus = false;
            this._focusedCell = null;
        }
    },
    _inputListenerKeyDown: function (e) {
        //if (this.get_isEditing()) return;
        if (this._lookupIsActive) return;
        if (this._lostFocus) return;
        if (Web.HoverMonitor._instance.get_isOpen()) return;
        if (this._isBusy) {
            if (this._pendingChars)
                return;
            e.preventDefault();
            e.stopPropagation();
            return;
        }
        if (this._isBusy) return;
        var fc = this._get_focusedCell();
        if (fc == null) return;
        var fc2 = { 'rowIndex': fc.rowIndex, 'colIndex': fc.colIndex };
        var handled = false;
        var causesRender = false;
        var pageSize = this.get_pageSize();
        if (this._rows.length < pageSize)
            pageSize = this._rows.length;
        switch (e.keyCode) {
            case 83: // Ctrl+S
            case Sys.UI.Key.enter:
                if (e.keyCode == 83 && !e.ctrlKey) return;
                if (this.get_isEditing()) {
                    var tagName = e.target && e.target.tagName;
                    if ((tagName == 'TEXTAREA' || tagName == 'A') && !e.ctrlKey)
                        return;
                    //                    this.executeRowCommand(fc.rowIndex, 'Update', null, true);
                    //                    if (!this._valid)
                    //                        return;
                    handled = true;
                    this._updateFocusedRow(fc)
                    e.preventDefault();
                    e.stopPropagation();
                    return;
                    //                    if (!this._updateFocusedRow(fc)) {
                    //                        e.preventDefault();
                    //                        e.stopPropagation();
                    //                        return;
                    //                    }
                }
                if (e.ctrlKey && !this.get_isEditing() || this.get_lookupField()) {
                    handled = true;
                    this.executeRowCommand(fc.rowIndex, 'Select');
                }
                else if (e.shiftKey) {
                    if (fc2.rowIndex > 0)
                        fc2.rowIndex--;
                }
                else {
                    if (this._moveFocusToNextRow(fc2, pageSize))
                        handled = true;
                    //                    if (fc2.rowIndex < pageSize - 1)
                    //                        fc2.rowIndex++;
                }
                break;
            case Sys.UI.Key.down:
                if (this.get_isEditing() || e.ctrlKey) return;
                if (this._moveFocusToNextRow(fc2, pageSize))
                    handled = true;
                break;
            case Sys.UI.Key.up:
                if (this.get_isEditing() || e.ctrlKey) return;
                if (fc2.rowIndex > 0)
                    fc2.rowIndex--;
                else {
                    if (this._pageOffset == 0 && this.get_pageIndex() == 0) {
                        this._pageOffset = null;
                        handled = true;
                    }
                    else if (this._pageOffset == null) {
                        if (this.get_pageIndex() > 0)
                            this._pageOffset = -1;
                    }
                    else
                        this._pageOffset--;
                    handled = true;
                    if (this._pageOffset == -pageSize) {
                        this._pageOffset = null;
                        if (this.get_pageIndex() > 0)
                            this.goToPage(this.get_pageIndex() - 1);
                    }
                    else
                        this.goToPage(this.get_pageIndex());
                }
                break;
            case Sys.UI.Key.tab:
            case Sys.UI.Key.right:
            case Sys.UI.Key.left:
                var allowRefresh = true;
                if ((e.keyCode == Sys.UI.Key.right || e.keyCode == Sys.UI.Key.left) && this.get_isEditing()) return;
                if (!e.shiftKey && e.target.parentNode.className == 'Date')
                    return;
                if (e.shiftKey && e.target.id && e.target.id.match(/\$Time\d+/))
                    return;
                var lastPageOffset = this._pageOffset;
                if (e.shiftKey || e.keyCode == Sys.UI.Key.left) {
                    if (fc2.colIndex > 0) {
                        fc2.colIndex--;
                        if (e.keyCode == Sys.UI.Key.tab)
                            while (fc2.colIndex > 0 && this._fields[fc2.colIndex].isReadOnly())
                                fc2.colIndex--;
                    }
                    else if (this.get_isEditing())
                        handled = true;
                }
                else if (fc2.colIndex < this._fields.length - 1) {
                    fc2.colIndex++;
                    if (e.keyCode == Sys.UI.Key.tab)
                        while (fc2.colIndex < this._fields.length - 1 && this._fields[fc2.colIndex].isReadOnly())
                            fc2.colIndex++;
                }
                else {
                    if (this.get_isEditing()) {
                        if (!this._updateFocusedRow(fc, e.keyCode == Sys.UI.Key.tab)) {
                            e.preventDefault();
                            e.stopPropagation();
                            return;
                        }
                        else
                            allowRefresh = false;
                        handled = true;
                    }
                    if (allowRefresh && this._moveFocusToNextRow(fc2, pageSize))
                        handled = true;
                    if (fc2.rowIndex != fc.rowIndex || this._pageOffset != lastPageOffset) {
                        fc2.colIndex = 0;
                        handled = false;
                    }
                }
                if (allowRefresh && this.get_isEditing())
                    causesRender = true;
                break;
            case Sys.UI.Key.home:
                if (this.get_isEditing()) return;
                if (e.ctrlKey) {
                    if (this.get_pageIndex() > 0) {
                        handled = true;
                        this._pageOffset = 0;
                        this.goToPage(0);
                        fc.rowIndex = 0;
                        fc.colIndex = 0;
                    }
                    else {
                        fc2.rowIndex = 0;
                        fc2.colIndex = 0;
                    }
                }
                else
                    fc2.colIndex = 0;
                break;
            case Sys.UI.Key.end:
                if (this.get_isEditing()) return;
                if (e.ctrlKey) {
                    handled = true;
                    fc.colIndex = this._fields.length - 1;
                    fc.rowIndex = this._totalRowCount % this.get_pageSize() - 1;
                    if (fc.rowIndex < 0)
                        fc.rowIndex = this.get_pageSize();
                    this._pageOffset = null;
                    this.goToPage(this.get_pageCount() - 1);
                }
                else
                    fc2.colIndex = this._fields.length - 1;
                break;
            case Sys.UI.Key.pageUp:
                if (this.get_isEditing()) return;
                handled = true;
                if (this.get_pageIndex() > 0) {
                    this.goToPage(this.get_pageIndex() - 1);
                }
                else if (this._pageOffset != null) {
                    this._pageOffset = null;
                    this.goToPage(this.get_pageIndex());
                }
                break;
            case Sys.UI.Key.pageDown:
                if (this.get_isEditing()) return;
                handled = true;
                if (this.get_pageIndex() < this.get_pageCount() - 1)
                    this.goToPage(this.get_pageIndex() + 1);
                break;
            case Sys.UI.Key.esc:
                if (!this.cancelDataSheetEdit())
                    this.cancelDataSheet();
                handled = true;
                break;
            case Sys.UI.Key.del:
                if (this.get_isEditing() || e.shiftKey || e.altKey) return;
                handled = true;
                if (e.ctrlKey)
                    this.deleteDataSheetRow();
                else {
                    this._pendingChars = '';
                    this.editDataSheetRow(fc.rowIndex);
                }
                break;
            case 45: /* Insert */
                if (!this.get_isEditing()) {
                    handled = true;
                    if (this._allowNew())
                        this.newDataSheetRow();
                }
                break;
            case 32: /* space */
                if (e.ctrlKey && this.multiSelect() && !this.get_isInserting()) {
                    handled = true;
                    this.toggleSelectedRow(fc.rowIndex);
                }
                else
                    return;
                break;
            case 113: /* F2 */
                if (this.get_isEditing()) return;
                handled = true;
                if (this._allowEdit())
                    this.editDataSheetRow(fc.rowIndex);
                break;
        }
        if ((fc.rowIndex != fc2.rowIndex || fc.colIndex != fc2.colIndex) && !handled) {
            this._focusCell(fc.rowIndex, fc.colIndex, false);
            this._focusCell(fc2.rowIndex, fc2.colIndex, true);
            handled = true;
        }
        if (handled) {
            e.preventDefault();
            e.stopPropagation();
        }
        if (causesRender) {
            if (!this._updateFocusedCell(fc)) {
                this._focusCell(fc2.rowIndex, fc2.colIndex, false);
                this._focusCell(fc.rowIndex, fc.colIndex, true);
            }
        }
    },
    _updateFocusedCell: function (fc) {
        var values = this._collectFieldValues();
        var valid = this._validateFieldValues(values, true, fc);
        var field = this._fields[fc.colIndex];
        if (valid) {
            var doRefresh = true;
            if (field.Index < values.length && values[field.Index].Modified)
                doRefresh = !this._performValueChanged(field.Index);
            if (doRefresh)
                this.refresh(true);
        }
        else if (field.Behaviors)
            for (var i = 0; i < field.Behaviors.length; i++) {
                var b = field.Behaviors[i];
                if (AjaxControlToolkit.CalendarBehavior.isInstanceOfType(b) && b.get_isOpen()) {
                    b.hide();
                    b.show();
                }
            }
        return valid;
    },
    _updateFocusedRow: function (fc, saveAndNew) {
        Web.DataView.showMessage();
        this._syncFocusedCell = this.get_isInserting();
        this._lastFocusedCell = fc;
        this._skipSync = true;
        this.executeRowCommand(fc.rowIndex, this._syncFocusedCell ? 'Insert' : 'Update', null, true);
        if (this._valid)
            this._saveAndNew = saveAndNew;
        return this._valid;
    },
    _get_selectedDataRowIndex: function (rowIndex) {
        return this.get_pageIndex() * this.get_pageSize() + this.get_pageOffset() + (rowIndex != null ? rowIndex : this._selectedRowIndex);
    },
    executeActionInScope: function (scopes, commandName, commandArgument, rowIndex, test) {
        if (rowIndex == null)
            rowIndex = this._selectedRowIndex;
        for (var j = 0; j < scopes.length; j++) {
            var scope = scopes[j];
            var actionGroups = this.get_actionGroups(scope);
            if (actionGroups)
                for (var k = 0; k < actionGroups.length; k++) {
                    var actions = actionGroups[k].Actions;
                    if (actions) {
                        for (var i = 0; i < actions.length; i++) {
                            var action = actions[i];
                            if (action.CommandName == commandName && (String.isNullOrEmpty(commandArgument) || action.CommandArgument == commandArgument) && this._isActionAvailable(action, rowIndex)) {
                                if (test != true)
                                    this.executeAction(scope, i, rowIndex, k);
                                return true;
                            }
                        }
                    }
                }
        }
        return false;
    },
    newDataSheetRow: function () {
        var self = this;
        setTimeout(function () {
            self.executeCommand({ commandName: 'New', commandArgument: self.get_viewId() });
        }, 100);
    },
    editDataSheetRow: function (rowIndex) {
        if (this.get_isDataSheet())
            this.executeRowCommand(rowIndex, 'Edit', '', false);
    },
    deleteDataSheetRow: function () {
        var fc = this._get_focusedCell();
        if (fc) {
            this.executeRowCommand(fc.rowIndex, 'Select');
            var self = this;
            setTimeout(function () {
                self.executeActionInScope(['Row', 'ActionBar'], 'Delete', null, fc.rowIndex);
            }, 100);
        }
    },
    _moveFocusToNextRow: function (fc2, pageSize) {
        var handled = false;
        var originalDataRowIndex = this._get_selectedDataRowIndex(fc2.rowIndex);
        var originalPageOffset = this._pageOffset;
        if (fc2.rowIndex < pageSize - 1)
            fc2.rowIndex++;
        else if (this._get_selectedDataRowIndex(fc2.rowIndex) < this._totalRowCount - 1) {
            if (this._pageOffset == null)
                this._pageOffset = 1;
            else
                this._pageOffset++;
            handled = true;
            if (this._pageOffset == pageSize) {
                this._pageOffset = null;
                this.goToPage(this.get_pageIndex() + 1);
            }
            else
                this.goToPage(this.get_pageIndex());
        }
        if (originalDataRowIndex == this._get_selectedDataRowIndex(fc2.rowIndex) && !this.get_isEditing() && this._allowNew()) {
            this._ignoreSelectedKey = true;
            this.newDataSheetRow();
            handled = true;
        }
        return handled;
    },
    _scrollToRow: function (delta) {
        return;
        // not implemented
        var fc = this._get_focusedCell();
        if (fc) {
            fc.rowIndex += delta > 0 ? 1 : -1;
            this._moveFocusToNextRow(fc, this.get_pageSize);
        }
    },
    cancelDataSheetEdit: function () {
        if (this.get_isEditing()) {
            var fc = this._get_focusedCell();
            if (fc != null)
                this.executeRowCommand(fc.rowIndex, 'Cancel', null, false);
            return true;
        }
        else
            return false;
    },
    _inputListenerClick: function (e) {
        if (this._skipClickEvent) {
            this._skipClickEvent = false;
            return;
        }
        if (this._lookupIsActive) return;
        var elem = e.target;
        var isThisContainer = false;
        var isDataCell = false;
        var keepFocus = true;
        while (elem != null) {
            if (elem == this._container) {
                isThisContainer = true;
                break;
            }
            if (elem.className != null) {
                if (elem.className.match(/Cell|Group|InfoRow|FieldHeaderSelector|Toggle|FooterRow|ActionRow\s*/))
                    isDataCell = true;
                else if (elem.className.match(/QuickFind|SearchBarFrame\s*/))
                    keepFocus = false;
            }

            elem = elem.parentNode;
        }
        if (!isThisContainer)
            this.cancelDataSheet();
        else {
            if (keepFocus)
                this._lostFocus = !isDataCell;
            else
                this._lostFocus = true;
            this._skipEditOnClick = true;
            if (!isDataCell)
                this.cancelDataSheetEdit();
        }
    },
    _inputListenerDblClick: function (e) {
        if (this._lostFocus) return;
        var fc = this._get_focusedCell();
        if (!fc || this.get_isEditing() || !this._allowEdit()) return;
        //this.executeRowCommand(fc.rowIndex, 'Edit', this.get_viewId(), false);
        if (document.selection)
            document.selection.clear();
        this.editDataSheetRow(fc.rowIndex);
    },
    _get_focusedCell: function () {
        return this._focusedCell;
    },
    _focusCell: function (rowIndex, colIndex, highlight) {
        if (!this.get_isDataSheet()) {
            this._focusedCell = null;
            return null;
        }
        var inserting = this.get_isInserting();
        if (highlight == null)
            highlight = true;
        if (rowIndex == -1 && colIndex == -1) {
            if (!this._focusedCell) return null;
            rowIndex = this._focusedCell.rowIndex;
            colIndex = this._focusedCell.colIndex;
        }
        if (rowIndex >= this._rows.length)
            rowIndex = this._rows.length - 1;
        if (colIndex >= this._fields.length)
            colIndex = this._fields.length - 1;
        var tableRows = this._container.childNodes[0].rows;
        var currentRowIndex = -1;

        for (var i = 0; i < tableRows.length; i++) {
            var row = tableRows[i];
            if (Sys.UI.DomElement.containsCssClass(row, 'Row') || Sys.UI.DomElement.containsCssClass(row, 'AlternatingRow'))
                currentRowIndex++;
            if (inserting) {
                if (Sys.UI.DomElement.containsCssClass(row, 'Inserting'))
                    break;
            }
            else if (currentRowIndex == rowIndex)
                break;
        }
        if (currentRowIndex < 0) return null;
        var currentColIndex = -1;
        for (i = 0; i < row.childNodes.length; i++) {
            var cell = row.childNodes[i + this.get_sysColCount()];
            if (cell && Sys.UI.DomElement.containsCssClass(cell, 'Cell'))
                currentColIndex++;
            if (currentColIndex == colIndex)
                break;
        }
        if (currentColIndex < 0) return null;
        var gapCell = cell.parentNode.childNodes[this.get_sysColCount() - 1];
        var headerRow = this._get_headerRowElement();
        var headerCell = headerRow.childNodes[colIndex + this.get_sysColCount()];
        if (highlight == true) {
            var headerCellBounds = $common.getBounds(headerCell);
            Sys.UI.DomElement.addCssClass(cell, 'Focused');
            Sys.UI.DomElement.addCssClass(gapCell, 'CrossHair');
            Sys.UI.DomElement.addCssClass(headerCell, 'CrossHair');
            if (!this._skipCellFocus) {
                var scrolling = $appfactory.scrolling(); // $common.getScrolling();
                var clientBounds = $common.getClientBounds();
                var cellBounds = $common.getBounds(cell);
                if (scrolling.y > cellBounds.y)
                    (currentRowIndex == 0 ? headerCell : cell).scrollIntoView(true);
                else if (scrolling.y + clientBounds.height <= cellBounds.y + cellBounds.height)
                    cell.scrollIntoView(false);
                else if (scrolling.x > cellBounds.x || scrolling.x + clientBounds.width - 1 <= cellBounds.x || scrolling.x + clientBounds.width - 1 <= cellBounds.x + cellBounds.width)
                    cell.scrollIntoView(false);
                if (Sys.Browser.agent == Sys.Browser.InternetExplorer/* && this.get_isEditing()*/) {
                    var rb = $common.getBounds(headerRow);
                    headerRow.style.height = rb.height + 'px';
                }
            }
            var headerCellBounds2 = $common.getBounds(headerCell);
            if (headerCellBounds.width != headerCellBounds2.width || headerCellBounds.x != headerCellBounds2.x || headerCellBounds.y != headerCellBounds2.y)
                Sys.UI.DomElement.addCssClass(headerCell, 'Narrow');
            this._skipCellFocus = false;
        }
        else {
            Sys.UI.DomElement.removeCssClass(cell, 'Focused');
            Sys.UI.DomElement.removeCssClass(cell, 'Narrow');
            Sys.UI.DomElement.removeCssClass(gapCell, 'CrossHair');
            Sys.UI.DomElement.removeCssClass(headerCell, 'CrossHair');
        }
        this._focusedCell = { 'rowIndex': rowIndex, 'colIndex': colIndex }
        return cell;
    },
    _initializeModalPopup: function () {
        Sys.UI.DomElement.addCssClass(this.get_element(), 'ModalPlaceholder');
        var cb = $common.getClientBounds();
        var width = cb.width / 5 * 4;
        var maxWidth = Web.DataViewResources.ModalPopup.MaxWidth;
        var confirmContext = this.get_confirmContext();
        if (confirmContext && confirmContext.MaxWidth > 0 && confirmContext.MaxWidth < width)
            maxWidth = confirmContext.MaxWidth;
        if (width > maxWidth)
            width = maxWidth;
        var height = cb.height / 5 * 4;
        if (this._container.style.overflowX != null) {
            this._container.style.overflowY = 'auto';
            this._container.style.overflowX = 'hidden';
        }
        else
            this._container.style.overflow = 'auto';
        this._container.style.height = height + 'px';
        this._container.style.width = width + 'px';
        this._saveTabIndexes();
        this._modalPopup = $create(AjaxControlToolkit.ModalPopupBehavior, { id: this.get_id() + 'ModalPopup' + Sys.Application.getComponents().length, PopupControlID: this.get_element().id, DropShadow: true, BackgroundCssClass: 'ModalBackground' }, null, null, this.get_modalAnchor());
        this._modalPopup.show();
    },
    _resizeContainerBounds: function () {
        if (!this._modalPopup)
            this._container.style.height = '';
        var containerBounds = $common.getBounds(this._container);
        var clientBounds = $common.getClientBounds();
        var maxHeight = Math.ceil(clientBounds.height / 5 * 4);
        if (containerBounds.height > maxHeight) {
            this._container.style.height = maxHeight + 'px';
            containerBounds.skipResizing = true;
        }
        return containerBounds;
    },
    _adjustModalPopupSize: function () {
        var confirmContext = this.get_confirmContext();
        Sys.UI.DomElement.removeCssClass(this._element, 'EmptyModalDialog');
        var sb = new Sys.StringBuilder();
        var rowsToDelete = [];
        var tables = this._container.getElementsByTagName('table');
        for (var i = tables.length - 1; i >= 0; i--) {
            var t = tables[i];
            if (t.className == 'ActionButtons') {
                if (sb.isEmpty()) {
                    sb.append('<table class="DataView" cellSpacing=0 cellPadding=0><tr class="ActionButtonsRow BottomButtonsRow">')
                    sb.append(t.parentNode.parentNode.innerHTML);
                    sb.append('</tr></table>');
                }
                Array.add(rowsToDelete, t.parentNode.parentNode);
            }
        }
        while (rowsToDelete.length > 0) {
            rowsToDelete[0].parentNode.removeChild(rowsToDelete[0]);
            delete rowsToDelete[0];
            Array.removeAt(rowsToDelete, 0);
        }
        var contentElem = this._container.childNodes[0];
        contentElem.style.width = '';
        contentElem.style.height = '';
        var contentSize = $common.getContentSize(contentElem);
        contentSize.height += Sys.Browser.agent === Sys.Browser.InternetExplorer && Sys.Browser.version < 8 ? 3 : 1;
        if (!this._buttons) {
            this._buttons = document.createElement('div');
            this.get_element().appendChild(this._buttons);
            this._buttons.style.width = contentSize.width + 'px';
            Sys.UI.DomElement.addCssClass(this._buttons, 'FixedButtons');
            this._title = document.createElement('div');
            //this._title.innerHTML = Web.DataView.htmlEncode(this.get_view().Label);
            Sys.UI.DomElement.addCssClass(this._title, 'FixedTitle');
            this.get_element().insertBefore(this._title, this._container);
            if (!__designer())
                $(this._element).draggable({
                    'handle': this._title, drag: function (event, ui) {
                        var w = $(window);
                        var clientWidth = w.width();
                        var clientHeight = w.height();
                        var left = ui.offset.left - w.scrollLeft();
                        var top = ui.offset.top - w.scrollTop();
                        var width = ui.helper.outerWidth();
                        if (left + width < 50 || top < 5 || left > clientWidth - 50 || top > clientHeight - 75)
                            return false;
                    }
                });
        }
        else {
            if (!this._modalAutoSized) {
                //this._buttons.style.width = 'auto';
                //this._title.style.width = 'auto';
                this._container.style.width = 'auto';
                this._modalAutoSized = true;
            }
        }
        this._buttons.innerHTML = sb.toString();
        sb.clear();
        //        var containerBounds = $common.getBounds(this._container);
        //        var clientBounds = $common.getClientBounds();
        //        var maxHeight = Math.ceil(clientBounds.height / 5 * 4);
        //        if (containerBounds.height > maxHeight)
        //            this._container.style.height = maxHeight + 'px';
        var containerBounds = this._resizeContainerBounds();
        if (containerBounds.height > contentSize.height && !containerBounds.skipResizing) {
            var cbb = $common.getBorderBox(contentElem);
            contentSize.width += cbb.horizontal;
            $common.setContentSize(this._container, contentSize);
        }
        contentElem.style.width = this._title.offsetWidth + 'px';
        this._buttons.style.width = this._title.offsetWidth + 'px';
        Sys.UI.DomElement.setVisible(this.get_element(), true);
        //        if (this._modalPopup) {
        //            if (Sys.Browser.agent === Sys.Browser.InternetExplorer) this._modalPopup.hide();
        //            this._modalPopup.show();
        //        }
        var b = $common.getBounds(this._container);
        var tb = $common.getPaddingBox(this._title);
        var bb = $common.getBorderBox(this._title);
        this._title.style.width = (b.width - tb.horizontal - bb.horizontal) + 'px';
        tb = $common.getPaddingBox(this._buttons);
        bb = $common.getBorderBox(this._buttons);
        this._buttons.style.width = (b.width - tb.horizontal - bb.horizontal) + 'px';
        this._title.innerHTML = String.format('<table style="width:100%" cellpadding="0" cellspacing="0"><tr><td><div class="Text">{1}</div></td><td align="right"><a href="javascript:" class="Close" onclick="$find(\'{0}\').endModalState(\'Cancel\');return false" tabindex="{3}" title="{2}">&nbsp;</a></td></tr></table>',
            this.get_id(),
            confirmContext && confirmContext.WindowTitle ? confirmContext.WindowTitle : Web.DataView.htmlEncode(this.get_view().Label),
            Web.DataViewResources.ModalPopup.Close,
            $nextTabIndex());
        //if (Sys.Browser.agent === Sys.Browser.InternetExplorer && this.get_isEditing()) this._focus();
        this._modalPopup.show();
        if (this._modalAutoSized && !this._modalWidthFixed) {
            this._modalWidthFixed = true;
            this._container.style.width = this._container.offsetWidth + 'px';
        }
        this._adjustModalHeight(true);
    },
    _adjustModalHeight: function (save) {
        var container = this._container;
        if (this._modalPopup && this.get_viewType() == 'Form')
            if (save) {
                var containerBounds = $common.getBounds(container);
                this._lastContainerHeight = containerBounds.height;
            }
            else if (this._lastContainerHeight != null) {
                var oldStyleHeight = container.style.height;
                var oldScrollTop = container.scrollTop;
                container.style.height = '';
                var categoriesCell = null;
                var trList = container.getElementsByTagName('tr');
                for (var i = 0; i < trList.length; i++) {
                    if (trList[i].className == 'Categories') {
                        categoriesCell = trList[i].childNodes[0];
                        break;
                    }
                }
                if (categoriesCell)
                    categoriesCell.style.paddingBottom = '';
                containerBounds = $common.getBounds(container);
                if (this._lastContainerHeight > containerBounds.height) {
                    var paddingBox = $common.getPaddingBox(categoriesCell);
                    if (categoriesCell) {
                        var newPaddingBottom = this._lastContainerHeight - containerBounds.height - paddingBox.bottom;
                        if (Sys.Browser.agent == Sys.Browser.InternetExplorer)
                            newPaddingBottom++;
                        categoriesCell.style.paddingBottom = newPaddingBottom + 'px';
                    }
                }
                else {
                    var clientBounds = $common.getClientBounds();
                    if (clientBounds.height * 0.8 <= containerBounds.height) {
                        container.style.height = oldStyleHeight;
                        container.scrollTop = oldScrollTop;
                    }
                    else
                        this._lastContainerHeight = containerBounds.height;
                }
            }
    },
    _allowModalAutoSize: function () {
        this._modalWidthFixed = false;
        this._modalAutoSized = false;
    },
    _disposeModalPopup: function () {
        if (!this._modalPopup) return;
        this._modalPopup.hide();
        this._modalPopup.dispose();
        //delete this._modalPopup._backgroundElement;
        //delete this._modalPopup._foregroundElement;
        //delete this._modalPopup._popupElement;
        if (!__designer())
            $(this._element).draggable('destroy');
        delete this._buttons;
        delete this._title;
        delete this._modalAnchor;
        var elem = this.get_element();
        elem.parentNode.removeChild(elem);
        this._restoreTabIndexes();
    },
    endModalState: function (commandName) {
        var parentDataView = this.get_parentDataView(),
            hoverInstance = Web.HoverMonitor._instance; // this._parentDataViewId ? Web.DataView.find(this._parentDataViewId) : null;
        if (this.get_isModal()) {
            var exitCommands = this.get_exitModalStateCommands();
            if (exitCommands) {
                for (var i = 0; i < exitCommands.length; i++) {
                    if (commandName == exitCommands[i]) {
                        if (parentDataView) {
                            parentDataView._lookupIsActive = false;
                            parentDataView._skipClickEvent = true;
                        }
                        if ($appfactory.mobile)
                            window.history.go(-1);
                        else
                            this.dispose();
                        return true;
                    }
                }
            }
        }
        function refreshParentDataView() {
            parentDataView.refresh();
        }
        if (parentDataView && !this.get_confirmContext())
            if ($appfactory.mobile)
                setTimeout(refreshParentDataView, 100);
            else
                refreshParentDataView();
        if (hoverInstance)
            hoverInstance.close();
        return false;
    },
    _adjustLookupSize: function () {
        //if (this.get_lookupField() && Web.DataView.isIE6) this.get_lookupField()._lookupModalBehavior._layout();
        if (this.get_lookupField() && this.get_pageSize() > 3) {
            var scrolling = $appfactory.scrolling(); // $common.getScrolling();
            var clientBounds = $common.getClientBounds()
            var b = $common.getBounds(this.get_element());
            if (b.height + b.y > clientBounds.height + scrolling.y)
                this.set_pageSize(Math.ceil(this.get_pageSize() * 0.66));
        }
    },
    _onMethodFailed: function (err, response, context) {
        this._busy(false);
        if (Web.DataView._navigated) return;
        if (this._wsRequest == null) return;
        Web.DataView.showMessage(String.format('<pre style="word-wrap:break-word;margin:0px">Component: {4}\r\nController: {5}; View: {6}; Timed out: {0}\r\nException: {1}\r\nMessage: {2}\r\nStack:\r\n{3}</pre>', err.get_timedOut(), err.get_exceptionType(), err.get_message(), err.get_stackTrace(), this.get_id(), this.get_controller(), this.get_viewId()));
        this.get_element().style.border = '1px red solid';
    },
    _createArgsForListOfValues: function (distinctFieldName) {
        var lc = this.get_lookupContext();
        var filter = this._searchBarVisibleIndex == null ? this.get_filter() : this._createSearchBarFilter(true);
        var request =
            {
                FieldName: distinctFieldName, Controller: this.get_controller(), View: this.get_viewId(),
                Filter: filter.length == 1 && filter[0].match(/(\w+):/)[1] == distinctFieldName ? null : filter,
                ExternalFilter: this.get_externalFilter(),
                LookupContextFieldName: lc ? lc.FieldName : null, LookupContextController: lc ? lc.Controller : null,
                LookupContextView: lc ? lc.View : null, Tag: this.get_tag()
            };
        this._useSearchParams(request);
        return { controller: this.get_controller(), view: this.get_viewId(), request: request };
    },
    _loadListOfValues: function (family, fieldName, distinctFieldName) {
        this._busy(true);
        //var lc = this.get_lookupContext();
        //var filter = this.get_filter();
        this._invoke('GetListOfValues', this._createArgsForListOfValues(distinctFieldName), //{ controller: this.get_controller(), view: this.get_viewId(), request: { FieldName: distinctFieldName, Filter: filter.length == 1 && filter[0].match(/(\w+):/)[1] == distinctFieldName ? null : filter, LookupContextFieldName: lc ? lc.FieldName : null, LookupContextController: lc ? lc.Controller : null, LookupContextView: lc ? lc.View : null} },
            Function.createDelegate(this, this._onGetListOfValuesComplete), { 'family': family, 'fieldName': fieldName });
    },
    _onGetListOfValuesComplete: function (result, context) {
        this._busy(false);
        var field = this.findField(context.fieldName);
        field._listOfValues = result;
        if (result[result.length - 1] == null) {
            Array.insert(result, 0, result[result.length - 1]);
            Array.removeAt(result, result.length - 1);
        }
        if (this.get_isChart()) {
            if (this.get_showViewSelector())
                this._registerViewSelectorItems();
            else
                this._registerActionBarItems();
            Web.HoverMonitor._instance._tempOpenDelay = 100;
        }
        else
            this._registerFieldHeaderItems(Array.indexOf(this.get_fields(), field));
        $refreshHoverMenu(context.family);
        Web.DataView._resized = true;
    },
    get_parentDataView: function (defaultParent) {
        var dataView = defaultParent;
        if (!String.isNullOrEmpty(this._parentDataViewId))
            dataView = $find(this._parentDataViewId);
        return dataView;
    },
    get_selectedValues: function () {
        var dataView = this.get_parentDataView(this); // this;
        //if (!String.isNullOrEmpty(this._parentDataViewId))
        //    dataView = $find(this._parentDataViewId);
        var selection = dataView.get_selectedValue();
        return selection.length == 0 ? [] : (!this.multiSelect() ? [selection] : selection.split(';'));
    },
    _execute: function (args) {
        this._busy(true);
        this._showWait();
        this._lastArgs = args;
        /*
        args.Filter = this.get_filter();
        args.SortExpression = this.get_sortExpression();
        args.SelectedValues = this.get_selectedValues();
        args.ExternalFilter = this.get_externalFilter();
        args.Transaction = this.get_transaction();
        if (!String.isNullOrEmpty(args.Transaction) && !this.get_isModal() && !this.get_filterSource() && args.CommandName.match(/Insert|Update|Delete/))
        args.Transaction += ':complete';
        args.SaveLEVs = this._allowLEVs == true;
        */
        this._invoke('Execute', { controller: args.Controller, view: args.View, args: args }, Function.createDelegate(this, this._onExecuteComplete));
    },
    _populateDynamicLookups: function (result) {
        for (var i = 0; i < result.Values.length; i++) {
            var v = result.Values[i];
            var f = this.findField(v.Name);
            if (f) f.DynamicItems = v.NewValue;
        }
        this._skipPopulateDynamicLookups = true;
        this.refresh(true);
        this._focus();
    },
    _updateCalculatedFields: function (result) {
        this._displayActionErrors(result);
        var values = []
        for (var i = 0; i < result.Values.length; i++) {
            var v = result.Values[i];
            Array.add(values, { 'name': v.Name, 'value': v.NewValue });
        }
        this.refresh(true, values);
        //this._focus(values.length > 0 ? values[values.length - 1].name : null);
        this._focus();
    },
    _get_LEVs: function () {
        for (var i = 0; i < Web.DataView.LEVs.length; i++) {
            var lev = Web.DataView.LEVs[i];
            if (lev.controller == this.get_controller())
                return lev.records;
        }
        lev = { 'controller': this.get_controller(), 'records': [] };
        Array.add(Web.DataView.LEVs, lev);
        return lev.records;
    },
    _recordLEVs: function (values) {
        if (!this._allowLEVs || !values && !this._lastArgs.CommandName.match(/Insert|Update/)) return;
        if (!(this._lastArgs || values)) return;
        if (!values) values = this._lastArgs.Values;
        var levs = this._get_LEVs();
        var skip = true;
        for (var i = 0; i < values.length; i++) {
            if (values[i].Modified) {
                skip = false;
                break;
            }
        }
        if (skip) return;
        if (levs.length > 0)
            Array.removeAt(levs, levs.length - 1);
        Array.insert(levs, 0, values)
    },
    _applyLEV: function (fieldIndex) {
        var f = this._allFields[fieldIndex];
        var f2 = this._allFields[f.AliasIndex];
        var values = [];
        var r = this._get_LEVs()[0];
        for (var i = 0; i < r.length; i++) {
            var v = r[i];
            if (v.Name == f.Name || v.Name == f2.Name)
                Array.add(values, { 'name': v.Name, 'value': v.NewValue });
        }
        this.refresh(true, values);
    },
    _notifyMaster: function () {
        if (this.get_hasParent()) {
            var m = $find(this.get_filterSource());
            if (m) m._updateDynamicValues(this.get_controller());
        }
    },
    _clearSelectedKey: function (delaySelected) {
        // this workaround compensates for "modal" lookups in mobile client.
        var dataView = this._lookupInfo ? this : this.get_parentDataView(this);
        dataView._selectedKey = [];
        dataView._selectedKeyFilter = [];
        dataView._selectedRowIndex = null;
        dataView._position = null;
        if (delaySelected != false)
            dataView._raiseSelectedDelayed = true;
        dataView._selectedRow = null;
    },
    _refreshSelectedKey: function (values, notify) {
        if (values.length == 0 && this._lastArgs)
            values = this._lastArgs.Values;
        var selectedKey = [];
        var selectedKeyFilter = [];
        var clearKey = false;
        for (var i = 0; i < this._keyFields.length; i++) {
            var field = this._keyFields[i];
            for (var j = 0; j < values.length; j++) {
                if (values[j].Name == field.Name) {
                    var v = values[j];
                    if (v.NewValue == null) {
                        this._clearSelectedKey();
                        return;
                    }
                    Array.add(selectedKey, v.NewValue);
                    Array.add(selectedKeyFilter, field.Name + ':=' + this.convertFieldValueToString(field, v.NewValue));
                    break;
                }
            }
            // Array.add(selectedKey, v ? v.NewValue : null);
            // Array.add(selectedKeyFilter, field.Name + ':=' + this.convertFieldValueToString(field, v ? v.NewValue : null));
        }
        var dataView = this.get_parentDataView();
        if (!dataView)
            dataView = this;
        if (selectedKey.length > 0) {
            dataView._selectedKey = selectedKey;
            dataView._selectedKeyFilter = selectedKeyFilter;
            dataView._raiseSelectedDelayed = true;
        }
    },
    _cancelConfirmation: function () {
        if (this._confirmDataViewId) {
            var confirmView = $find(this._confirmDataViewId);
            if (confirmView) {
                this._confirmDataViewId = null;
                confirmView.cancel();
            }
        }
    },
    _findKeyValue: function (list) {
        var keyField = this._keyFields[0];
        for (var i = 0; i < list.length; i++) {
            var fv = list[i];
            if (keyField.Name == fv.Name)
                return fv.NewValue;
        }
        return null;
    },
    _onExecuteComplete: function (result, context) {
        this._busy(false);
        this._hideWait();
        var lastCommandName = this._lastArgs.CommandName;
        var noErrors = result.Errors.length == 0;
        var pendingUploads = this._pendingUploads;
        if (pendingUploads && pendingUploads.length > 0 && noErrors && lastCommandName == 'Insert' && result.RowsAffected == 1) {
            // select the first pending upload
            var upload = pendingUploads[0];
            Array.removeAt(pendingUploads, 0);
            // update the key reference in the pending upload
            var key = this._findKeyValue(result.Values);
            if (key == null)
                key = this._findKeyValue(this._lastArgs.Values);
            upload.form.action = upload.form.action.replace(/=u\|&/, String.format('=u|{0}&', key));
            // start the pending upload
            this._pendingExecuteComplete = { result: result, context: context };
            this._showDownloadProgress();
            upload.form.submit();
            return;
        }
        var lastFocusedCell = this._lastFocusedCell;
        if (lastCommandName == 'PopulateDynamicLookups') {
            this._populateDynamicLookups(result);
            return;
        }
        else if (lastCommandName == 'Calculate') {
            this._updateCalculatedFields(result);
            if (!String.isNullOrEmpty(result.ClientScript))
                eval(result.ClientScript);
            return;
        }
        var stopFlow = false;
        var isCustom = lastCommandName == 'Custom';
        if (noErrors)
            this._cancelConfirmation();
        var ev = { 'result': result, 'context': context, 'handled': false }
        this.raiseExecuted(ev);
        if (ev.handled) return;
        var existingRow = !lastCommandName.match(/Insert/);
        if (lastCommandName.match(/Delete/i) && result.RowsAffected > 0)
            this._clearSelectedKey();
        //        {
        //            this._selectedKey = [];
        //            this._selectedKeyFilter = [];
        //            this.raiseSelected();
        //        }
        else
            if (lastCommandName.match(/Custom|SQL|Email/)) {
                stopFlow = !isCustom && this.get_isEditing();
                if (result.Values.length > 0) {
                    this.refresh(true, result.Values)
                    if (isCustom && !result.ClientScript)
                        result.ClientScript = 'void(0)';
                    this._refreshSelectedKey(result.Values, noErrors);
                }
                else if (!stopFlow && lastCommandName == 'SQL') {
                    this._raiseSelectedDelayed = true;
                    this._forceChanged = true;
                }
            }
            else
                if (existingRow) {
                    for (var i = 0; i < result.Values.length; i++) {
                        var v = result.Values[i];
                        var field = this.findField(v.Name);
                        if (field) this.get_currentRow()[field.Index] = v.NewValue;
                    }
                }
                else
                    this._refreshSelectedKey(result.Values, noErrors);
        if (noErrors) {
            this._forceSync();
            var parentDataView = this.get_parentDataView();
            if (parentDataView)
                parentDataView._forceSync();
            this.set_tag(result.Tag);
            this._requestedFilter = result.Filter;
            this._requestedSortExpression = result.SortExpression;
            this._autoRefresh();
            if (this.multiSelect()) {
                this._selectedKeyList = [];
                this.set_selectedValue('');
            }
            this._recordLEVs();
            this.updateSummary();
            this._continueAfterScript = true;
            if (result.ClientScript) {
                this._continueAfterScript = false;
                result.ClientScript = this.resolveClientUrl(result.ClientScript);
                eval(result.ClientScript);
            }
            this._lastFocusedCell = null;
            var lastCommandArgument = this._lastArgs.CommandArgument;
            var rules = new Web.BusinessRules(this);
            rules.after({ commandName: lastCommandName, commandArgument: lastCommandArgument });
            if (rules.canceled())
                this._continueAfterScript = false;
            rules.dispose();
            if (this._continueAfterScript) {
                if (result.NavigateUrl) {
                    result.NavigateUrl = this.resolveClientUrl(result.NavigateUrl);
                    this.navigate(result.NavigateUrl, existingRow ? this._lastArgs.Values : result.Values);
                }
                else if (this._closeInstantDetails()) { }
                else if (this.endModalState(lastCommandName)) { }
                else if (this.get_backOnCancel() || !String.isNullOrEmpty(this._replaceTriggerViewId)) this.goBack(true);
                else {
                    this._notifyDesigner(true);
                    var actions = this.get_actions(this._get_lastActionScope(), true);
                    for (i = 0; i < actions.length; i++) {
                        var a = actions[i];
                        if (a.WhenLastCommandName == lastCommandName && (a.WhenLastCommandArgument == '' || a.WhenLastCommandArgument == lastCommandArgument) && this._isActionMatched(a)) {
                            this.set_lastCommandName(lastCommandName);
                            this.set_lastCommandArgument(lastCommandArgument);
                            this.executeCommand({ commandName: a.CommandName, commandArgument: a.CommandArgument, path: a.Path, causesValidation: a.CausesValidation, values: lastCommandName.match(/Insert|Custom/) ? this._lastArgs.Values : null });
                            this._pendingSelectedEvent = a.CommandName.match(/^(Edit|Select)/) != null;
                            this._notifyMaster();
                            return;
                        }
                    }
                    if (!stopFlow) {
                        this._pendingSelectedEvent = lastCommandName.match(/Update|Custom|SQL/);
                        this.set_lastCommandName(null);
                        if (this.get_isModal() && (!this.get_isForm(this._lastViewId) || this._closeViewDetails)/* this.get_viewType(this._lastViewId) != 'Form'*/)
                            this.endModalState('Cancel');
                        else
                            this.goToView(this._lastViewId);
                    }
                }
                this._notifyMaster();
            }
        }
        else {
            if (lastFocusedCell) {
                this._focusCell(-1, -1, false);
                this._focusCell(lastFocusedCell.rowIndex, lastFocusedCell.colIndex, true);
                this._lastFocusedCell = null;
                this._saveAndNew = false;
            }
            if (result.ClientScript) {
                result.ClientScript = this.resolveClientUrl(result.ClientScript);
                eval(result.ClientScript);
            }
            this._displayActionErrors(result);
        }
    },
    _get_lastActionScope: function () {
        var path = this._lastArgs ? this._lastArgs.Path : null;
        if (path) {
            var m = path.match(/^(\w+)\//);
            if (m) {
                var list = this._actionGroups;
                for (var i = 0; i < list.length; i++) {
                    var ag = list[i];
                    if (ag.Id == m[1])
                        return ag.Scope;
                }
            }
        }
        var viewType = this.get_viewType();
        if (viewType.match(/DataSheet|Tree/))
            viewType = 'Grid';
        return viewType;

    },
    _displayActionErrors: function (result) {
        if (result.Errors.length == 0) return;
        var sb = new Sys.StringBuilder();
        for (i = 0; i < result.Errors.length; i++)
            sb.append(Web.DataView.formatMessage('Attention', result.Errors[i]));
        Web.DataView.showMessage(sb.toString());
        sb.clear();
    },
    _busy: function (isBusy) {
        if (isBusy == null)
            return this._isBusy;
        this._isBusy = isBusy;
        this._enableButtons(!isBusy);
        if ($appfactory.isSaaS()) return;
        var that = this,
            mobile = $appfactory.mobile,
            interval = that._busyInterval,
            atWindowTop = !mobile && (that.get_isModal() || that.get_lookupField() != null || !this._controller),
            containerElement = mobile ? mobile.toolbar() : (atWindowTop ? document.body : that._container),
            $container = $(containerElement),
            $viewContainer = $(that._container);
        if (mobile && !mobile.toolbar().is(':visible')) {
            mobile.wait(isBusy);
            return;
        }
        if (isBusy && !interval) {
            if (!mobile && !$viewContainer.is('.dataview-loaded'))
                $viewContainer.addClass('dataview-loading');
            if (!atWindowTop) {
                //var innerContainer = $container.find('.HeaderRow');
                //if (innerContainer.length == 0)
                //    innerContainer = $container.find('.ActionRow').next();
                //if (innerContainer && innerContainer.length > 0)
                //    $container = innerContainer;
            }
            var w = $container.outerWidth() / 5;
            if (w > 200)
                w = 200;
            var $busy = that._$busy = $(String.format('<div class="dataview-busy-indicator{0}"></div>', atWindowTop ? ' modal' : ''))
                .css({ position: mobile ? 'fixed' : 'absolute', width: w, 'z-index': atWindowTop || mobile ? 3000000 : 0 }).appendTo(document.body),
                x = -w,
                h = atWindowTop ? 0 : $busy.height();
            $busy.hide();
            var counter = 0,
                fullyExtended = false;
            this._busyInterval = setInterval(function () {
                if (counter != null)
                    if (counter++ > 75) {
                        counter = null;
                        $busy.show();
                    }
                    else
                        return;
                x += w / 30;
                if (x >= 0) {
                    var containerWidth = $container.outerWidth();
                    if (x >= (containerWidth - w) && x < containerWidth)
                        $busy.width(containerWidth - x);
                    else if (x >= (containerWidth)) {
                        x = -w;
                    }
                    var scrollTop = $container.scrollTop();
                    $busy.position({ my: 'left top', at: String.format('left+{0} top{1}{2}', x, atWindowTop ? '+' : '-', atWindowTop ? $(window).scrollTop() : h), of: $container });
                }
                else {
                    $busy.width(w + x);
                    $busy.position({ my: 'left top', at: String.format('left top{0}{1}', atWindowTop ? '+' : '-', atWindowTop ? $(window).scrollTop() : h), of: $container });
                }

            }, 10);
        }
        else if (interval) {
            if (!mobile && !$viewContainer.is('.dataview-loaded'))
                $viewContainer.removeClass('dataview-loading').addClass('dataview-loaded');
            clearInterval(interval);
            that._busyInterval = null;
            $busy = that._$busy;
            if ($busy) {
                var busyOffset = $busy.offset();
                var containerOffset = $container.offset();
                that._$busy = null;
                $busy.width($container.outerWidth() - (busyOffset.left - containerOffset.left));
                setTimeout(function () { $busy.remove(); }, 500);
            }
        }
    },
    _enableButtons: function (enable) {
        //var buttons = this._element.getElementsByTagName('button');
        //for (var i = 0; i < buttons.length; i++) {
        //    var b = buttons[i];
        //    if (b)
        //        if (!enable) {
        //            b.WasDisabled = true;
        //            //b.disabled = true;
        //        }
        //        else if (b.WasDisabled) {
        //            b.WasDisabled = false;
        //            //b.disabled = false;
        //        }
        //}
        //buttons = null;
        if ($appfactory.mobile) return;
        var $buttons = $('button', this._element)
            .each(function (index) {
                $(this).toggleClass('disabled', !enable);
            });
    },
    _bodyKeydown: function (e) {
        var preventDefault = false;
        if (this._customFilterField) {
            if (e.keyCode == Sys.UI.Key.enter) {
                preventDefault = true;
                this.applyCustomFilter();
            }
            else if (e.keyCode == Sys.UI.Key.esc) {
                preventDefault = true;
                this.closeCustomFilter();
            }
        }
        else if (this.get_lookupField())
            if (e.keyCode == Sys.UI.Key.esc) {
                preventDefault = true;
                this.hideLookup();
            }
        if (preventDefault) {
            e.preventDefault();
            e.stopPropagation();
        }
    },
    _prepareJavaScriptExpressionEx: function (script) {
        return script.replace(/\[((\w+)\.)?(\w+)\]/g, 'this.fieldValue(\'$3\',\'$2\')');
    },
    _evaluateVisibility: function () {
        var script = this.get_visibleWhen();
        if (String.isNullOrEmpty(script))
            return true;
        script = this._prepareJavaScriptExpressionEx(script);
        return eval(script) != false;
    },
    _filterSourceSelected: function (sender, args, keepContext) {
        this._hidden = !this._evaluateVisibility();
        var vitals = this.readContext('vitals');
        if (vitals) {
            var i = 0;
            while (i < vitals.Filter.length) {
                var filterExpression = vitals.Filter[i];
                var filterFieldName = filterExpression.substring(0, filterExpression.indexOf(':'));
                var isKey = false;
                if (this._keyFields)
                    for (var j = 0; j < this._keyFields.length; j++)
                        if (this._keyFields[j].Name == filterFieldName) {
                            isKey = true;
                            break;
                        }
                if (isKey)
                    Array.removeAt(vitals.Filter, i);
                else
                    i++;
            }
            this.writeContext('vitals', vitals);
        }
        var oldValues = [];
        for (i = 0; i < this._externalFilter.length; i++) {
            Array.add(oldValues, this._externalFilter[i].Value);
            this._externalFilter[i].Value = null;
        }
        var forceHide = false;
        var forceChanged = false;
        if (Web.DataView.isInstanceOfType(sender)) {
            if (!String.isNullOrEmpty(this._transaction))
                this.set_transaction(sender.get_transaction());
            this._populateExternalViewFilter(sender);
            forceHide = !sender.get_showDetailsInListMode() && sender.get_isGrid()/*sender.get_viewType() == 'Grid'*/;
            if (sender._forceChanged)
                forceChanged = true;
        }
        else if (this._externalFilter.length > 0)
            this._externalFilter[0].Value = sender.target.value;
        this.applyExternalFilter();
        var emptySourceFilter = true;
        var sourceFilterChanged = false;
        for (i = 0; i < this._externalFilter.length; i++) {
            var v = this._externalFilter[i].Value;
            if (v != null) emptySourceFilter = false;
            if (v != oldValues[i]) sourceFilterChanged = true;
        }
        if (this.get_autoHide() != Web.AutoHideMode.Nothing)
            this._updateLayoutContainerVisibility(!emptySourceFilter && !forceHide && !this._hidden);
        if (sourceFilterChanged || forceChanged) {
            if (!keepContext)
                this.set_pageIndex(-1);
            var p = this._position;
            if (p) {
                p.index = 0;
                p.count = -1;
                p.key = [];
                p.keyFilter = [];
                p.filter = this.get_filter();
            }
            if (!keepContext) {
                this._selectedKey = [];
                this._selectedKeyFilter = [];
            }
            this._clearCache();
            this.loadPage();
        }
        this.raiseSelected();
        this.updateSummary();
    },
    _createExternalFilter: function () {
        this._externalFilter = [];
        var iterator = /(\w+)(,|$)/g;
        if (this.get_filterFields()) {
            var fieldNames = this.get_filterFields().split(Web.DataView._simpleListRegex);
            for (var i = 0; i < fieldNames.length; i++)
                Array.add(this._externalFilter, { Name: fieldNames[i], Value: null });
        }
    },
    _populateExternalViewFilter: function (view) {
        if (!(view._selectedKey && view._keyFields && view._selectedKey.length == view._keyFields.length)) return;
        for (var i = 0; i < this._externalFilter.length; i++) {
            var filterItem = this._externalFilter[i];
            var found = false;
            for (var j = 0; j < view._keyFields.length; j++) {
                var field = view._keyFields[j];
                if (filterItem.Name == field.Name) {
                    filterItem.Value = view.convertFieldValueToString(field, view._selectedKey[j]);
                    found = true;
                    break;
                }
            }
            if (!found && this.get_controller() != view.get_controller())
                for (j = 0; j < view._allFields.length; j++) {
                    field = view._allFields[j];
                    if (filterItem.Name == field.Name) {
                        filterItem.Value = view.convertFieldValueToString(field, view.get_selectedRow()[view._allFields[j].Index]);
                        found = true;
                        break;
                    }
                }
            if (!found && view._selectedKey.length >= i)
                filterItem.Value = view._selectedKey[i];
        }
    },
    _cloneChangedRow: function () {
        if (this.get_isEditing()) {
            var values = this._collectFieldValues();
            var selectedRow = this.get_currentRow();
            var row = selectedRow ? Array.clone(selectedRow) : null;
            var designer = __designer();
            for (var i = 0; i < values.length; i++) {
                var v = values[i];
                var f = this.findField(v.Name);
                if (f/* && !f.ReadOnly*/)
                    row[f.Index] = designer ? (v.Modified ? v.NewValue : v.OldValue) : v.NewValue;
            }
            return row;
        }
        else
            return this.get_selectedRow();
    },
    _updateVisibility: function (row) {
        if (!this._expressions) return;
        this._readOnlyChanged = false;
        var isForm = this.get_isForm();
        var expressions = [];
        if (!row)
            row = this._cloneChangedRow();
        if (!row) return;
        var changed = false;
        var checkTabs = false;
        for (var i = 0; i < this._expressions.length; i++) {
            var exp = expressions[0] = this._expressions[i];
            if (exp.Type == Web.DynamicExpressionType.ClientScript)
                if (exp.Scope == Web.DynamicExpressionScope.DataFieldVisibility) {
                    var f = this.findField(exp.Target);
                    if (f) {
                        var elem = this._get(isForm ? '_ItemContainer' : 'Item', f.Index);
                        if (elem) {
                            var result = this._evaluateJavaScriptExpressions(expressions, row, false);
                            if (isForm) {
                                var isVisible = Sys.UI.DomElement.getVisible(elem);
                                if (Sys.UI.DomElement.containsCssClass(elem.parentNode, 'FieldPlaceholder')) elem = elem.parentNode;
                                else if (Sys.UI.DomElement.containsCssClass(elem.parentNode.parentNode, 'FieldWrapper')) elem = elem.parentNode.parentNode.parentNode.parentNode;
                                Sys.UI.DomElement.setVisible(elem, result == true);
                                if (isVisible != result) changed = true;
                            }
                        }
                    }
                }
                else if (exp.Scope == Web.DynamicExpressionScope.CategoryVisibility) {
                    var c = this.findCategory(exp.Target);
                    if (c) {
                        elem = this._get('_Category', c.Index);
                        if (elem) {
                            c.IsVisible = this._evaluateJavaScriptExpressions(expressions, row, false);
                            result = c.IsVisible && (String.isNullOrEmpty(c.Tab) || c.Tab == this._get_selectedTab());
                            isVisible = Sys.UI.DomElement.getVisible(elem);
                            Sys.UI.DomElement.setVisible(elem, result == true);

                            if (isVisible != result) changed = true;
                            var catDescriptionCell = this._get('$CategoryDescription$', c.Index);
                            if (catDescriptionCell) {
                                var descriptionText = this._processTemplatedText(row, c.Description);
                                catDescriptionCell.innerHTML = descriptionText;
                                catDescriptionCell.style.display = String.isNullOrEmpty(descriptionText) ? 'none' : 'block';
                            }
                            if (!String.isNullOrEmpty(c.Tab))
                                checkTabs = true;
                            //                            if (changed || true) {
                            //                                if (!String.isNullOrEmpty(c.Tab)) {
                            //                                    var tabIndex = Array.indexOf(this._tabs, c.Tab);
                            //                                    var tabElem = this._get('_Tab', tabIndex);
                            //                                    var tabIsVisible = Sys.UI.DomElement.getVisible(tabElem);
                            //                                    if (tabElem) {
                            //                                        var hideTab = true;
                            //                                        for (var j = 0; i < this.get_categories().length; i++) {
                            //                                            var peerCategory = this.get_categories()[j];
                            //                                            if (peerCategory != c && c.Tab == peerCategory.Tab && tabIsVisible) {
                            //                                                hideTab = false;
                            //                                                break;
                            //                                            }
                            //                                        }
                            //                                        if (hideTab)
                            //                                            Sys.UI.DomElement.setVisible(tabElem, false);
                            //                                        else
                            //                                            Sys.UI.DomElement.setVisible(tabElem, true);
                            //                                    }
                            //                                }
                            //                            }
                        }
                    }
                }
                else if (exp.Scope == Web.DynamicExpressionScope.ReadOnly) {
                    f = this.findField(exp.Target);
                    if (f) {
                        if (f.OriginalTextMode == null)
                            f.OriginalTextMode = f.TextMode;
                        var isReadOnly = f.isReadOnly();
                        result = this._evaluateJavaScriptExpressions(expressions, row, false);
                        f.TextMode = result == true ? 4 : f.OriginalTextMode;
                        if (result != isReadOnly) {
                            changed = true;
                            this._readOnlyChanged = true;
                        }
                    }
                }
        }
        if (checkTabs)
            for (i = 0; i < this._tabs.length; i++) {
                var tab = this._tabs[i];
                var dynamicVisibility = false;
                var tabIsVisible = false;
                for (var j = 0; j < this._categories.length; j++) {
                    c = this._categories[j];
                    if (c.Tab == tab && c.IsVisible != null) {
                        dynamicVisibility = true;
                        tabIsVisible = c.IsVisible;
                        if (tabIsVisible)
                            break;
                    }
                }
                if (dynamicVisibility)
                    Sys.UI.DomElement.setVisible(this._get('_Tab', i), tabIsVisible);
            }
        if (this._dynamicActionButtons) {
            this._clonedRow = row;
            var topActionButtons = this._get('$ActionButtons$', 'Top');
            if (topActionButtons) {
                var sb = new Sys.StringBuilder();
                this._internalRenderActionButtons(sb, 'Top', this._lastActionButtonsScope);
                this._newTopActionButtons = sb.toString();
                sb.clear();
            }
            var bottomActionButtons = this._get('$ActionButtons$', 'Bottom');
            if (bottomActionButtons) {
                sb = new Sys.StringBuilder();
                this._internalRenderActionButtons(sb, 'Bottom', this._lastActionButtonsScope);
                this._newBottomActionButtons = sb.toString();
                sb.clear();
            }
            var self = this;
            setTimeout(function () {
                self._refreshActionButtons();
            }, 500);
            this._clonedRow = null;
        }
        this._updateStatusBar();
        if (changed) {
            this._adjustModalHeight();
            if (this._modalPopup)
                this._modalPopup.show();
            _body_performResize();
        }
        if (this.get_isEditing() && !this._lookupIsActive) {
            var cell = this._get_focusedCell();
            for (i = 0; i < this._fields.length; i++) {
                f = this._fields[i];
                if (!f.ReadOnly && !f.Hidden && f.AutoSelect && f.ItemsStyle == 'Lookup' && (cell == null || cell.colIndex == f.ColIndex)) {
                    f.AutoSelect = false;
                    v = row[f.Index];
                    if (v == null) {
                        this._lookupIsActive = true;
                        self = this;
                        setTimeout(function () {
                            self.showLookup(f.Index);
                        }, 100);
                        break;
                    }
                }
            }
        }
    },
    _refreshActionButtons: function () {
        var topActionButtons = this._get('$ActionButtons$', 'Top');
        if (topActionButtons && this._newTopActionButtons) {
            topActionButtons.innerHTML = this._newTopActionButtons;
            this._newTopActionButtons = null;
        }
        var bottomActionButtons = this._get('$ActionButtons$', 'Bottom');
        if (bottomActionButtons && this._newBottomActionButtons) {
            bottomActionButtons.innerHTML = this._newBottomActionButtons;
            this._newBottomActionButtons = null;
        }
    },
    _updateDynamicValues: function (field) {
        var done = false;
        var allFields = this._allFields;
        var fieldName = field && field.Name ? field.Name : field;
        for (var i = 0; i < allFields.length; i++) {
            var f = allFields[i];
            var hasContextFields = !String.isNullOrEmpty(f.ContextFields);
            if (hasContextFields) {
                //                var m = f.ContextFields.match(/\w+=(\w+)/);
                //                if (f.ItemsAreDynamic && (field == null || m && m[1] == field.Name)) {
                //                    this._raisePopulateDynamicLookups();
                //                    break;
                //                }
                //                else if (f.Calculated && f.ContextFields.match(field.Name))
                //                    this._raiseCalculate(f);
                var iterator = /\s*(\w+)\s*(=\s*(\w+)\s*)?(,|$)/g;
                var m = iterator.exec(f.ContextFields);
                while (m) {
                    if (f.ItemsAreDynamic && (field == null || m[3] == /*field.Name*/fieldName)) {
                        if (!this.get_isEditing()) {
                            this.refresh();
                            return true;
                        }
                        this._raisePopulateDynamicLookups();
                        done = true;
                    }
                    else if (f.Calculated && m[1] == /*field.Name*/fieldName) {
                        if (!this.get_isEditing()) {
                            this.refresh();
                            return true;
                        }
                        this._raiseCalculate(f, field);
                        done = true;
                    }
                    if (done) break;
                    m = iterator.exec(f.ContextFields);
                }
                if (done) break;
            }
        }
        return done;
    },
    _valueFocused: function (index) {
        var field = this._allFields[index];
        this._focusedFieldName = field.Name;
        Web.DataView._focusedDataViewId = this._id;
        Web.DataView._focusedItemIndex = index;
    },
    _resetContextLookupValues: function (field) {
        var values = [];
        var map = []
        this._enumerateContextFieldValues(field, values, map);
        var result = values.length > 0;
        if (result)
            this.refresh(true, values);
        return result;
    },
    _enumerateContextFieldValues: function (field, values, map) {
        var fieldName = field.Name;
        var allFields = this._allFields;
        for (var i = 0; i < allFields.length; i++) {
            var f = allFields[i];
            var contextFields = f.ContextFields;
            if (!String.isNullOrEmpty(contextFields) && !map[i] && !String.isNullOrEmpty(f.ItemsStyle)) {
                var iterator = /\s*(\w+)\s*(=\s*(\w+)\s*)?(,|$)/g;
                var m = iterator.exec(contextFields);
                while (m) {
                    if (m[1] == fieldName) {
                        map[i] = true;
                        Array.add(values, { 'name': f.Name, 'value': null });
                        var aliasField = allFields[f.AliasIndex];
                        if (aliasField != f)
                            Array.add(values, { 'name': aliasField.Name, 'value': null });
                        f.DynamicItems = null;
                        this._enumerateContextFieldValues(f, values, map);
                    }
                    m = iterator.exec(contextFields);
                }
            }
        }
    },
    _copyStaticLookupValues: function (field) {
        if (!String.isNullOrEmpty(field.Copy) && (field.ItemsStyle == 'RadioButtonList' || field.ItemsStyle == 'ListBox' || field.ItemsStyle == 'DropDownList')) {
            var currentRow = this._collectFieldValues();
            var selectedValue = currentRow[field.Index].NewValue;
            if (selectedValue != null && typeof (selectedValue) != 'string')
                selectedValue = selectedValue.toString();
            var selectedItem = null;
            for (var i = 0; i < field.Items.length; i++) {
                var item = field.Items[i];
                var itemValue = item[0];
                if (itemValue != null && typeof (itemValue) != 'string') itemValue = itemValue.toString();
                if (itemValue == selectedValue) {
                    selectedItem = item;
                    break;
                }
            }
            if (selectedItem) {
                var values = [];
                var iterator = /(\w+)=(\w+)/g;
                var index = 2;
                var m = iterator.exec(field.Copy);
                while (m) {
                    Array.add(values, { 'name': m[1], 'value': selectedItem[index++] });
                    m = iterator.exec(field.Copy);
                }
                this.refresh(true, values);
                return true;
            }
        }
        return false;
    },
    _replaceFieldValue: function (field) {
        var expressions = this._enumerateExpressions(Web.DynamicExpressionType.RegularExpression, Web.DynamicExpressionScope.Field, field.Name);
        for (var j = 0; j < expressions.length; j++) {
            var exp = expressions[j];
            try {
                if (exp.Result.match(/\$(\d|\'\`)/)) {
                    var currentRow = this._collectFieldValues();
                    var v = currentRow[field.Index];
                    var s = v.NewValue ? v.NewValue.toString() : null;
                    var re = new RegExp(exp.Test);
                    var s2 = s.replace(re, exp.Result);
                    if (s2 != s) {
                        var values = [{ 'name': field.Name, 'value': s2}];
                        this.refresh(true, values);
                    }
                }
            }
            catch (ex) {
            }
        }
    },
    _valueChanged: function (index) {
        var field = this._allFields[index];
        this._showFieldError(field, null);
        this._skipErrorReset = false;
        var self = this;
        setTimeout(function () {
            if (!Web.DataView._navigated)
                self._performValueChanged(index, true);
        }, 200);
    },
    _performValueChanged: function (index, processReadOnly) {
        var field = this._allFields[index];
        if (!field) return;
        if (this._skipErrorReset) {
            this._skipErrorReset = false;
            return;
        }
        else
            this._showFieldError(field, null);
        this._replaceFieldValue(field);
        var r3 = this._resetContextLookupValues(field);
        var r1 = this._copyStaticLookupValues(field);
        this._updateVisibility();
        var r2 = this._updateDynamicValues(field);
        if (processReadOnly && this._readOnlyChanged && this.get_isEditing()) {
            this.refresh(true);
            this._focus();
        }
        return r1 || r2 || r3 || this._readOnlyChanged;
    },
    _quickFind_focus: function (e) {
        var qf = this.get_quickFindElement();
        if (qf.value == Web.DataViewResources.Grid.QuickFindText)
            qf.value = '';
        Sys.UI.DomElement.removeCssClass(qf, 'Empty');
        Sys.UI.DomElement.removeCssClass(qf, 'NonEmpty');
        qf.select();
        this._lostFocus = true;
    },
    _quickFind_blur: function (e) {
        var qf = this.get_quickFindElement();
        if (String.isBlank(qf.value)) {
            qf.value = Web.DataViewResources.Grid.QuickFindText;
            Sys.UI.DomElement.addCssClass(qf, 'Empty');
        }
        else
            Sys.UI.DomElement.addCssClass(qf, 'NonEmpty');
        this._lostFocus = false;
    },
    _executeQuickFind: function (qry) {
        this._forceSync();
        for (var i = 0; i < this._allFields.length; i++)
            this._allFields[i]._listOfValues = null;
        for (i = 0; i < this._allFields.length; i++) {
            var f = this._allFields[i];
            if (!f.Hidden) {
                f = this._allFields[f.AliasIndex];
                if (String.isNullOrEmpty(qry)) {
                    this.removeFromFilter(f);
                    this.refreshData();
                    //                    this.set_pageIndex(-2);
                    //                    this._loadPage();
                }
                else
                    this.applyFilter(f, '~', qry);
                break;
            }
        }
        //this._forgetSelectedRow(true);
    },
    quickFind: function (sample) {
        var q = (String.isNullOrEmpty(sample) ? this.get_quickFindElement().value : sample).match(/^\s*(.*?)\s*$/);
        var qry = q[1] == Web.DataViewResources.Grid.QuickFindText ? '' : q[1];
        this.set_quickFindText(qry);
        this._executeQuickFind(qry);
        this._lostFocus = false;
    },
    _quickFind_keydown: function (e) {
        if (e.keyCode == Sys.UI.Key.enter) {
            e.preventDefault();
            e.stopPropagation();
            this.quickFind();
        }
        else if (e.keyCode == Sys.UI.Key.down) {
            return;
            if (this.get_isDataSheet() && this._totalRowCount > 0) {
                e.preventDefault();
                e.stopPropagation();
                if (!this._get_focusedCell())
                    this._startInputListenerOnCell(0, 0);
                else
                    this._lostFocus = false;
                var elem = this._focusCell(-1, -1, true);
                elem.focus();
            }
        }
    },
    encodePermalink: function (link, target, features) {
        Sys.Net.WebServiceProxy.invoke(this.get_servicePath(), 'EncodePermalink', false, { 'link': link, 'rooted': false }, Function.createDelegate(this, this._encodePermalink_Success), Function.createDelegate(this, this._onMethodFailed), { 'target': target, 'features': features });
    },
    _encodePermalink_Success: function (result, context) {
        if (context.target || context.features)
            open(result, context.target, context.features)
        else
            location.href = result;
    },
    showViewMessage: function (message) {
        var elem = this._get('$HeaderText');
        if (elem != null && message) {
            var headerText = String.format('<div class="MsgBox">{1} <a href="javascript:" onclick="$find(\'{0}\').hideViewMessage();return false;" class="Close" title="{2}">&nbsp;</a></div>', this.get_id(), message, Web.DataViewResources.ModalPopup.Close);
            var view = this.get_view();
            if (!view.OriginalHeaderText)
                view.OriginalHeaderText = view.HeaderText;
            view.HeaderText = headerText;
            elem.innerHTML = headerText;
            if (!this._viewMessages)
                this._viewMessages = {};
            this._viewMessages[view.Id] = message;

        }
    },
    hideViewMessage: function () {
        var elem = this._get('$HeaderText');
        if (elem != null) {
            var view = this.get_view();
            var text = view.OriginalHeaderText;
            view.HeaderText = text;
            elem.innerHTML = this._formatViewText(Web.DataViewResources.Views.DefaultDescriptions[text], true, text);
            this._viewMessages[view.Id] = null;
        }
    }
}

Web.DataView.registerClass('Web.DataView', Sys.UI.Behavior);

Web.AutoComplete = function (element) {
    Web.AutoComplete.initializeBase(this, [element]);
}

Web.AutoComplete.prototype = {
    initialize: function () {
        Web.AutoComplete.callBaseMethod(this, 'initialize');
        this._textBoxMouseOverHandler = Function.createDelegate(this, this._onTextBoxMouseOver);
        this._textBoxMouseOutHandler = Function.createDelegate(this, this._onTextBoxMouseOut);
        this._completionListItemCssClass = 'Item';
        this._highlightedItemCssClass = 'HighlightedItem'
    },
    dispose: function () {
        this._viewPage = null;
        if (this._element) {
            $removeHandler(this._element, 'mouseover', this._textBoxMouseOverHandler);
            $removeHandler(this._element, 'mouseout', this._textBoxMouseOutHandler);
        }
        Web.AutoComplete.callBaseMethod(this, 'dispose');
    },
    get_fieldName: function () {
        return this._fieldName;
    },
    set_fieldName: function (value) {
        this._fieldName = value;
    },
    updated: function () {
        var f = document.createElement('div');
        f.className = 'AutoCompleteFrame ' + this.get_typeCssClass();
        f.innerHTML = String.format('<table><tr><td class="Input"></td><td class="Clear" style="{2}"><span class="Clear" onclick="var e=this.parentNode.parentNode.getElementsByTagName(\'input\')[0];e.value=\'\';e.focus()" title="{1}">&nbsp;</span></td><td class="Button" onmouseover="if(!Sys.UI.DomElement.containsCssClass(this.parentNode, \'Active\'))$find(\'{0}\')._showDropDown(true)" onmouseout="$find(\'{0}\')._showDropDown(false)"><span class="Button" onclick="$find(\'{0}\')._showFullList();">&nbsp;</span></td></tr></table>', this.get_id(), Web.DataViewResources.Data.Filters.Labels.Clear, this.get_contextKey().match(/^(SearchBar|Filter)\:/) != null ? '' : 'display:none');
        this._element.setAttribute('autocomplete', 'off');
        this._element.parentNode.insertBefore(f, this._element);
        f.getElementsByTagName('td')[0].appendChild(this._element);
        if (Sys.Browser.agent == Sys.Browser.WebKit)
            f.style.marginLeft = '2px';
        if (this._completionSetCount == 10)
            this._completionSetCount = 100;
        $addHandler(this._element, 'mouseover', this._textBoxMouseOverHandler);
        $addHandler(this._element, 'mouseout', this._textBoxMouseOutHandler);
        Web.AutoComplete.callBaseMethod(this, 'updated');
        document.body.appendChild(this._completionListElement);
        this._completionListElement.className = 'CompletionList AutoComplete';
        this._completionListElement.style.display = 'none';
    },
    _showCachedFullList: function () {
        this._update('%', this._cache['%'], false);
    },
    _showFullList: function () {
        if (this._webRequest) return;
        var visible = this._popupBehavior.get_visible();
        this._hideCompletionList();
        this._element.focus();
        if (visible) return;
        this._completionWord = '%';
        if (this._cache && this._cache['%']) {
            var self = this;
            setTimeout(function () {
                self._showCachedFullList();
            }, 50);
            return;
        }
        var params = { prefixText: this._completionWord, count: this._completionSetCount };
        if (this._useContextKey) params.contextKey = this._contextKey;
        this._ignoreCompletionWord = true;
        this._invoke(params, this._completionWord);
    },
    _showDropDown: function (show) {
        var e = this._element;
        while (e.tagName != 'TR')
            e = e.parentNode;
        if (show)
            Sys.UI.DomElement.addCssClass(e, 'Active');
        else if (this._textBoxHasFocus)
            Sys.UI.DomElement.addCssClass(e, 'Active');
        else
            Sys.UI.DomElement.removeCssClass(e, 'Active');
    },
    _onKeyDown: function (ev) {
        if (ev.keyCode == Sys.UI.Key.down && ev.altKey) {
            ev.preventDefault();
            ev.stopPropagation();
            this._showFullList();
        }
        var popupVisible = this._popupBehavior._visible;
        Web.AutoComplete.callBaseMethod(this, '_onKeyDown', [ev]);
        if (ev.keyCode == Sys.UI.Key.enter || ev.keyCode == Sys.UI.Key.esc) {
            var dataView = this._get_fieldDataView(true);
            if (dataView)
                if (dataView.get_isDataSheet() && popupVisible) {
                    ev.preventDefault();
                    ev.stopPropagation();
                }
                else if (dataView.get_searchBarIsVisible()) {
                    ev.preventDefault();
                    ev.stopPropagation();
                    if (!popupVisible)
                        setTimeout(function () {
                            dataView._performSearch();
                        }, 100);
                }
        }
    },
    _update: function (prefixText, completionItems, cacheResults) {
        Web.AutoComplete.callBaseMethod(this, '_update', [prefixText, completionItems, cacheResults]);
        if (completionItems) {
            var index = -1;
            var w = this._currentCompletionWord().toLowerCase();
            for (var i = 0; i < completionItems.length; i++) {
                var s = completionItems[i];
                if (s != null) {
                    s = s.toLowerCase();
                    if (index == -1 && s.startsWith(w))
                        index = i;
                    if (s == w) {
                        index = i;
                        break;
                    }
                }
            }
            //var index = Array.indexOf(completionItems, this._currentCompletionWord());
            if (index >= 0 && index < this._completionListElement.childNodes.length) {
                this._selectIndex = index;
                w = this._completionListElement.childNodes[index];
                this._highlightItem(w);
                this._handleScroll(w, index + 5);
            }
        }
    },
    _get_fieldDataView: function (allTypes) {
        var dataView = null;
        var info = this._get_contextInfo();
        if (info && (info.type == 'Field' || allTypes && info.type == 'SearchBar'))
            dataView = Web.DataView.find(info.controller);
        return dataView;
    },
    _setText: function (item) {
        Web.AutoComplete.callBaseMethod(this, '_setText', [item]);
        this._updateClearButton();
        //var info = this._get_contextInfo();
        var dataView = this._get_fieldDataView();
        if (dataView/*info && info.type == 'Field'*/) {
            //var dataView = Web.DataView.find(info.controller);
            var field = dataView.findField(this.get_fieldName());
            var w = this.get_element().value;
            var values = [];
            if (w != Web.DataViewResources.Data.NullValueInForms) {
                var index = this._enumerateViewPageItems(w);
                if (index != -1) {
                    var page = this._viewPage;
                    var r = page.Rows[index];
                    var valueFields = [];
                    for (var i = 0; i < page.Fields.length; i++) {
                        var f = page.Fields[i];
                        if (f.Name == field.ItemsDataValueField)
                            Array.add(valueFields, f);
                    }
                    if (valueFields.length == 0)
                        for (i = 0; i < page.Fields.length; i++) {
                            f = page.Fields[i];
                            if (f.IsPrimaryKey) {
                                Array.add(valueFields, f);
                                break;
                            }
                        }
                    for (i = 0; i < valueFields.length; i++) {
                        var v = r[valueFields[0].Index]
                        Array.add(values, v);
                    }
                }
            }
            $get(dataView.get_id() + '_Item' + field.Index).value = values.toString();
            this._originalElementText = this.get_element().value;
            if (this._get_isInLookupMode()) {
                if (!String.isNullOrEmpty(field.Copy)) {
                    values = [];
                    var iterator = /(\w+)=(\w+)/g;
                    var m = iterator.exec(field.Copy);
                    while (m) {
                        if (m[2] == 'null')
                            Array.add(values, { 'name': m[1], 'value': null });
                        else
                            for (i = 0; i < page.Fields.length; i++) {
                                if (page.Fields[i].Name == m[2])
                                    Array.add(values, { 'name': m[1], 'value': r[i] });
                            }
                        m = iterator.exec(field.Copy);
                    }
                    dataView.refresh(true, values);
                }
                dataView._valueChanged(field.Index);
            }
        }
    },
    _get_isInLookupMode: function () {
        var info = this._get_contextInfo();
        return info != null && info.type == 'Field';
    },
    _updateClearButton: function () {
        var tr = this._element.parentNode.parentNode;
        if (!String.isBlank(this._element.value))
            Sys.UI.DomElement.addCssClass(tr, 'Filtered');
        else
            Sys.UI.DomElement.removeCssClass(tr, 'Filtered');
    },
    _onGotFocus: function (ev) {
        Web.AutoComplete.callBaseMethod(this, '_onGotFocus', [ev]);
        this._showDropDown(true);
        this._updateClearButton();
        if (this._get_isInLookupMode()) {
            var elem = this.get_element();
            this._originalElementText = elem.value;
            if (this._originalElementText == Web.DataViewResources.Data.NullValueInForms) {
                elem.value = '';
                elem.select();
            }
        }
    },
    _onLostFocus: function (ev) {
        Web.AutoComplete.callBaseMethod(this, '_onLostFocus', [ev]);
        this._showDropDown(false);
        this._updateClearButton();
        if (this._get_isInLookupMode() && this._originalElementText != null)
            this.get_element().value = this._originalElementText;
    },
    _onTextBoxMouseOver: function (ev) {
        this._showDropDown(true);
    },
    _onTextBoxMouseOut: function (ev) {
        this._showDropDown(false);
    },
    _currentCompletionWord: function () {
        if (this._completionWord) {
            var w = this._completionWord;
            this._completionWord = null;
            return w;
        }
        return Web.AutoComplete.callBaseMethod(this, '_currentCompletionWord');
    },
    _onTimerTick: function (sender, eventArgs) {
        // turn off the timer until another key is pressed.
        this._timer.set_enabled(false);
        if (this._servicePath && this._serviceMethod) {
            var text = this._currentCompletionWord();

            if (text.trim().length < this._minimumPrefixLength) {
                this._currentPrefix = null;
                this._update('', null, /* cacheResults */false);
                return;
            }
            // there is new content in the textbox or the textbox is empty but the min prefix length is 0
            if ((this._currentPrefix !== text) || ((text == "") && (this._minimumPrefixLength == 0))) {
                this._currentPrefix = text;
                if ((text != "") && this._cache && this._cache[text]) {
                    this._update(text, this._cache[text], /* cacheResults */false);
                    return;
                }
                // Raise the populating event and optionally cancel the web service invocation
                eventArgs = new Sys.CancelEventArgs();
                this.raisePopulating(eventArgs);
                if (eventArgs.get_cancel()) {
                    return;
                }

                // Create the service parameters and optionally add the context parameter
                // (thereby determining which method signature we're expecting...)
                var params = { prefixText: this._currentPrefix, count: this._completionSetCount };
                if (this._useContextKey) {
                    params.contextKey = this._contextKey;
                }

                if (this._webRequest) {
                    // abort the previous web service call if we 
                    // are issuing a new one and the previous one is 
                    // active.
                    this._webRequest.get_executor().abort();
                    this._webRequest = null;
                }
                // Invoke the web service
                this._invoke(params, text);
                $common.updateFormToRefreshATDeviceBuffer();
            }
        }
    },
    _get_contextInfo: function () {
        var m = this.get_contextKey().match(/^(\w+)\:(\w+),(\w+)$/);
        return m ? { 'type': m[1], 'controller': m[2], 'fieldName': m[3]} : null;
    },
    _invoke: function (params, text) {
        var info = this._get_contextInfo();
        if (info) {
            var dataView = Web.DataView.find(info.controller);
            var filter = [];
            var searchFieldName = info.fieldName;
            var operation = 'beginswith';
            if (info.type == 'SearchBar')
                filter = dataView._createSearchBarFilter(true);
            else if (info.type == 'Filter')
                filter = dataView.get_filter();
            else {
                var field = dataView.findField(this.get_fieldName());
                searchFieldName = !String.isNullOrEmpty(field.ItemsDataTextField) ? field.ItemsDataTextField : field.Name;
            }
            if (!this._ignoreCompletionWord) {
                for (var i = 0; i < filter.length; i++) {
                    var fm = filter[i].match(/^(\w+):/);
                    if (fm[1] == info.fieldName) {
                        Array.removeAt(filter, i);
                        break;
                    }
                }
                if (!field)
                    field = dataView.findField(searchFieldName);
                if (field && field.AutoCompleteAnywhere)
                    operation = 'contains';
                Array.add(filter, String.format('{0}:${1}${2}\0', searchFieldName, operation, this._currentCompletionWord()));
            }
            var r = null;
            var sourceController = null;
            var sourceView = null;
            if (info.type == 'Field') {
                sourceController = field.ItemsDataController;
                sourceView = field.ItemsDataView;
                var lc = { 'FieldName': field.Name, 'Controller': dataView.get_controller(), 'View': dataView.get_viewId() };
                var contextFilter = dataView.get_contextFilter(field);
                for (i = 0; i < contextFilter.length; i++) {
                    var cfv = contextFilter[i];
                    Array.add(filter, String.format('{0}:={1}\0', cfv.Name, cfv.Value));
                }
                r = {
                    PageIndex: 0,
                    RequiresMetaData: true,
                    RequiresRowCount: false,
                    PageSize: 300,
                    SortExpression: field.ItemsDataTextField,
                    Filter: filter,
                    ContextKey: dataView.get_id(),
                    Cookie: dataView.get_cookie(),
                    FilterIsExternal: contextFilter.length > 0,
                    Transaction: dataView.get_transaction(),
                    LookupContextFieldName: lc ? lc.FieldName : null,
                    LookupContextController: lc ? lc.Controller : null,
                    LookupContextView: lc ? lc.View : null,
                    LookupContext: lc,
                    View: dataView.get_viewId(),
                    Tag: dataView.get_tag(),
                    ExternalFilter: contextFilter
                };
            }
            else {
                sourceController = dataView.get_controller();
                sourceView = dataView.get_viewId();
                r = {
                    FieldName: info.fieldName,
                    Filter: /*filter.length == 1 && filter[0].match(/(\w+):/)[1] == m[3] ? null : */filter,
                    LookupContextFieldName: lc ? lc.FieldName : null,
                    LookupContextController: lc ? lc.Controller : null,
                    LookupContextView: lc ? lc.View : null,
                    AllowFieldInFilter: this._ignoreCompletionWord != true,
                    Controller: sourceController,
                    View: sourceView,
                    Tag: dataView.get_tag(),
                    ExternalFilter: dataView.get_externalFilter()
                };
            }
            dataView._busy(true);
            var that = this;
            this._webRequest = dataView._invoke(this.get_serviceMethod(), { controller: sourceController, view: sourceView, request: r },
                Function.createDelegate(this,
                    info.type == 'Field' ?
                        function (result, context) {
                            dataView._busy(false);
                            that._onGetPageComplete(result, context);
                        } :
                        function (result, context) {
                            dataView._busy(false);
                            that._onGetListOfValuesComplete(result, context);
                        }),
                text);
            this._ignoreCompletionWord = false;
        }
        else
            this._webRequest = Sys.Net.WebServiceProxy.invoke(this.get_servicePath(), this.get_serviceMethod(), false, params,
                                            Function.createDelegate(this, this._onMethodComplete),
                                            Function.createDelegate(this, this._onMethodFailed),
                                            text);
    },
    _onGetListOfValuesComplete: function (result, context) {
        if (result.length > 0 && result[0] == null)
            result[0] = Web.DataViewResources.HeaderFilter.EmptyValue;
        this._webRequest = null; // clear out our saved WebRequest object    
        this._update(context, result, /* cacheResults */true);
    },
    _onGetPageComplete: function (result, context) {
        if (!this._element) return;
        this._viewPage = result;
        var listOfValues = this._enumerateViewPageItems();
        this._onGetListOfValuesComplete(listOfValues, context);
    },
    _enumerateViewPageItems: function (matchText) {
        var page = this._viewPage;
        //var info = this._get_contextInfo();
        //var dataView = Web.DataView.find(info.controller);
        var dataView = this._get_fieldDataView();
        var field = dataView.findField(this.get_fieldName());
        var textFields = [];
        for (var i = 0; i < page.Fields.length; i++) {
            var f = page.Fields[i];
            f.Index = i;
            if (f.Name == field.ItemsDataTextField)
                Array.add(textFields, f);
        }
        if (textFields.length == 0)
            for (i = 0; i < page.Fields.length; i++) {
                f = page.Fields[i];
                if (!f.Hidden && f.Type == 'String') {
                    Array.add(textFields, f);
                    break;
                }
            }
        if (textFields.length == 0)
            for (i = 0; i < page.Fields.length; i++) {
                f = page.Fields[i];
                if (!f.Hidden) {
                    Array.add(f);
                    break;
                }
            }
        var listOfValues = [];
        if (field.AllowNulls)
            Array.add(listOfValues, Web.DataViewResources.Data.NullValueInForms);
        for (i = 0; i < page.Rows.length; i++) {
            var v = page.Rows[i][textFields[0].Index];
            if (matchText != null) {
                if (v == matchText)
                    return i;
            }
            else
                Array.add(listOfValues, v);
        }
        return matchText != null ? -1 : listOfValues;
    },
    get_typeCssClass: function () {
        return this._typeCssClass;
    },
    set_typeCssClass: function (value) {
        this._typeCssClass = value;
    }
}

Web.DataView.hideMessage = function () { Web.DataView.showMessage() }

Web.DataView.formatMessage = function (type, message) { return String.format('<table cellpadding="0" cellspacing="0" ><tr><td class="{0}" valign="top">&nbsp;</td><td class="Message">{1}</td></tr></table>', type, message) }

Web.DataView.showMessage = function (message) {
    if (String.isBlank(message)) message = null;
    var bodyTag = document.getElementsByTagName('body')[0];
    var messageIsVisible = false;
    if (!Web.DataView.MessageBar) {
        var panel = document.createElement('div');
        panel.id = 'DataView_MessageBar';
        bodyTag.appendChild(panel);
        Sys.UI.DomElement.setVisible(panel, false);
        Sys.UI.DomElement.addCssClass(panel, 'MessageBar');
        Web.DataView.MessageBar = $create(AjaxControlToolkit.AlwaysVisibleControlBehavior, { VerticalOffset: AjaxControlToolkit.VerticalSide.Top }, null, null, panel);
        var b = Sys.UI.DomElement.getBounds(bodyTag);
        if (b.y < 0) b.y = 0;
        Web.DataView.OriginalBodyTopOffset = b.y;
    }
    panel = $get('DataView_MessageBar');
    var visible = Sys.UI.DomElement.getVisible(panel);
    panel.innerHTML = message ? String.format('<div>{0}</div><div class="Stub"></div>', message) : '';
    Sys.UI.DomElement.setVisible(panel, message != null);
    var bounds = Sys.UI.DomElement.getBounds(panel);
    var bodyTop = message ? Web.DataView.OriginalBodyTopOffset + bounds.height : Web.DataView.OriginalBodyTopOffset;
    bodyTag.style.paddingTop = bodyTop + 'px';
    var loginDialog = $get("Membership_Login");
    if (loginDialog) loginDialog.style.marginTop = (bodyTop) + 'px';

    //    var bounds = Sys.UI.DomElement.getBounds(panel);
    //    var bodyTop = message ? Web.DataView.OriginalBodyTopOffset + bounds.height : Web.DataView.OriginalBodyTopOffset;
    //    bodyTag.style.paddingTop = bodyTop + 'px';
    //    var loginDialog = $get("Membership_Login");
    //    if (loginDialog) loginDialog.style.marginTop = (bodyTop) + 'px';
    //    //    if (!visible && message) {
    //        panel.style.height = '';
    //        var messageContainer = panel.childNodes[0];
    //        var panelBounds = $common.getBounds(messageContainer);
    //        if (panelBounds.height > 50) {
    //            messageContainer.style.height = '50px';
    //            messageContainer.style.overflow = 'auto';
    //        }
    //    }
    if (Sys.UI.DomElement.getVisible(panel) != visible) _body_performResize();
}

Web.DataView._tagsWithIndexes = new Array('A', 'AREA', 'BUTTON', 'INPUT', 'OBJECT', 'SELECT', 'TEXTAREA', 'IFRAME');
Web.DataView._delayedLoadingViews = [];

Web.DataView._performDelayedLoading = function () {
    var i = 0;
    while (i < Web.DataView._delayedLoadingViews.length) {
        var v = Web.DataView._delayedLoadingViews[i];
        if (v.get_isDisplayed()) {
            Array.remove(Web.DataView._delayedLoadingViews, v);
            if (v._delayedLoading)
                v._loadPage();
        }
        else i++;
    }
}

Web.DataView.unanchor = function (href) {
    var m = href.match(/^(.+?)#.*$/);
    return m ? m[1] : href;
}

Web.DataView.find = function (id, propertyName) {
    var cid = '_' + id;
    var list = Sys.Application.getComponents();
    for (var i = 0; i < list.length; i++) {
        var c = list[i];
        if (propertyName) {
            if (Web.DataView.isInstanceOfType(c) && ((propertyName == 'Controller' && c._controller == id) || (propertyName == 'Tag' && c.get_isTagged(id))))
                return c;
        }
        else
            if (c._id == id || Web.DataView.isInstanceOfType(c) && c._id.endsWith(cid)) return c;
    }
    return null;
}

Web.DataView.showModal = function (parent/*anchor*/, controller, view, startCommandName, startCommandArgument, baseUrl, servicePath, filter, properties) {
    var parentIsDataView = Web.DataView.isInstanceOfType(parent);
    var anchor = parent,
        mobile = $appfactory.mobile;
    if (!$appfactory.mobile) {
        if (parentIsDataView && parent._container)
            anchor = parent._container.getElementsByTagName('a')[0];
        if (!anchor) {
            var links = document.getElementsByTagName('a', 'input', 'button');
            for (var i = links.length - 1; i >= 0; i--) {
                if (links[i].tabIndex >= 0) {
                    anchor = links[i];
                    break;
                }
            }
        }
        if (anchor == null) {
            alert('Cannot find an anchor for a modal popup.');
            return;
        }

        Web.HoverMonitor._instance.close();
    }
    if (mobile)
        mobile.modalDataView();
    if (!baseUrl) baseUrl = Web.DataView._baseUrl;
    if (!servicePath) servicePath = Web.DataView._servicePath;
    var placeholder = this._placeholder = document.createElement('div'),
        applicationComponentCount = Sys.Application.getComponents().length,
        id = controller.toLowerCase();
    if ($find(id))
        id += applicationComponentCount;
    placeholder.id = String.format('{0}_{1}_Placeholder{2}', controller, view, applicationComponentCount);
    if (parentIsDataView)
        parent._appendModalPanel(placeholder);
    else
        document.body.appendChild(placeholder);
    placeholder.className = 'ModalPlaceholder FixedDialog EmptyModalDialog';
    var params = {
        id: id/*controller + '_ModalDataView' + applicationComponentCount*/, baseUrl: baseUrl, servicePath: servicePath,
        controller: controller, viewId: view, showActionBar: false, modalAnchor: anchor, startCommandName: startCommandName, startCommandArgument: startCommandArgument,
        exitModalStateCommands: ['Cancel'], externalFilter: filter//,
    }
    if (properties) {
        if (!properties.useCase) {
            properties.useCase = $appfactory._defaultUseCase;
            $appfactory._defaultUseCase = null;
        }
        params.filter = properties.filter;
        params.ditto = properties.ditto;
        params.lastViewId = properties.lastViewId;
        params.transaction = properties.transaction;
        params.filterSource = properties.filterSource;
        params.filterFields = properties.filterFields;
        params.confirmContext = properties.confirmContext;
        params.showSearchBar = properties.showSearchBar;
        params.useCase = properties.useCase;
        params.tag = properties.tag;
    }
    var dataView = $create(Web.DataView, params, null, null, placeholder);
    if (parentIsDataView)
        dataView._parentDataViewId = parent.get_id();
    if (mobile)
        setTimeout(function () {
            mobile.modalDataView(params.id);
        }, 0);
    return dataView;
}

Web.DataView.alert = function (message, callback) {
    alert(message);
    if (callback)
        callback();
}

Web.DataView.isSaaS = function () {
    var that = this;
    if (that._isSaaS == null) {
        that._isSaaS = false;
        $('script').each(function () {
            if (this.src.match(/\/factory(.*?)\.js/))
                that._isSaaS = true;
        });
    }
    return that._isSaaS;
}

Web.DataView._resizeInterval = null;
Web.DataView._resizing = false;
Web.DataView._resized = false;
Web.DataView._customInputElements = [];
var $appfactory = Web.DataView;

Web.DataView.borderBox = function (elem) {
    var $elem = $(elem);
    //var borderTop = $elem.css('border-top-width');
    //var borderBottom = $elem.css('border-bottom-width');
    return { horizontal: $elem.outerWidth() - $elem.innerWidth(), vertical: $elem.outerHeight() - $elem.innerHeight() };
}
Web.DataView.paddingBox = function (elem) {
    var $elem = $(elem);
    return { horizontal: $elem.innerWidth() - $elem.width(), vertical: $elem.innerHeight() - $elem.height() };
}
Web.DataView.marginBox = function (elem) {
    var $elem = $(elem);
    return { horizontal: $elem.outerWidth(true) - $elem.outerWidth(), vertical: $elem.outerHeight(true) - $elem.outerHeight() };
}

Web.DataView.bounds = function (elem) {
    var $elem = $(elem);
    var offset = $elem.offset();
    return { x: offset.left, y: offset.top, width: $elem.outerWidth(), height: $elem.outerHeight() };
}

Web.DataView.scrolling = function () {
    var $window = $(window);
    return { x: $window.scrollLeft(), y: $window.scrollTop() };
}

Web.DataView.clientBounds = function () {
    var $window = $(window);
    return { width: $window.width(), height: $window.height() };
}


function _body_hideLayoutContainers() {
    if (!Web.DataView._layoutContainers) return;
    for (var i = 0; i < Web.DataView._layoutContainers.length; i++) {
        var lc = Web.DataView._layoutContainers[i];
        if (lc.width != '100%')
            Sys.UI.DomElement.setVisible($get(lc.id), false);
    }
}

function _body_resizeLayoutContainers() {
    var layoutContainers = Web.DataView._layoutContainers;
    if (!layoutContainers || layoutContainers.length == 0) return;
    var pc = $get('PageContent');
    if (!pc) return;
    //var bounds = $common.getBounds(pc);
    var bounds = $appfactory.bounds(pc);
    var padding = $appfactory.paddingBox(pc);
    //var padding2 = $common.getPaddingBox(pc);
    var border = $appfactory.borderBox(pc);
    //var border2 = $common.getBorderBox(pc);
    var margin = $appfactory.marginBox(pc); // $common.getMarginBox(pc);
    //var margin2 = $common.getMarginBox(pc);
    bounds.width -= padding.horizontal + border.horizontal + margin.horizontal;
    var rowIndex = layoutContainers[layoutContainers.length - 1].rowIndex;
    while (rowIndex >= layoutContainers[0].rowIndex) {
        var usedSpace = 0;
        for (var i = 0; i < layoutContainers.length; i++) {
            var lc = layoutContainers[i];
            if (lc.rowIndex == rowIndex && !String.isNullOrEmpty(lc.width)) {
                var div = $get(lc.id);
                if (div) {
                    var divPadding = $appfactory.paddingBox(div); // $common.getPaddingBox(div);
                    var divBorder = $appfactory.borderBox(div); // $common.getBorderBox(div);
                    var divMargin = $appfactory.marginBox(div); // $common.getMarginBox(div);
                    var m = lc.width.match(/(\d+)(%|px|)/);
                    var divWidth = m[2] != '%' ? parseFloat(m[1]) : Math.floor(bounds.width * parseFloat(m[1]) / 100);
                    usedSpace += divWidth;
                    divWidth -= divPadding.horizontal + divBorder.horizontal + divMargin.horizontal
                    if (lc.width != '100%') {
                        div.style.width = divWidth + 'px';
                        Sys.UI.DomElement.setVisible(div, true);
                    }
                    else {
                        $(div).removeClass('LayoutContainer').addClass('RowContainer');
                    }
                }
            }
        }
        if (usedSpace < bounds.width) {
            for (i = 0; i < layoutContainers.length; i++) {
                lc = layoutContainers[i];
                if (lc.rowIndex == rowIndex && String.isNullOrEmpty(lc.width)) {
                    div = $get(lc.id);
                    if (div) {
                        divPadding = $appfactory.paddingBox(div); // $common.getPaddingBox(div);
                        divBorder = $appfactory.borderBox(div); // $common.getBorderBox(div);
                        divMargin = $appfactory.marginBox(div); // $common.getMarginBox(div);
                        divWidth = Math.floor((bounds.width - usedSpace) / lc.peersWithoutWidth);
                        divWidth -= divPadding.horizontal + divBorder.horizontal + divMargin.horizontal
                        if (divWidth < 1) divWidth = 1;
                        div.style.width = divWidth + 'px';
                        Sys.UI.DomElement.setVisible(div, true);
                    }
                }
            }
        }
        rowIndex--;
    }
}

function _body_keydown(e) {
    if (e.keyCode == Sys.UI.Key.enter && Web.DataView._focusedItemIndex != null) {
        var dv = $find(Web.DataView._focusedDataViewId);
        if (dv && dv._get_focusedCell())
            return;
        var elem = $get(Web.DataView._focusedDataViewId + '_Item' + Web.DataView._focusedItemIndex);
        if (elem && elem.tagName == 'INPUT' && elem.type == 'text' && elem == e.target) {
            e.preventDefault();
            e.stopPropagation();
            dv = $find(Web.DataView._focusedDataViewId);
            if (dv) dv._valueChanged(Web.DataView._focusedItemIndex);
        }
    }
}

function _body_resize() {
    if (Web.DataView._resizeInterval)
        clearInterval(Web.DataView._resizeInterval);
    if (!Web.DataView._resizing && !Web.DataView._resized) {
        Web.DataView._resizeInterval = setInterval(function () {
            _body_performResize();
        }, 10);
        _body_hideLayoutContainers();
        _body_resizeLayoutContainers();
    }
    else
        $closeHovers();
    Web.DataView._resized = false;
}

function _body_scroll() {
    var sideBar = $getSideBar();
    if (!sideBar) return;
    var scrolling = $appfactory.scrolling(); // { x: $(window).scrollLeft(), y: $(window).scrollTop() };// $common.getScrolling();
    var clientBounds = $common.getClientBounds();
    var bounds = $common.getBounds(sideBar);
    if (sideBar._originalTop == null)
        sideBar._originalTop = bounds.y;
    var originalTop = sideBar._originalTop;
    var deltaY = 0;
    if (Web.DataView.MessageBar) {
        var mbb = $common.getBounds(Web.DataView.MessageBar._element);
        originalTop += deltaY = mbb.height;
    }
    if (scrolling.y > sideBar._originalTop && bounds.height + 4 <= clientBounds.height && scrolling.x == 0) {
        sideBar.style.width = bounds.width + 'px';
        if (Sys.Browser.agent == Sys.Browser.InternetExplorer && Sys.Browser.version <= 6) {
            sideBar.style.top = (4 + scrolling.y + deltaY) + 'px';
            sideBar.style.position = 'absolute';
        }
        else {
            sideBar.style.top = 4 + deltaY + 'px';
            sideBar.style.position = 'fixed';
        }
    }
    else {
        sideBar.style.top = '';
        sideBar.style.width = '';
        sideBar.style.position = '';
    }
}

function _body_createPageContext(persist) {
    var pc = $get('PageContent');
    if (!pc) return;
    var b = $common.getBounds(pc);
    var pb = $common.getPaddingBox(pc);
    var bb = $common.getBorderBox(pc);
    var ctx = { 'height': b.height - pb.vertical - bb.vertical, 'scrolling': $appfactory.scrolling()/* $common.getScrolling()*/ };
    if (persist != false) Web.DataView._pageContext = ctx;
    return ctx;
}

function _body_performResize() {
    if (Web.DataView._resizeInterval) clearInterval(Web.DataView._resizeInterval);
    Web.DataView._resizeInterval = null;
    $closeHovers();
    var pc = $get('PageContent');
    if (!pc || $appfactory.mobile) return;

    var cb = $common.getClientBounds();
    var clientBounds = $common.getClientBounds();
    if (Web.DataView.MessageBar) {
        var messageBarElement = Web.DataView.MessageBar._element;
        if ($common.getVisible(messageBarElement)) {

            var mbeb = $common.getPaddingBox(messageBarElement);
            messageBarElement.style.width = (clientBounds.width - mbeb.horizontal) + 'px';
            var messageContainer = messageBarElement.childNodes[0];
            messageContainer.style.height = '';
            var panelBounds = $common.getBounds(messageContainer);
            var maxMessageHeight = Math.ceil(cb.height * 0.15)
            if (panelBounds.height > maxMessageHeight) {
                messageContainer.style.height = maxMessageHeight + 'px';
                messageContainer.style.overflow = 'auto';
            }
            mbeb = Sys.UI.DomElement.getBounds(messageBarElement);
            var bodyTop = Web.DataView.OriginalBodyTopOffset + mbeb.height;
            document.body.style.paddingTop = bodyTop + 'px';
            var loginDialog = $get("Membership_Login");
            if (loginDialog) loginDialog.style.marginTop = (bodyTop) + 'px';
        }
    }
    Web.DataView._resizing = true;
    var pageContext = Web.DataView._pageContext;
    if (pageContext == null)
        pageContext = _body_createPageContext(false);
    else
        Web.DataView._pageContext = null;
    var scrolling = $appfactory.scrolling(); // $common.getScrolling();
    if (scrolling.y == 0) pc.style.height = '10px';
    _body_resizeLayoutContainers();
    //_body_scroll();
    if (typeof (__cothost) == 'undefined') {
        var bounds = $appfactory.bounds(pc); // $common.getBounds(pc);
        var padding = $appfactory.paddingBox(pc); // $common.getPaddingBox(pc);
        var border = $appfactory.borderBox(pc); // $common.getBorderBox(pc);
        var pmb = Web.Menu.MainMenuElemId ? $get(Web.Menu.MainMenuElemId) : null;
        var pmbBorderBox = pmb ? $common.getBorderBox(pmb) : null;
        var pfc = $get('PageFooterContent');
        var pfb = $get('PageFooterBar');
        var newHeight = scrolling.y + cb.height - bounds.y - (pfb ? pfb.offsetHeight : 0) - (pfc ? pfc.offsetHeight : 0) - border.vertical - padding.vertical - (pmbBorderBox ? pmbBorderBox.vertical : 0);
        if (bounds.height < newHeight) {
            if (Sys.Browser.agent == Sys.Browser.Opera)
                newHeight += border.vertical + padding.vertical;
        }
        if (pageContext.scrolling.y == 0 || Web.DataView._numberOfContainers < 2)
            pc.style.height = document.body.offsetHeight > cb.height ? '' : newHeight + 'px';
        else {
            pc.style.height = pageContext.height + 'px';
            scrollTo(0, pageContext.scrolling.y);
        }
    }
    _body_scroll();
    Web.DataView._resizing = false;
    Web.DataView._resized = true;
}

Web.DataView._activate = function (source, elementId, type) {
    var activatorRegex = new RegExp('^\\s*' + type + '\\s*\\|');
    var elem = $get(elementId);
    if (type == 'SideBarTask') {
        var lc = elem;
        while (lc && String.isNullOrEmpty(this.prototype.dataAttr(lc, 'flow')))
            lc = lc.parentNode;
        var peers = lc.getElementsByTagName('div');
        for (var i = 0; i < peers.length; i++) {
            var activator = this.prototype.dataAttr(peers[i], 'activator');
            if (!String.isNullOrEmpty(activator) && activatorRegex.exec(activator))
                $(peers[i]).hide();
        }
    }
    Sys.UI.DomElement.setVisible(elem, type == 'SideBarTask' ? true : !Sys.UI.DomElement.getVisible(elem));
    elem._activated = true;
    if (type == 'SiteAction' && elem.childNodes[0].className != 'CloseSiteAction') {
        var closeLink = document.createElement('div');
        closeLink.className = 'CloseSiteAction';
        closeLink.innerHTML = String.format('<a href="javascript:" onclick="Web.DataView._activate(null,\'{0}\',\'SiteAction\')">{1}</a>', elementId, Web.DataViewResources.ModalPopup.Close);
        elem.insertBefore(closeLink, elem.childNodes[0]);
    }
    if (Sys.UI.DomElement.getVisible(elem)) {
        var bounds = $common.getBounds(elem);
        var clientBounds = $common.getClientBounds();
        var scrolling = $appfactory.scrolling(); // $common.getScrolling();
        if (bounds.y < scrolling.y || bounds.y > scrolling.y + clientBounds.height)
            elem.scrollIntoView(false);
    }
    if (source) {
        while (source && !Sys.UI.DomElement.containsCssClass(source, 'Task'))
            source = source.parentNode;
        for (i = 0; i < source.parentNode.childNodes.length; i++) {
            var peer = source.parentNode.childNodes[i];
            if (peer.className)
                Sys.UI.DomElement.removeCssClass(peer, 'Selected');
        }
        Sys.UI.DomElement.addCssClass(source, 'Selected');
    }
    _body_performResize();
}

Web.DataView._partialUpdateBeginRequest = function (sender, args) {
    var r = args.get_request();
    var components = Sys.Application.getComponents();
    var controllers = [];
    for (var i = 0; i < components.length; i++) {
        var c = components[i];
        if (c._controller && c._viewId && Web.DataView.isInstanceOfType(c)) {
            var tag = c.get_tag();
            if (!String.isNullOrEmpty(tag)) {
                Array.add(controllers, tag);
                Array.add(controllers, c.get_selectedKey());
            }
        }
    }
    var s = Sys.Serialization.JavaScriptSerializer.serialize(controllers);
    r.set_body(r.get_body() + '&' + encodeURIComponent('__WEB_DATAVIEWSTATE') + '=' + encodeURIComponent(s));
}

Web.DataView._load = function () {
    if (Web.DataView._loaded) return;
    if (Sys.WebForms && Sys.WebForms.PageRequestManager._instance) Sys.WebForms.PageRequestManager._instance.add_beginRequest(Web.DataView._partialUpdateBeginRequest);
    Web.DataView._loaded = true;
    updateACT();
    Web.DataView.supportsPlaceholder = 'placeholder' in document.createElement('input');
    var pc = $get('PageContent');
    if (pc) {
        $('body').find('div[data-app-role="page"]').remove();
        var divs = document.body.getElementsByTagName('div');
        for (var i = 0; i < divs.length; i++) {
            if (divs[i].className.match(/Loading/)) {
                Sys.UI.DomElement.removeCssClass(divs[i], 'Loading');
                break;
            }
        }
        divs = pc.getElementsByTagName('div');
        var layoutContainers = [];
        var rowIndex = 0;
        var hasActivators = false;
        var hasSideBarActivators = false;
        var sb = null;
        var siteActions = [];
        Web.DataView._numberOfContainers = 0;
        var dataAttr = Web.DataView.prototype.dataAttr;
        for (i = 0; i < divs.length; i++) {
            var div = divs[i];
            var width = dataAttr(div, 'width');
            var flow = dataAttr(div, 'flow');
            if (!String.isNullOrEmpty(width) || !String.isNullOrEmpty(flow)) {
                if (flow != 'NewColumn') {
                    div.style.clear = 'left';
                    rowIndex++;
                }
                if (String.isNullOrEmpty(div.id))
                    div.id = "_lc" + layoutContainers.length;
                Sys.UI.DomElement.addCssClass(div, 'LayoutContainer');
                Web.DataView._numberOfContainers++;
                if (width != '100%')
                    div.style.overflow = 'hidden';
                Array.add(layoutContainers, { 'id': div.id, 'width': width, 'rowIndex': rowIndex, 'peersWithoutWidth': 0 });
                var childDivs = div.getElementsByTagName('div');
                var divsWithActivator = [];
                for (var j = 0; j < childDivs.length; j++) {
                    var childDiv = childDivs[j];
                    var activator = dataAttr(childDiv, 'activator');
                    if (!String.isNullOrEmpty(activator)) {
                        childDiv.id = String.isNullOrEmpty(childDiv.id) ? div.id + '$a' + j : childDiv.id
                        var da = { 'elem': childDiv, 'activator': activator.split('|'), 'id': childDiv.id };
                        da.activator[0] = da.activator[0].trim();
                        if (da.activator.length == 1) da.activator[1] = j.toString();
                        Array.add(divsWithActivator, da);
                    }
                }
                j = 1;
                while (j < divsWithActivator.length) {
                    da = divsWithActivator[j];
                    for (var k = 0; k < j; k++) {
                        var da2 = divsWithActivator[k];
                        if (da2.activator[0] == da.activator[0] & da2.activator[1] == da.activator[1]) {
                            while (da.elem.childNodes.length > 0)
                                da2.elem.appendChild(da.elem.childNodes[0]);
                            delete da.elem;
                            Array.removeAt(divsWithActivator, j);
                            da = null;
                            break;
                        }
                    }
                    if (da) j++;
                }
                if (divsWithActivator.length > 0) {
                    hasActivators = true;
                    var nodes = [];
                    var firstSideBarActivator = true;
                    for (j = 0; j < divsWithActivator.length; j++) {
                        da = divsWithActivator[j];
                        if (da.activator[0] == 'Tab') {
                            if (nodes.length == 0) {
                                var menuBar = document.createElement('div');
                                menuBar.className = 'TabBar';
                                div.insertBefore(menuBar, da.elem);
                            }
                            var n = { 'title': da.activator[1], 'elementId': da.id, 'selected': nodes.length == 0, 'description': dataAttr(da.elem, 'description'), 'hidden': dataAttr(da.elem, 'hidden') };
                            Array.add(nodes, n);
                            Sys.UI.DomElement.setVisible(da.elem, n.selected);
                            da.elem._activated = true;
                            Sys.UI.DomElement.addCssClass(da.elem, 'TabBody TabContainer');
                        }
                        else if (da.activator[0] == 'SideBarTask') {
                            if (!sb) {
                                sb = new Sys.StringBuilder();
                                sb.appendFormat('<div class="TaskBox TaskList"><div class="Inner"><div class="Header">{0}</div>', Web.DataViewResources.Menu.Tasks);
                            }
                            da.elem._activated = firstSideBarActivator;
                            if (firstSideBarActivator) firstSideBarActivator = false;
                            Sys.UI.DomElement.setVisible(da.elem, da.elem._activated);
                            sb.appendFormat('<div class="Task{1}"{4}><a href="javascript:" onclick="Web.DataView._activate(this,\'{2}\',\'SideBarTask\');return false;" title=\'{3}\'>{0}</a></div>', da.activator[1], !hasSideBarActivators ? ' Selected' : '', da.id,
                                Web.DataView.htmlAttributeEncode(dataAttr(da.elem, 'description')), dataAttr(da.elem, 'hidden') == 'true' ? ' style="display:none"' : '');
                            hasSideBarActivators = true;
                        }
                        else if (da.activator[0] == 'SiteAction' && Web.Menu.get_siteActionsFamily()) {
                            var item = new Web.Item(Web.Menu.get_siteActionsFamily(), da.activator[1], dataAttr(da.elem, 'description'));
                            item.set_cssClass(dataAttr(da.elem, 'cssClass'));
                            item.set_script('Web.DataView._activate(null,"{0}","SiteAction")', da.id);
                            Array.add(siteActions, item);
                            Sys.UI.DomElement.setVisible(da.elem, false);
                        }
                        else {
                            Sys.UI.DomElement.setVisible(da.elem, false);
                        }
                        da.elem = null;
                    }
                    if (nodes.length > 0) {
                        $create(Web.Menu, { 'id': div.id + '$ActivatorMenu', 'nodes': nodes }, null, null, menuBar);
                        if (nodes.length < 2 && i == 0)
                            Sys.UI.DomElement.addCssClass(menuBar, 'EmptyTabBar');
                    }
                }
            }
        }
        if (hasActivators)
            Web.DataView._performDelayedLoading();
        if (hasSideBarActivators && sb) {
            var sideBar = $getSideBar();
            if (sideBar) {
                sb.append('</div></div>');
                var tasksBox = document.createElement('div');
                tasksBox.innerHTML = sb.toString();
                sb.clear();
                sideBar.insertBefore(tasksBox, sideBar.childNodes[0]);
                sideBar._hasActivators = true;
            }
        }
        if (siteActions.length > 0)
            Web.Menu.set_siteActions(siteActions);
        var ri = rowIndex;
        while (layoutContainers.length > 0 && ri >= layoutContainers[0].rowIndex) {
            var containersWithoutWidth = 0;
            var peerCount = 0;
            for (i = 0; i < layoutContainers.length; i++) {
                lc = layoutContainers[i];
                if (lc.rowIndex == ri) {
                    peerCount++;
                    if (String.isNullOrEmpty(lc.width))
                        containersWithoutWidth++;
                }
            }
            for (i = 0; i < layoutContainers.length; i++) {
                lc = layoutContainers[i];
                if (lc.rowIndex == ri) {
                    lc.peersWithoutWidth = containersWithoutWidth;
                    if (peerCount == 1 && String.isNullOrEmpty(lc.width))
                        lc.width = '100%';
                }
            }
            ri--;
        }
        Web.DataView._layoutContainers = layoutContainers;
        _body_performResize();
        $addHandler(window, 'resize', _body_resize);
        $addHandler(window, 'scroll', _body_scroll);
    }
    Web.DataView._startDelayedLoading();
    $addHandler(document.body, 'keydown', _body_keydown);
}

Web.DataView._unload = function () {
    if (this._state) {
        Array.clear(this._state);
        delete this._state;
    }
    if (Web.DataView._delayedLoadingTimer) {
        clearInterval(Web.DataView._delayedLoadingTimer);
        Array.clear(Web.DataView._delayedLoadingViews);
        delete Web.DataView._delayedLoadingViews;
    }
    if ($get('PageContent')) {
        $removeHandler(window, 'resize', _body_resize);
        $removeHandler(window, 'scroll', _body_scroll);
    }
    $removeHandler(document.body, 'keydown', _body_keydown);
}

Web.DataView._startDelayedLoading = function () {
    if (Web.DataView._delayedLoadingViews.length > 0 && !Web.DataView._delayedLoadingTimer)
        Web.DataView._delayedLoadingTimer = setInterval(function () {
            Web.DataView._performDelayedLoading();
        }, 1000);
}

Web.DataView._updateBatchSelectStatus = function (cb, isForm) {
    var targetClass = isForm ? 'Item' : 'Cell';
    var elem = cb.parentNode;
    while (elem != null && !Sys.UI.DomElement.containsCssClass(elem, targetClass)) elem = elem.parentNode;
    if (elem) {
        if (cb.checked)
            Sys.UI.DomElement.addCssClass(elem, 'BatchEditFrame');
        else
            Sys.UI.DomElement.removeCssClass(elem, 'BatchEditFrame');
    }
}

Web.DataView.highlightFilterValues = function (elem, active, className) {
    while (elem && elem.tagName != 'TABLE')
        elem = elem.parentNode;
    if (elem)
        if (active && !elem.className.match(className))
            Sys.UI.DomElement.addCssClass(elem, className);
        else if (!active && elem.className.match(className))
            Sys.UI.DomElement.removeCssClass(elem, className);
}

Web.DataView.get_commandLine = function () {
    var commandLine = Web.DataView._commandLine;
    if (!commandLine) {
        if (typeof __dacl != 'undefined')
            commandLine = __dacl;
        if (!commandLine) {
            commandLine = typeof Web.Membership != 'undefined' ? Web.Membership._instance.get_commandLine() : null;
            commandLine = !commandLine ? location.href : location.pathname + '?' + commandLine;
        }
        Web.DataView._commandLine = $appfactory.unanchor(commandLine);
    }
    return commandLine;
}

Web.DataView._run = function (baseUrl, servicePath, authenticated) {
    var pageContent = $('#PageContent, div[data-role="page"]');
    if (!authenticated) {
        var placeholderSupported = 'placeholder' in document.createElement('input');
        var login = $('<div id="appfactory-login"><div class="user-name"><label for="username">User Name:</label><input type="text" id="username" placeholder="User Name"/></div><div class="password"><label for="password">Password:</label><input type="password" id="password" placeholder="Password"/></div><div class="login"><button>Login</button><div></div>').insertBefore(pageContent);
        login.find('button').click(function (e) {
            e.preventDefault();
            var username = login.find('#username');
            var password = login.find('#password');
            $.ajax({
                url: baseUrl + '/appservices/_authenticate',
                type: 'GET',
                cache: false,
                data: { args: Sys.Serialization.JavaScriptSerializer.serialize([username.val(), password.val()]) },
                dataType: 'jsonp',
                success: function (result) {
                    if (result)
                        location.replace(location.href);
                    else
                        username.focus();
                },
                error: function (e) {
                    alert('error');
                }
            });
        });
        if (placeholderSupported)
            login.find('label').remove();
        pageContent.hide();
        return;
    }
    $('div[data-controller]').each(function () {
        var extender = $(this);
        var controller = extender.attr('data-controller');
        if (controller) {
            var id = extender.attr('id');
            if (!id)
                id = controller;
            var args = { id: id, controller: controller, baseUrl: baseUrl/*'http://localhost:23920/Jsonp/'*/, servicePath: servicePath/* "../Services/DataControllerService.asmx"*/, showSearchBar: true };
            var properties = [
                { name: 'view' },
                { name: 'pageSize', type: 'int' },
                { name: 'servicePath' },
                { name: 'filterSource' },
                { name: 'filterFields' },
                { name: 'autoHide', aliases: ['nothing', 'self', 'container'], values: [0, 1, 2] },
                { name: 'showSearchBar', type: 'bool' },
                { name: 'showModalForms', type: 'bool' }
            ];
            $(properties).each(function () {
                var v = extender.attr('data-' + this.name.replace(/([A-Z])/g, '-$1'));
                if (v) {
                    if (this.aliases)
                        v = this.values[Array.indexOf(this.aliases, v.toString().toLowerCase())];
                    if (this.type == 'bool')
                        v = v == 'true';
                    if (this.type == 'int')
                        v = parseInt(v);
                    args[this.name] = v;
                }
            });
            $create(Web.DataView, args, null, null, this);
        }
    });
}


Web.DataView.DetailsRegex = /\/Details\.aspx\?/i;
Web.DataView.LocationRegex = /^(_.+?):(.+)$/;
Web.DataView.LEVs = [];
Web.DataView.Editors = [];
Web.DataView.EditorFactories = {};


(function () {
    var c = Sys.CultureInfo.CurrentCulture.dateTimeFormat;
    Web.DataView.dateFormatStrings = {
        '{0:g}': c.ShortDatePattern + ' ' + c.ShortTimePattern,
        '{0:G}': c.ShortDatePattern + ' ' + c.LongTimePattern,
        '{0:f}': c.LongDatePattern + ' ' + c.ShortTimePattern,
        '{0:u}': c.SortableDateTimePattern,
        '{0:U}': c.UniversalSortableDateTimePattern
    }
})();

if (!$.mobile) {
    Sys.Application.add_load(Web.DataView._load);
    Sys.Application.add_unload(Web.DataView._unload);
}

function $createDataView(placeholderId, controller, args) {
    var params = { 'id': controller + 'Extender', 'controller': controller, 'baseUrl': './', 'servicePath': 'Services/DataControllerService.asmx' }
    if (args) {
        for (var i = 0; i < args.length; i++)
            params[args[i].name] = args[i].value;
    }
    $create(Web.DataView, params, null, null, $get(placeholderId));
}

function updateACT() {
    if (Sys.Extended && typeof (AjaxControlToolkit) == "undefined") AjaxControlToolkit = Sys.Extended.UI;
    Web.AutoComplete.registerClass('Web.AutoComplete', AjaxControlToolkit.AutoCompleteBehavior);
    Sys.Browser.WebKit = {};
    if (navigator.userAgent.indexOf('WebKit/') > -1) {
        Sys.Browser.agent = Sys.Browser.WebKit;
        Sys.Browser.version = parseFloat(navigator.userAgent.match(/WebKit\/(\d+(\.\d+)?)/)[1]);
        Sys.Browser.name = 'WebKit';
    }
    //$common.getScrolling = function () {
    //    var x = 0;
    //    var y = 0;
    //    if (window.pageYOffset) {
    //        y = window.pageYOffset;
    //        x = window.pageXOffset;
    //    } else if (document.body && (document.body.scrollLeft || document.body.scrollTop)) {
    //        y = document.body.scrollTop;
    //        x = document.body.scrollLeft;
    //    } else if (document.documentElement && (document.documentElement.scrollLeft || document.documentElement.scrollTop)) {
    //        y = document.documentElement.scrollTop;
    //        x = document.documentElement.scrollLeft;
    //    }
    //    return new Sys.UI.Point(x, y);
    //}
    if (!(Sys.Browser.agent == Sys.Browser.InternetExplorer || Sys.Browser.agent == Sys.Browser.Firefox || Sys.Browser.agent == Sys.Browser.Opera) && !Sys.Extended) {
        $common.old_getBounds = $common.getBounds;
        $common.getBounds = function (element) {
            var bounds = $common.old_getBounds(element);
            var scrolling = $appfactory.scrolling(); // $common.getScrolling();
            if (scrolling.y || scrolling.x) {
                bounds.x += scrolling.x;
                bounds.y += scrolling.y;
            }
            return bounds;
        }
    }
    if (AjaxControlToolkit.CalendarBehavior && !AjaxControlToolkit.CalendarBehavior.prototype.old_show) {
        AjaxControlToolkit.CalendarBehavior.prototype.old_show = AjaxControlToolkit.CalendarBehavior.prototype.show;
        AjaxControlToolkit.CalendarBehavior.prototype.show = function () {
            this.old_show();
            //this._container.style.zIndex = 100100;
            var container = $(this._container).zIndex(100100),
                elem = $(this._element),
                showAbove = elem.parent().find('.Error:visible').length || elem.closest('div.Item').find('.Error:visible').length;
            function positionCalendar() {
                container.position({ my: 'left ' + (showAbove ? 'bottom' : 'top'), at: 'left ' + (showAbove ? 'top' : 'bottom'), of: elem });
            }
            positionCalendar();
            setTimeout(positionCalendar, 10);
        }
        AjaxControlToolkit.CalendarBehavior.prototype.old_raiseDateSelectionChanged = AjaxControlToolkit.CalendarBehavior.prototype.raiseDateSelectionChanged;
        AjaxControlToolkit.CalendarBehavior.prototype.raiseDateSelectionChanged = function () {
            this.old_raiseDateSelectionChanged();
            this._element.focus();
        }
    }
    if (AjaxControlToolkit.TabContainer && !AjaxControlToolkit.TabContainer.prototype.old_set_activeTabIndex) {
        AjaxControlToolkit.TabContainer.prototype.old_set_activeTabIndex = AjaxControlToolkit.TabContainer.prototype.set_activeTabIndex;
        AjaxControlToolkit.TabContainer.prototype.set_activeTabIndex = function (value) {
            var oldActiveTabIndex = this.get_activeTabIndex();
            if (!this._headerAssigned) {
                this._headerAssigned = true;
                Sys.UI.DomElement.addCssClass(this._element.getElementsByTagName('div')[0], 'tab-header');
            }
            this.old_set_activeTabIndex(value);
            if (value != oldActiveTabIndex)
                _body_performResize();
        }
    }
    if (AjaxControlToolkit.AutoCompleteBehavior && !AjaxControlToolkit.AutoCompleteBehavior.prototype.old_dispose) {
        AjaxControlToolkit.AutoCompleteBehavior.prototype.old_dispose = AjaxControlToolkit.AutoCompleteBehavior.prototype.dispose;
        AjaxControlToolkit.AutoCompleteBehavior.prototype.dispose = function () {
            this.old_dispose();
            if (this._completionListElement) {
                this._completionListElement.parentNode.removeChild(this._completionListElement);
                delete this._completionListElement;
            }
        }
        AjaxControlToolkit.AutoCompleteBehavior.prototype.old__handleFlyoutFocus = AjaxControlToolkit.AutoCompleteBehavior.prototype._handleFlyoutFocus;
        AjaxControlToolkit.AutoCompleteBehavior.prototype._handleFlyoutFocus = function () {
            if (!this._completionListElement) return;
            this.old__handleFlyoutFocus();
        }
        AjaxControlToolkit.AutoCompleteBehavior.prototype.old_showPopup = AjaxControlToolkit.AutoCompleteBehavior.prototype.showPopup;
        AjaxControlToolkit.AutoCompleteBehavior.prototype.showPopup = function () {
            this.old_showPopup();
            if (Sys.UI.DomElement.getVisible(this._completionListElement)) {
                var scrolling = $appfactory.scrolling(); // $common.getScrolling();
                this._completionListElement.style.height = '';
                Sys.UI.DomElement.addCssClass(this._completionListElement, 'CompletionList');
                this._completionListElement.style.width = '';
                this._completionListElement.style.zIndex = 200100;
                var cb = $common.getClientBounds();
                var bounds = $common.getBounds(this._completionListElement);
                if (bounds.width > cb.width / 3) bounds.width = cb.width / 3;
                var elem = this._element;
                if (Sys.UI.DomElement.containsCssClass(elem.parentNode, 'Input'))
                    while (!Sys.UI.DomElement.containsCssClass(elem.parentNode, 'AutoCompleteFrame'))
                        elem = elem.parentNode;
                var elemBounds = $common.getBounds(elem);
                var borderBox = $common.getBorderBox(this._completionListElement);
                var paddingBox = $common.getPaddingBox(this._completionListElement);
                if (bounds.width <= elemBounds.width)
                    this._completionListElement.style.width = (elemBounds.width - borderBox.horizontal - paddingBox.horizontal) + 'px';
                bounds = $common.getBounds(this._completionListElement);
                if (bounds.x != elemBounds.x) {
                    bounds.x = elemBounds.x;
                    this._completionListElement.style.left = bounds.x + 'px';
                }
                if (bounds.y != elemBounds.y) {
                    bounds.y = elemBounds.y + elemBounds.height - 1;
                    this._completionListElement.style.top = bounds.y + 'px';
                }
                if (bounds.x + bounds.width > cb.width)
                    this._completionListElement.style.left = (cb.width - bounds.width) + 'px';
                bound = $common.getBounds(this._completionListElement);
                var spaceAbove = elemBounds.y - scrolling.y;
                var spaceBelow = cb.height - (elemBounds.y + elemBounds.height - scrolling.y);
                if (bound.height <= spaceBelow || spaceBelow >= spaceAbove) {
                    if (bounds.y + bounds.height - scrolling.y > cb.height) {
                        this._completionListElement.style.height = (cb.height - (bounds.y - scrolling.y) - 4) + 'px';
                        this._completionListElement.style.overflow = 'auto';
                    }
                }
                else {
                    if (spaceAbove < bounds.height) {
                        this._completionListElement.style.top = (elemBounds.y - spaceAbove) + 'px';
                        this._completionListElement.style.height = spaceAbove + 'px';
                        this._completionListElement.style.overflow = 'auto';
                    }
                    else
                        this._completionListElement.style.top = (elemBounds.y - bounds.height + 3) + 'px';
                }
            }
        }
        if (AjaxControlToolkit.ModalPopupBehavior && !AjaxControlToolkit.ModalPopupBehavior.prototype.old__attachPopup) {
            AjaxControlToolkit.ModalPopupBehavior.prototype.old__attachPopup = AjaxControlToolkit.ModalPopupBehavior.prototype._attachPopup;
            AjaxControlToolkit.ModalPopupBehavior.prototype._attachPopup = function () {
                this.old__attachPopup();
                if (this._dropShadowBehavior /*&& __targetFramework != '3.5'*/) {
                    this._dropShadowBehavior.set_Width(4);
                    if (Sys.Browser.agent != Sys.Browser.InternetExplorer || Sys.Browser.version >= 9)
                        this._dropShadowBehavior.set_Rounded(true);
                }
            }
        }
    }
}

function $hoverTab(elem, active) {
    while (elem && elem.tagName != 'TD')
        elem = elem.parentNode;
    if (elem) {
        if (active) {
            Sys.UI.DomElement.addCssClass(elem, 'Active');
            elem.focus();
        }
        else
            Sys.UI.DomElement.removeCssClass(elem, 'Active');
    }
}

function $getSideBar() {
    var sideBar = $get('PageContentSideBar');
    if (!sideBar) return null;
    for (var i = 0; i < sideBar.childNodes.length; i++) {
        var n = sideBar.childNodes[i];
        if (n.className == 'SideBarBody') return n;
    }
    return null;
}

function $dvget(controller, view, fieldName, containerOnly) {
    var list = Sys.Application.getComponents();
    var cid = '_' + controller;
    var dataView = null;
    for (var i = 0; i < list.length; i++) {
        var c = list[i];
        if (c._id == controller || Web.DataView.isInstanceOfType(c) && (c._id.endsWith(cid) || c._controller == controller && (!view || c.get_viewId() == view))) {
            dataView = c;
            break;
        }
    }
    if (dataView) {
        if (fieldName) {
            var field = dataView.findField(fieldName);
            if (field) {
                if (containerOnly) {
                    element = $get(dataView._id + '_ItemContainer' + field.Index);
                    if (element)
                        for (i = 0; i < element.childNodes.length; i++) {
                            var velem = element.childNodes[i];
                            if (velem.className == 'Value')
                                return velem;
                        }
                } else
                    return $get(dataView._id + '_Item' + field.Index)
                return element;
            }
            else
                return null;
        }
        else
            return dataView;
    }
    return null;
}

Sys.UI.DomElement.setFocus = function (element) {
    var sel = document.selection;
    if (sel && sel.type != 'Text' && sel.type != 'None')
        sel.clear();
    if (element) {
        element.focus();
        if (element.select)
            element.select();
        if (document.focus)
            document.focus();
    }
}

Sys.UI.DomElement.getCaretPosition = function (element) {
    var caretPos = 0;     // IE Support     
    if (document.selection) {
        element.focus();
        var sel = document.selection.createRange();
        sel.moveStart('character', -element.value.length);
        caretPos = sel.text.length;
    }     // Firefox support     
    else if (element.selectionStart || element.selectionStart == '0')
        caretPos = element.selectionStart;
    return (caretPos);
}

Sys.UI.DomElement.setCaretPosition = function (element, pos) {
    if (element.setSelectionRange) {
        element.focus();
        element.setSelectionRange(pos, pos);
    }
    else if (element.createTextRange) {
        var range = element.createTextRange();
        range.collapse(true);
        range.moveEnd('character', pos);
        range.moveStart('character', pos);
        range.select();
    }
}

function _field_format(v) {
    try { return v == null ? 'null' : this.FormatOnClient && !String.isNullOrEmpty(this.DataFormatString) ? String.localeFormat(this.DataFormatString, v) : v.toString(); }
    catch (e) { throw new Error(String.format('\nField: {0}\nData Format String: {1}\n{2}', this.Name, this.DataFormatString, e.message)) }
}

function _field_isReadOnly() {
    return this.TextMode == 4 || this.ReadOnly;
}

function _field_isNumber() {
    return Array.indexOf(['SByte', 'Byte', 'Int16', 'Int32', 'UInt32', 'Int64', 'Single', 'Double', 'Decimal', 'Currency'], this.Type)
}

function _field_text(v) {
    var s, dvrd = Web.DataViewResources.Data,
        fieldItems = this.DynamicItems ? this.DynamicItems : this.Items;
    if (fieldItems.length == 0) {
        if (this.Type == 'String' && v != null && v.length > dvrd.MaxReadOnlyStringLen && !(this.TextMode == 3 || this.TextMode == 2))
            v = v.substring(0, dvrd.MaxReadOnlyStringLen) + '...';
        if (v && this.TextMode == 3)
            v = v.replace(/(\r\n*)/g, '<br/>');
        s = String.isBlank(v) ? dvrd.NullValueInForms : this.format(v);
    }
    else if (this.ItemsStyle == 'CheckBoxList') {
        var lov = v ? v.split(',') : [],
            sb = new Sys.StringBuilder(),
            firstItem = true;
        for (var i = 0; i < fieldItems.length; i++) {
            var item = fieldItems[i],
                itemValue = item[0] == null ? '' : item[0].toString();
            if (Array.contains(lov, itemValue)) {
                if (firstItem)
                    firstItem = false;
                else
                    sb.append(', ');
                sb.append(item[1]);
            }
        }
        s = sb.toString();
        s = lov.length == 0 ? dvrd.NullValueInForms : s;
    }
    else {
        item = this._dataView._findItemByValue(this, v);
        s = item[1];
    }
    if (this.TextMode == 1) s = '**********';
    return s;
}

Array.indexOfCaseInsensitive = function (list, value) {
    value = value.toLowerCase();
    for (var i = 0; i < list.length; i++)
        if (list[i].toLowerCase() == value)
            return i;
    return -1;
}

Number.tryParse = function (s, fmt) {
    if (typeof (s) != 'string') return null;
    if (String.isNullOrEmpty(s)) return null;
    var n = Number.parseLocale(s);
    if (isNaN(n)) {
        var nf = Sys.CultureInfo.CurrentCulture.numberFormat;
        if (!nf._simplifyRegex)
            nf._simplifyRegex = new RegExp(String.format('({0}|\\{1})', nf.CurrencySymbol.replace(/(\W)/g, "\\$1"), nf.CurrencyGroupSeparator), 'gi');
        var isNegative = s.match(/\(/) != null;
        s = s.replace(nf._simplifyRegex, '').replace(/\(|\)/g, '');
        s = s.replace(nf.CurrencyDecimalSeparator, nf.NumberDecimalSeparator);
        n = Number.parseLocale(s)
        if (isNaN(n)) {
            n = Number.parseLocale(s.replace(nf.PercentSymbol, ''));
            if (!isNaN(n))
                n /= 100;
        }
    }
    if (!isNaN(n)) {
        if (isNegative)
            n *= -1;
        return n;
    }
    return null;
}

Date.tryParseFuzzyDate = function (s, dataFormatString) {
    if (String.isNullOrEmpty(s)) return null;
    var dtf = Sys.CultureInfo.CurrentCulture.dateTimeFormat;
    var d = Date.parseLocale(s, dtf.ShortDatePattern);
    if (d == null)
        d = Date.parseLocale(s, dtf.LongDatePattern);
    if (d == null && !String.isNullOrEmpty(dataFormatString)) {
        var dfsm = dataFormatString.match(/\{0:([\s\S]*?)\}/);
        if (dfsm)
            d = Date.parseLocale(s, dfsm[1]);
    }
    if (d)
        return d;
    d = new Date();
    var m = s.match(/^\s*(\w+)\s*$/);
    if (m) {
        var index = Array.indexOfCaseInsensitive(dtf.DayNames, m[1]);
        if (index == -1)
            index = Array.indexOfCaseInsensitive(dtf.AbbreviatedDayNames, m[1]);
        if (index == -1)
            index = Array.indexOfCaseInsensitive(dtf.ShortestDayNames, m[1]);
        if (index >= 0) {
            while (d.getDay() != index)
                d.setDate(d.getDate() + 1);
            return d;
        }
    }
    m = s.match(/^\s*(\w+|\d+)[^\w\d]*(\w+|\d+)\s*$/);
    if (m) {
        var month = m[1];
        var day = m[2];
        if (month.match(/\d+/)) {
            month = day;
            day = m[1];
        }
        m = day.match(/\d+/);
        day = m ? m[0] : 1;
        index = Array.indexOfCaseInsensitive(dtf.MonthNames, month);
        if (index == -1)
            index = Array.indexOfCaseInsensitive(dtf.AbbreviatedMonthNames, month);
        if (index >= 0) {
            d.setDate(1);
            while (d.getMonth() != index)
                d.setMonth(d.getMonth() + 1);
            d.setDate(day);
            return d;
        }
    }
    m = s.match(/^\s*(\d\d?)(\D*(\d\d?))?(\D*(\d+))?\s*$/);
    if (!m) return null;
    try {
        if (!dtf.LogicalYearPosition) {
            var ami = dtf.ShortDatePattern.indexOf('m');
            if (ami < 0)
                ami = dtf.ShortDatePattern.indexOf('M');
            var adi = dtf.ShortDatePattern.indexOf('d');
            if (adi < 0)
                adi = dtf.ShortDatePattern.indexOf('D'); ;
            dtf.LogicalYearPosition = 5;
            dtf.LogicalMonthPosition = ami < adi ? 1 : 3;
            dtf.LogicalDayPosition = ami < adi ? 3 : 1;
        }
        var dy = m[dtf.LogicalYearPosition];
        if (String.isNullOrEmpty(dy))
            dy = d.getFullYear();
        else
            dy = Number.parseLocale(dy);
        var dm = m[dtf.LogicalMonthPosition];
        if (String.isNullOrEmpty(dm))
            dm = d.getMonth();
        else {
            dm = Number.parseLocale(dm);
            dm--;
        }
        var dd = m[dtf.LogicalDayPosition];
        if (String.isNullOrEmpty(dd))
            dd = d.getDay();
        else
            dd = Number.parseLocale(dd);
        d = new Date(dy, dm, dd);
    }
    catch (err) {
        return null;
    }
    return d;
}

Date.tryParseFuzzyTime = function (s) {
    if (String.isNullOrEmpty(s)) return null;
    var d = null;
    var dtf = Sys.CultureInfo.CurrentCulture.dateTimeFormat;
    var m = s.match(/^\s*(\d\d?)(\D*(\d\d?))?(\s*(\w+))?\s*$/);
    if (!m)
        m = s.match(/^\s*(\d\d?)(\D*(\d\d?))?(\D*(\d\d?))?(\D*(\d+))?(\s*([\S\s]+))?\s*$/);
    if (m) {
        d = new Date();
        var hh = m[1];
        var mm = m[3];
        var ss = m.length == 10 ? m[5] : '';
        var ms = m.length == 10 ? m[7] : '';
        var ampm = m[m.length - 1];
        if (!String.isNullOrEmpty(hh)) {
            hh = Number.parseLocale(hh);
            if (!String.isNullOrEmpty(ampm))
                if (ampm.toLowerCase() == dtf.PMDesignator.toLowerCase()) {
                    if (hh != 12)
                        hh += 12
                }
                else {
                    if (hh == 12)
                        hh = 0
                }
            else
                if (!String.isNullOrEmpty(dtf.PMDesignator) && dtf.ShortTimePattern.indexOf('tt') > 0 && new Date().getHours() >= 12)
                    hh += 12;
            d.setHours(hh);
        }

        if (!String.isNullOrEmpty(mm))
            d.setMinutes(Number.parseLocale(mm));
        d.setSeconds(!String.isNullOrEmpty(ss) ? Number.parseLocale(ss) : 0);
        d.setMilliseconds(!String.isNullOrEmpty(ms) ? Number.parseLocale(ms) : 0);
    }
    return d;
}

Sys.Serialization.JavaScriptSerializer.deserialize = function (data, secure) {
    if (Sys.Serialization.JavaScriptSerializer._timeZoneOffset == null) {
        Sys.Serialization.JavaScriptSerializer._timeZoneOffset = "$1new Date($2)";
        if (typeof (__timeZoneUtcOffset) != 'undefined') {
            var offset = (new Date().getTimezoneOffset() + __timeZoneUtcOffset) * 60 * 1000;
            if (offset != 0)
                Sys.Serialization.JavaScriptSerializer._timeZoneOffset = String.format('$1new Date($2{0}{1})', offset < 0 ? '-' : '+', offset < 0 ? offset * -1 : offset);
        }
    }
    var er, esc = Sys.Serialization.JavaScriptSerializer._esc;
    try {
        var exp = data.replace(esc.dateRegEx, Sys.Serialization.JavaScriptSerializer._timeZoneOffset/*"$1new Date($2 - 150*60*1000)"*/);

        if (secure && esc.jsonRegEx.test(exp.replace(esc.jsonStringRegEx, ''))) throw null;

        return eval('(' + exp + ')');
    }
    catch (er) {
        throw Error.argument('data', Sys.Res.cannotDeserializeInvalidJson);
    }
}

Date.$addDays = function (d, delta) {
    return d ? new Date(d.setDate(d.getDate() + delta)) : d;
}

Date.$now = function () {
    return new Date();
}

Date.$today = function () {
    var d = new Date();
    return new Date(d.getFullYear(), d.getMonth(), d.getDate(), 0, 0, 0);
}

Date.$endOfDay = function () {
    var d = new Date();
    return new Date(d.getFullYear(), d.getMonth(), d.getDate(), 23, 59, 59);
}

Date.$within = function (d, delta) {
    return d ? d < Date.$addDays(Date.$today(), delta) && d >= Date.$today() : false;
}

Date.$pastDue = function (d1, d2) {
    if (d2 == null)
        d2 = new Date();
    if (d2.getHours() == 0)
        d2 = new Date(d2.getFullYear(), d2.getMonth(), d2.getDate(), 23, 59, 59);
    if (d1 == null) d1 = new Date();
    return d1 > d2;
}

Web.DataView._blankRegex = /^\s*$/;
Web.DataView._fieldFilterRegex = /(\w+):([\s\S]*)/;
Web.DataView._filterRegex = /(\*|~|\$\w+\$|=|~|>=?|<(=|>){0,1})([\s\S]*?)(\0|$)$/;
Web.DataView._filterIteratorRegex = /(\*|~|\$\w+\$|=|~|>=?|<(=|>){0,1})([\s\S]*?)(\0|$)/g;
Web.DataView._keepCapitalization = /^\$(month|quarter|true|false)/;
Web.DataView._listRegex = /\$and\$|\$or\$/;
Web.DataView._simpleListRegex = /\s*,\s*/;
Web.DataView._htmlTest = /<\w+.*?>/;

function __designer() {
    return typeof __designerMode != 'undefined';
}

function __evalEvent(eventName) {
    var script = this.getAttribute('on' + eventName + '2');
    if (String.isNullOrEmpty(script))
        return true;
    var returnResult = true;
    script = script.replace(/(^|;)return /g, ';returnResult=');
    eval(script);
    return returnResult;
}


Web.BusinessRules = function (dataView) {
    this._dataView = dataView;
    this.result = new Web.BusinessRules.Result(this);
}

Web.BusinessRules.prototype = {
    canceled: function () {
        return this._canceled == true;
    },
    dispose: function () {
        this.reset(null);
        this._dataView = null;
        this.result._rules = null;
    },
    reset: function (args) {
        this._actionArgs = null;
        this._args = args;
    },
    _initialize: function () {
        if (!this._actionArgs) {
            var dataView = this._dataView;
            this._actionArgs = dataView._createArguments(this._args, null);
            if (dataView.get_isEditing()) {
                dataView._validateFieldValues(this._actionArgs.Values, this._args.causesValidation == null || this._args.causesValidation);
                this._valid = dataView.validate(this._actionArgs.Values);
            }
        }
    },
    process: function (phase) {
        var dataView = this._dataView;
        var commandName = this._args.commandName;
        if (commandName == 'Calculate' && dataView._lookupIsActive) {
            this.preventDefault();
            return;
        }

        var wdvg = Web.DataView.Geo;
        if (wdvg && !(__tf != 4) && commandName.match(/New|Edit/)) {
            var fields = this._dataView._fields;
            for (var i = 0; i < fields.length; i++) {
                var f = fields[i];
                if (!f.readOnly) {
                    if (f.tagged('modified-latitude') || f.tagged('created-latitude') && commandName == 'New')
                        this.updateFieldValue(f.Name, wdvg.latitude == -1 ? null : wdvg.latitude);
                    else if (f.tagged('modified-longitude') || f.tagged('created-longitude') && commandName == 'New')
                        this.updateFieldValue(f.Name, wdvg.longitude == -1 ? null : wdvg.longitude);
                    else if (f.tagged('modified-coords') || f.tagged('created-coords') && commandName == 'New')
                        this.updateFieldValue(f.Name, wdvg.latitude == -1 ? null : String.format('{0},{1}', wdvg.latitude, wdvg.longitude));
                }
            }
            if (this._newValues) {
                dataView._updateCalculatedFields({ 'Errors': [], 'Values': this._newValues });
                this._newValues = null;
            }
        }

        var expressions = dataView._expressions;
        if (!expressions || expressions.length == 0)
            return;
        if (!this._rules) {
            this._rules = [];
            var ruleIndex = 0;
            for (i = 0; i < expressions.length; i++) {
                var exp = expressions[i];
                if (exp.Type == Web.DynamicExpressionType.ClientScript && exp.Scope == Web.DynamicExpressionScope.Rule) {
                    var m = exp.Result.match(/^<id>(.+?)<\/id><commandName>(.+?)<\/commandName><commandArgument>(.*?)<\/commandArgument><view>(.*?)<\/view><phase>(.*?)<\/phase><script>([\s\S]+?)<\/script>$/);
                    if (m) {
                        var ruleName = String.format('Web.BusinessRules.{0}_Rule_{1}', dataView._controller, m[1] ? m[1] : ruleIndex);
                        var ruleFunc = eval(String.format('typeof {0} !="undefined"?{0}:null', ruleName));
                        if (!ruleFunc)
                            ruleFunc = eval(this._parseRule(ruleName, m[6]));
                        Array.add(this._rules, { 'commandName': m[2], 'commandArgument': m[3], 'view': m[4], 'phase': m[5], 'script': ruleFunc });
                    }
                }
            }
        }
        for (i = 0; i < this._rules.length; i++) {
            var r = this._rules[i];
            if (r.phase != phase)
                continue;
            var skip = false;
            if (!String.isNullOrEmpty(r.view)) {
                var viewId = dataView.get_viewId();
                if (!(r.view == viewId || viewId.match(new RegExp(r.view))))
                    skip = true;
            }
            if (!String.isNullOrEmpty(r.commandName)) {
                commandName = this._args.commandName;
                if (!(r.commandName == commandName || commandName.match(new RegExp(r.commandName))))
                    skip = true;
            }
            if (!String.isNullOrEmpty(r.commandArgument)) {
                var commandArgument = this._args.commandArgument;
                if (!(r.commandArgument == commandArgument || commandArgument && commandArgument.match(new RegExp(r.commandArgument))))
                    skip = true;
            }
            if (!skip) {
                r.script.call(this);
                if (this.canceled())
                    break;
            }
        }
        if (this._newValues) {
            dataView._updateCalculatedFields({ 'Errors': [], 'Values': this._newValues });
            delete (this._newValues);
            this._pendingFocus();
        }
        else if (this.canceled() && dataView.get_isDataSheet()) {
            dataView._updateCalculatedFields({ 'Errors': [], 'Values': [] });
            this._pendingFocus();
        }
    },
    _pendingFocus: function () {
        if (this._focusFieldName) {
            this._dataView._focus(this._focusFieldName, this._focusMessage);
            this._focusFieldName = null;
        }
    },
    before: function (args) {
        this.reset(args);
        this.process('Before');
        if (!this.canceled())
            this.process('Execute');
    },
    after: function (args) {
        if (this._dataView._isBusy)
            return;
        this.reset(args);
        this.process('After');
    },
    _parseRule: function (ruleName, script) {
        var extendedScript = new Sys.StringBuilder();
        extendedScript.appendFormat('{0}=function(){{\n', ruleName);
        var iterator = /([\s\S]*?)(\[(\w+)(\.(\w+))?\](\s*=([^=][\s\S]+?);)?)/g;
        this._parseScript(extendedScript, iterator, script);
        script = extendedScript.toString();
        extendedScript.clear();
        this._parseScript(extendedScript, iterator, script);
        extendedScript.append('\n}');
        return extendedScript.toString();
    },
    _parseScript: function (sb, iterator, script) {
        var lastIndex = -1;
        var m = iterator.exec(script);
        while (m) {
            sb.append(m[1]);
            var fieldName = m[3];
            var scope = m[5];
            if (m[1].match(/\w$/))
                sb.append(m[2]);
            else if (fieldName.match(/^master$/i)) {
                sb.appendFormat('this.fieldValue(\'{0}\',\'Master\')', scope);
            }
            else {
                var field = this._dataView.findField(fieldName);
                if (!String.isNullOrEmpty(m[7]))
                    sb.appendFormat('this.updateFieldValue(\'{0}\',{1});', fieldName, m[7]);
                else
                    sb.appendFormat('this.fieldValue(\'{0}\',\'{1}\')', fieldName, scope);
                //                if (field)
                //                    if (!String.isNullOrEmpty(m[7]))
                //                        sb.appendFormat('this.updateFieldValue(\'{0}\',{1});', fieldName, m[7]);
                //                    else
                //                        sb.appendFormat('this.fieldValue(\'{0}\',\'{1}\')', fieldName, scope);
                //                else
                //                    sb.append(m[2]);
            }
            lastIndex = iterator.lastIndex;
            m = iterator.exec(script);
        }
        if (lastIndex != -1)
            sb.append(lastIndex < script.length ? script.substr(lastIndex) : '');
        else
            sb.append(script);

    },
    preventDefault: function () {
        this._canceled = true;
        this._dataView._raiseSelectedDelayed = false;
        this._dataView._pendingSelectedEvent = false;

    },
    validateInput: function () {
        this._initialize();
        return this._valid == true;
    },
    dataView: function () {
        return this._dataView;
    },
    arguments: function () {
        this._initialize();
        return this._actionArgs;
    },
    selectFieldValueObject: function (fieldName) {
        this._initialize();
        var values = this._actionArgs.Values;
        for (var i = 0; i < values.length; i++) {
            var v = values[i];
            if (fieldName == v.Name)
                return v;
        }
        return null;
    },
    selectFieldValue: function (fieldName) {
        var v = this.selectFieldValueObject(fieldName);
        if (v) {
            if (v.Modified)
                return v.NewValue;
            return v.OldValue;
        }
        return null;
    },
    fieldValue: function (fieldName, type) {
        if (type == 'Master') {
            var masterDataView = this._dataView.get_master();
            return masterDataView ? masterDataView.fieldValue(fieldName) : null;
        }
        if (!type || type == 'Value')
            return this.selectFieldValue(fieldName);
        var v = this.selectFieldValueObject(fieldName);
        if (!v)
            this._unknownField(fieldName);
        switch (type) {
            case 'NewValue':
                return v.NewValue;
            case 'OldValue':
                return v.OldValue;
            case 'Modified':
                return v.Modified;
            case 'ReadOnly':
                return v.ReadOnly;
            case 'Error':
                return v.Error;
            default:
                return v.OldValue;
        }
    },
    updateFieldValue: function (fieldName, value) {
        var v = this.selectFieldValueObject(fieldName);
        if (v) {
            v.NewValue = value;
            v.Modified = true;
            var newValues = this._newValues;
            if (!newValues)
                newValues = this._newValues = [];
            for (var i = 0; i < newValues.length; i++)
                if (newValues[i].Name == fieldName) {
                    Array.removeAt(newValues, i);
                    break;
                }
            Array.add(newValues, v);
        }
        else
            this._unknownField(fieldName);
    },
    property: function (name, value) {
        name = 'Rules$' + name;
        if (arguments.length == 1)
            return this._dataView.readContext(name);
        else
            this._dataView.writeContext(name, value);
    },
    _unknownField: function (fieldName) {
        throw new Error(String.format('Unknown field "{0}" is not defined in  /controllers/{1}/views/{2}.', fieldName, this._dataView._controller, this._dataView._viewId));
    }
}

Web.BusinessRules.Result = function (rules) {
    this._rules = rules;
}

Web.BusinessRules.Result.prototype = {
    focus: function (fieldName, fmt, args) {
        var message = null;
        if (arguments.length > 1) {
            var newArguments = Array.clone(arguments);
            Array.removeAt(newArguments, 0);
            message = String._toFormattedString(true, newArguments);
        }
        var rules = this._rules;
        var dataView = rules._dataView;
        rules._focusFieldName = fieldName;
        rules._focusMessage = message;
        dataView._focus(fieldName, message);
    },
    showMessage: function (fmt, args) {
        Web.DataView.showMessage(String._toFormattedString(true, arguments));
    },
    showViewMessage: function (fmt, args) {
        this._rules._dataView.showViewMessage(String._toFormattedString(true, arguments));
    },
    showAlert: function (fmt, args) {
        alert(String._toFormattedString(true, arguments));
    },
    confirm: function (fmt, args) {
        return confirm(String._toFormattedString(true, arguments));
    },
    refresh: function (fetch) {
        this._rules._dataView(fetch == true);
    },
    refreshChildren: function () {
        var dataView = this._rules._dataView;
        dataView._forceChanged = true;
        dataView._raiseSelectedDelayed = true;
        this.refresh(true);
    }
}

Web$DataView$RichText = function () { }
Web$DataView$RichText.prototype = {
    attach: function (element, viewType) {
        var $element = $(element);
        $element.addClass('dataview-rich-text');
        var lang = $('html').attr('lang');
        if (String.isNullOrEmpty(lang))
            lang = $('html').attr('xml:lang');
        if (typeof CKEDITOR != 'undefined') {
            $('<div></div>').insertAfter($element).width($element.outerWidth()).height(1);
            CKEDITOR.replace(element.id, {
                language: lang,
                on:
                {
                    instanceReady: function (ev) {
                        var originalMaximize = CKEDITOR.instances[element.id].getCommand('maximize');
                        if (originalMaximize) {
                            originalMaximize._old_exec = originalMaximize.exec;
                            originalMaximize.exec = function (editor) {
                                this._old_exec(editor);
                                $(ev.editor.container.$).find('.cke_maximized').css('z-index', 10001);
                            }
                        }
                    }
                }
            });
        }
        else {
            var editorResources = Web.DataViewResources.Editor;
            var buttons = [
                    { CommandName: 'Undo', Tooltip: editorResources.Undo },
                    { CommandName: 'Redo', Tooltip: editorResources.Redo },
                    { CommandName: 'Bold', Tooltip: editorResources.Bold, ElementWhiteList: { b: ['style'], strong: ['style']} },
                    { CommandName: 'Italic', Tooltip: editorResources.Italic, ElementWhiteList: { i: ['style'], em: ['style']} },
                    { CommandName: 'Underline', Tooltip: editorResources.Underline, ElementWhiteList: { u: ['style']} },
                    { CommandName: 'StrikeThrough', Tooltip: editorResources.Strikethrough, ElementWhiteList: { strike: ['style']} },
                    { CommandName: 'Subscript', Tooltip: editorResources.Subscript, ElementWhiteList: { sub: ['style']} },
                    { CommandName: 'Superscript', Tooltip: editorResources.Superscript, ElementWhiteList: { sup: ['style']} },

                    { CommandName: 'JustifyLeft', Tooltip: editorResources.JustifyLeft, ElementWhiteList: { p: ['align'], div: ['style', 'align'] }, AttributeWhiteList: { style: ['text-align'] }, align: ['left'] },
                    { CommandName: 'JustifyCenter', Tooltip: editorResources.JustifyCenter, ElementWhiteList: { p: ['align'], div: ['style', 'align'] }, AttributeWhiteList: { style: ['text-align'] }, align: ['center'] },
                    { CommandName: 'JustifyRight', Tooltip: editorResources.JustifyRight, ElementWhiteList: { p: ['align'], div: ['style', 'align'] }, AttributeWhiteList: { style: ['text-align'] }, align: ['right'] },
                    { CommandName: 'JustifyFull', Tooltip: editorResources.JustifyFull, ElementWhiteList: { p: ['align'], div: ['style', 'align'] }, AttributeWhiteList: { style: ['text-align'] }, align: ['justify'] },

                    { CommandName: 'insertOrderedList', Tooltip: editorResources.InsertOrderedList, ElementWhiteList: { ol: [], li: []} },
                    { CommandName: 'insertUnorderedList', Tooltip: editorResources.InsertUnorderedList, ElementWhiteList: { ul: [], li: []} },

                    { CommandName: 'createLink', Tooltip: editorResources.CreateLink, ElementWhiteList: { a: ['href']} },
                    { CommandName: 'UnLink', Tooltip: editorResources.UnLink },

                    { CommandName: 'RemoveFormat', Tooltip: editorResources.RemoveFormat },
                    { CommandName: 'SelectAll', Tooltip: editorResources.SelectAll },
                    { CommandName: 'UnSelect', Tooltip: editorResources.UnSelect },

                    { CommandName: 'Delete', Tooltip: editorResources.Delete },
                    { CommandName: 'Cut', Tooltip: editorResources.Cut },
                    { CommandName: 'Paste', Tooltip: editorResources.Paste },


                    { CommandName: 'BackColor', Tooltip: editorResources.BackColor, ElementWhiteList: { font: 'style', span: 'style' }, AttributeWhiteList: { style: 'background-color'} },
                    { CommandName: 'ForeColor', Tooltip: editorResources.ForeColor, ElementWhiteList: { font: 'color' }, AttributeWhiteList: { font: 'color'} },

                    { CommandName: 'FontName', Tooltip: editorResources.FontName, ElementWhiteList: { font: ['face'] }, AttributeWhitList: { face: []} },
                    { CommandName: 'FontSize', Tooltip: editorResources.FontSize, ElementWhiteList: { font: ['size'] }, AttributeWhitList: { size: []} },

                    { CommandName: 'Indent', Tooltip: editorResources.Indent, ElementWhiteList: { blockquote: ['style', 'dir'] }, AttributeWhitList: { style: ['margin', 'margin-right', 'padding', 'border'], dir: ['ltr', 'rtl', 'auto']} },
                    { CommandName: 'Outdent', Tooltip: editorResources.Outdent },
                    { CommandName: 'InsertHorizontalRule', Tooltip: editorResources.InsertHorizontalRule, ElementWhiteList: { hr: ['size', 'width'] }, AttributeWhiteList: { size: [], width: []} },

                    { CommandName: 'HorizontalSeparator', Tooltip: '' }
            ];
            if (navigator.appVersion.match(/MSIE/))
                buttons.splice(0, 2);
            var type = Sys.Extended.UI.HtmlEditorExtenderBehavior;
            if (!type._customized) {
                type.prototype.old_executeCommand = type.prototype._executeCommand;
                type.prototype._executeCommand = function (command) {
                    $(this._editableDiv).focus();
                    this.old_executeCommand(command);
                };
                type._customized = true;
            }
            var editor = $create(type, {
                ToolbarButtons: buttons, id: element.id + '$Editor'
            }, null, null, element);
            editor._noEncoding = true;
            editor._editableDiv.tabIndex = element.tabIndex;
            var topButtonContainer = $(editor._topButtonContainer);
            topButtonContainer.find('nobr span').hide();
            topButtonContainer.find('select').css({ 'font-family': '', 'font-size': '' });
            //var $editor = $(editor._editableDiv)
            //var cell = $editor.parents('.FieldWrapper').parent();
            //var cellPos = cell.offset();
            //var cellWidth = cell.width();
            //var myPos = $editor.offset();
            //var myWidth = $editor.width();
            //if (cellPos.left + cellWidth > myPos.left + myWidth) {
            //    myWidth = cellPos.left + cellWidth - myPos.left;
            //    $editor.width(myWidth);
            //}
        }
        return true;
    },
    detach: function (element, viewType) {
        if (typeof CKEDITOR != 'undefined') {
            CKEDITOR.remove(element.id);
        } else {
            var editor = $find(element.id + '$Editor');
            if (editor)
                editor.dispose();
        }
        return true;
    },
    persist: function (element) {
        if (typeof CKEDITOR != 'undefined') {
            element.value = CKEDITOR.instances[element.id].getData();
        }
        else {
            var editor = $find(element.id + '$Editor');
            if (editor)
                element.value = editor._editableDiv.innerHTML;
        }
    }
}

if (typeof (Sys) !== 'undefined') Sys.Application.notifyScriptLoaded();
