<%@ Page Language="C#" AutoEventWireup="true" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>DotNetNuke Factory Login</title>
    <style type="text/css">
        .Login
        {
            border: solid 1px silver;
        }
        .Login tr td
        {
            padding: 2px;
            font-family: Tahoma;
            font-size: 8.5pt;
        }
        input
        {
            font-family: Tahoma;
            font-size: 8.5pt;
        }
        .MessageBox
        {
            border-collapse: collapse;
            margin-bottom: 16px;
        }
        .MessageBox tr td
        {
            border: solid 1px silver;
            background-color: InfoBackground;
            padding: 4px;
            font-family: Tahoma;
            font-size: 8.5pt;
        }
    </style>
</head>
<body onload="document.getElementById('Login1_UserName').focus();">
    <form id="form1" runat="server">
    <div>
        <div style="margin: 50px;">
            <table class="MessageBox">
                <tr>
                    <td>
                        Please enter a user name and password registered
                        <br />
                        in the development instance of <b>DotNetNuke</b> portal.
                    </td>
                </tr>
            </table>
            <asp:Login ID="Login1" runat="server" CssClass="Login" />
        </div>
    </div>
    </form>
</body>
</html>
