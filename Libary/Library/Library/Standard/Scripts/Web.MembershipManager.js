/// <reference name="MicrosoftAjax.debug.js" />
/// <reference name="AjaxControlToolkit.ExtenderBase.BaseScripts.js" assembly="AjaxControlToolkit" />
/// <reference name="AjaxControlToolkit.Common.Common.js" assembly="AjaxControlToolkit" />
/// <reference name="AjaxControlToolkit.DropDown.DropDownBehavior.js" assembly="AjaxControlToolkit"/>
/// <reference name="AjaxControlToolkit.ModalPopup.ModalPopupBehavior.js" assembly="AjaxControlToolkit"/>
/// <reference name="AjaxControlToolkit.AlwaysVisibleControl.AlwaysVisibleControlBehavior.js" assembly="AjaxControlToolkit"/>
/// <reference name="AjaxControlToolkit.PopupControl.PopupControlBehavior.js" assembly="AjaxControlToolkit"/>
/// <reference name="AjaxControlToolkit.Calendar.CalendarBehavior.js" assembly="AjaxControlToolkit"/>
/// <reference name="AjaxControlToolkit.Tabs.Tabs.js" assembly="AjaxControlToolkit"/>
/// <reference path="Web.DataViewResources.js"/>
/// <reference path="Web.MembershipResources.js" />

Type.registerNamespace("Web");

Web.MembershipManager = function (element) {
    Web.MembershipManager.initializeBase(this, [element]);
}

Web.MembershipManager.prototype = {
    get_servicePath: function () {
        return this._servicePath;
    },
    set_servicePath: function set_servicePath(value) {
        this._servicePath = value;
    },
    get_baseUrl: function () {
        return this._baseUrl;
    },
    set_baseUrl: function (value) {
        this._baseUrl = value;
    },
    initialize: function () {
        Web.MembershipManager.callBaseMethod(this, 'initialize');
    },
    dispose: function () {
        Web.MembershipManager.callBaseMethod(this, 'dispose');
    },
    updated: function () {
        Web.MembershipManager.callBaseMethod(this, 'updated');
        var elem = this.get_element(),
            mobile = $appfactory.mobile,
            wmrm = Web.MembershipResources.Manager,
            baseUrl = this.get_baseUrl();

        if (mobile) {
            ;
            $(String.format(
                '<div data-flow="NewRow">' +
                '<div data-activator="Tab|{0}">' +
                '    <div id="membershipUsers"></div>' +
                ' </div>' +
                ' <div data-activator="Tab|{1}">' +
                '    <div id="membershipRoles"></div>' +
                '</div>' +
                '<div data-activator="Tab|{2}">' +
                '    <div id="membershipRoleUsers"></div>' +
                '</div>' +
                '</div>', wmrm.UsersTab, wmrm.RolesTab, wmrm.UsersInRole)).appendTo($appfactory.mobile.content());
        }
        else {
            Sys.UI.DomElement.addCssClass(elem, 'MembershipManager');

            var sb = new Sys.StringBuilder();
            sb.append('<div class="TabContainer" id="MembershipManager1_SecurityTabs" style="visibility:hidden;">');
            sb.append('<div id="MembershipManager1_SecurityTabs_header">');
            sb.append(String.format('<span id="__tab_MembershipManager1_SecurityTabs_UsersTab">{0}</span><span id="__tab_MembershipManager1_SecurityTabs_RolesTab">{1}</span>', wmrm.UsersTab, wmrm.RolesTab));
            sb.append('</div><div id="MembershipManager1_SecurityTabs_body">');
            sb.append('<div id="MembershipManager1_SecurityTabs_UsersTab" style="display:none;visibility:hidden;">');
            sb.append('<div id="MembershipManager1_SecurityTabs_UsersTab_Users"></div>');
            sb.append('</div><div id="MembershipManager1_SecurityTabs_RolesTab" style="display:none;visibility:hidden;">');
            sb.append('<div id="MembershipManager1_SecurityTabs_RolesTab_Roles"></div>');
            sb.append('<div id="MembershipManager1_SecurityTabs_RolesTab_UsersInRoles" style="margin-top: 8px"></div>');
            sb.append('</div>');
            sb.append('</div>');
            sb.append('</div>');
            elem.innerHTML = sb.toString();

        }
        $create(Web.DataView, { "baseUrl": baseUrl, "controller": "aspnet_Membership", "id": "MembershipManager1_SecurityTabs_UsersTab_UsersExtender", "pageSize": 10, "servicePath": this.get_servicePath(), "showActionBar": true, "viewId": null, "showSearchBar": true, 'showFirstLetters': true }, null, null, mobile ? $("#membershipUsers")[0] : $get("MembershipManager1_SecurityTabs_UsersTab_Users", elem));
        if (!mobile)
            $create(AjaxControlToolkit.TabPanel, { "headerTab": $get("__tab_MembershipManager1_SecurityTabs_UsersTab", elem) }, null, { "owner": "MembershipManager1_SecurityTabs" }, $get("MembershipManager1_SecurityTabs_UsersTab", elem));
        $create(Web.DataView, { "baseUrl": baseUrl, "controller": "aspnet_Roles", "id": "MembershipManager1_SecurityTabs_RolesTab_RolesExtender", "pageSize": 5, "servicePath": this.get_servicePath(), "showActionBar": true, "viewId": null, "showSearchBar": true }, null, null, mobile ? $("#membershipRoles")[0] : $get("MembershipManager1_SecurityTabs_RolesTab_Roles", elem));
        $create(Web.DataView, { "baseUrl": baseUrl, "controller": "aspnet_Membership", "filterFields": "RoleId", "filterSource": "MembershipManager1_SecurityTabs_RolesTab_RolesExtender", "id": "MembershipManager1_SecurityTabs_RolesTab_UsersInRolesExtender", "pageSize": 5, "servicePath": this.get_servicePath(), "showActionBar": true, "viewId": "usersInRolesGrid", "autoHide": 1, "showSearchBar": true, 'showFirstLetters': true }, null, null, mobile ? $("#membershipRoleUsers")[0] : $get("MembershipManager1_SecurityTabs_RolesTab_UsersInRoles", elem));
        if (!mobile) {
            $create(AjaxControlToolkit.TabPanel, { "headerTab": $get("__tab_MembershipManager1_SecurityTabs_RolesTab", elem) }, null, { "owner": "MembershipManager1_SecurityTabs" }, $get("MembershipManager1_SecurityTabs_RolesTab", elem));
            $create(AjaxControlToolkit.TabContainer, { "activeTabIndex": 0, "clientStateField": $get("MembershipManager1_SecurityTabs_ClientState", elem) }, null, null, $get("MembershipManager1_SecurityTabs", elem));
        }
    }
}

Web.MembershipManager.registerClass('Web.MembershipManager', Sys.UI.Behavior);

if (Sys.Extended && typeof (AjaxControlToolkit) == "undefined") AjaxControlToolkit = Sys.Extended.UI;

if (typeof (Sys) !== 'undefined') Sys.Application.notifyScriptLoaded();
