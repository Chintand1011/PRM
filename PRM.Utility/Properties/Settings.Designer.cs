﻿//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:4.0.30319.18444
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace PatientPortal.Utility.Properties {
    
    
    [global::System.Runtime.CompilerServices.CompilerGeneratedAttribute()]
    [global::System.CodeDom.Compiler.GeneratedCodeAttribute("Microsoft.VisualStudio.Editors.SettingsDesigner.SettingsSingleFileGenerator", "12.0.0.0")]
    internal sealed partial class Settings : global::System.Configuration.ApplicationSettingsBase {
        
        private static Settings defaultInstance = ((Settings)(global::System.Configuration.ApplicationSettingsBase.Synchronized(new Settings())));
        
        public static Settings Default {
            get {
                return defaultInstance;
            }
        }
        
        [global::System.Configuration.ApplicationScopedSettingAttribute()]
        [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
        [global::System.Configuration.SpecialSettingAttribute(global::System.Configuration.SpecialSetting.WebServiceUrl)]
        [global::System.Configuration.DefaultSettingValueAttribute("https://dev.ftipgw.com/smartpayments/transact.asmx")]
        public string PatientPortal_Utility_FS_Transact_Dev_SmartPayments {
            get {
                return ((string)(this["PatientPortal_Utility_FS_Transact_Dev_SmartPayments"]));
            }
        }
        
        [global::System.Configuration.ApplicationScopedSettingAttribute()]
        [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
        [global::System.Configuration.SpecialSettingAttribute(global::System.Configuration.SpecialSetting.WebServiceUrl)]
        [global::System.Configuration.DefaultSettingValueAttribute("https://secure.ftipgw.com/smartpayments/transact.asmx")]
        public string PatientPortal_Utility_FS_Transact_Prod_SmartPayments {
            get {
                return ((string)(this["PatientPortal_Utility_FS_Transact_Prod_SmartPayments"]));
            }
        }
        
        [global::System.Configuration.ApplicationScopedSettingAttribute()]
        [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
        [global::System.Configuration.SpecialSettingAttribute(global::System.Configuration.SpecialSetting.WebServiceUrl)]
        [global::System.Configuration.DefaultSettingValueAttribute("https://secure.ftipgw.com/smartpayments/transact3.asmx")]
        public string PatientPortal_Utility_FS_Transact_Reader_SmartPayments3 {
            get {
                return ((string)(this["PatientPortal_Utility_FS_Transact_Reader_SmartPayments3"]));
            }
        }
        
        [global::System.Configuration.ApplicationScopedSettingAttribute()]
        [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
        [global::System.Configuration.SpecialSettingAttribute(global::System.Configuration.SpecialSetting.WebServiceUrl)]
        [global::System.Configuration.DefaultSettingValueAttribute("https://dev.ftipgw.com/admin/ws/trxdetail.asmx")]
        public string PatientPortal_Utility_FS_TrxDetail_Dev_TrxDetail {
            get {
                return ((string)(this["PatientPortal_Utility_FS_TrxDetail_Dev_TrxDetail"]));
            }
        }
        
        [global::System.Configuration.ApplicationScopedSettingAttribute()]
        [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
        [global::System.Configuration.SpecialSettingAttribute(global::System.Configuration.SpecialSetting.WebServiceUrl)]
        [global::System.Configuration.DefaultSettingValueAttribute("https://secure.ftipgw.com/admin/ws/trxdetail.asmx")]
        public string PatientPortal_Utility_FS_TrxDetail_Prod_TrxDetail {
            get {
                return ((string)(this["PatientPortal_Utility_FS_TrxDetail_Prod_TrxDetail"]));
            }
        }
    }
}