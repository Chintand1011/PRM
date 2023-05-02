using System;
using System.ComponentModel;

public enum NotificationType
{
    [Description("success")]
    Success,
    [Description("danger")]
    Danger,
    [Description("info")]
    Info,
    [Description("warning")]
    Warning
}