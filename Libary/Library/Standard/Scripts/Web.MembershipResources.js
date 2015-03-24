/// <reference name="MicrosoftAjax.debug.js" />

Type.registerNamespace("Web");

if (!Web) Web = {}
Web.MembershipResources = {}
Web.MembershipResources.Bar = {
    LoginLink: '^LoginLink^Login^LoginLink^',
    LoginText: ' ^ToThisWebsite^to this website^ToThisWebsite^',
    HelpLink: '^Help^Help^Help^',
    UserName: '^UserName^User Name^UserName^:',
    Password: '^Password^Password^Password^:',
    RememberMe: '^RememberMe^Remember me next time^RememberMe^',
    ForgotPassword: '^ForgotYourPassword^Forgot your password?^ForgotYourPassword^',
    SignUp: '^SignUpNow^Sign up now^SignUpNow^',
    LoginButton: '^LoginButton^Login^LoginButton^',
    MyAccount: '^MyAccount^My Account^MyAccount^',
    LogoutLink: '^Logout^Logout^Logout^',
    HelpCloseButton: '^HelpClose^Close^HelpClose^',
    HelpFullScreenButton: '^HelpFullScreen^Full Screen^HelpFullScreen^',
    UserIdle: '^IdleUser^Are you still there? Please login again.^IdleUser^',
    History: '^History^History^History^',
    Permalink: '^Permalink^Permalink^Permalink^',
    AddToFavorites: '^AddToFavorites^Add to Favorites^AddToFavorites^',
    RotateHistory: '^Rotate^Rotate^Rotate^',
    Welcome: '^Welcome1^Welcome^Welcome1^ <b>{0}</b>, ^Welcome2^Today is^Welcome2^ {1:D}',
    ChangeLanguageToolTip: '^ChangeYourLanguage^Change your language^ChangeYourLanguage^',
    PermalinkToolTip: '^PermalinkToolTip^Create a permanent link for selected record^PermalinkToolTip^',
    HistoryToolTip: '^HistoryToolTip^View history of previously selected records^HistoryToolTip^',
    AutoDetectLanguageOption: 'Auto Detect'
}

Web.MembershipResources.Messages = {
    InvalidUserNameAndPassword: '^InvalidUserNameAndPassword^Your user name and password are not valid.^InvalidUserNameAndPassword^',
    BlankUserName: '^BlankUserName^User name cannot be blank.^BlankUserName^',
    BlankPassword: '^BlankPassword^Password cannot be blank.^BlankPassword^',
    PermalinkUnavailable: '^PermalinkUnavailable^Permalink is not available. Please select a record.^PermalinkUnavailable^',
    HistoryUnavailable: '^HistoryUnavailable^History is not available.^HistoryUnavailable^'
}

Web.MembershipResources.Manager = {
    UsersTab: '^UsersTab^Users^UsersTab^',
    RolesTab: '^RolesTab^Roles^RolesTab^',
    UsersInRole: '^UsersInRole^Users in Role^UsersInRole^'
}

if (typeof (Sys) !== 'undefined') Sys.Application.notifyScriptLoaded();
