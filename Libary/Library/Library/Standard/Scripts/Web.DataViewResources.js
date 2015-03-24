/// <reference name="MicrosoftAjax.debug.js" />
Type.registerNamespace('Web');
if (!Web) Web = {}

Web.DataViewResources = {}

Web.DataViewResources.Common = {
    WaitHtml: '<div class="Wait"></div>'
}

Web.DataViewResources.Pager = {
    ItemsPerPage: '^ItemsPerPage^Items per page: ^ItemsPerPage^',
    PageSizes: [10, 15, 20, 25],
    ShowingItems: '^ShowingItems^Showing <b>{0}</b>-<b>{1}</b> of <b>{2}</b> items^ShowingItems^',
    SelectionInfo: ' (<b>{0}</b> selected)',
    Refresh: '^Refresh^Refresh^Refresh^',
    Next: '^Next^Next^Next^ »',
    Previous: '« ^Previous^Previous^Previous^',
    Page: '^Page^Page^Page^',
    PageButtonCount: 10
}

Web.DataViewResources.ActionBar = {
    View: '^View^View^View^'
}

Web.DataViewResources.ModalPopup = {
    Close: '^Close^Close^Close^',
    MaxWidth: 800,
    MaxHeight: 600,
    OkButton: '^OK^OK^OK^',
    CancelButton: '^Cancel^Cancel^Cancel^',
    SaveButton: '^Save^Save^Save^',
    SaveAndNewButton: '^SaveAndNew^Save and New^SaveAndNew^'
}

Web.DataViewResources.Menu = {
    SiteActions: '^SiteActions^Site Actions^SiteActions^',
    SeeAlso: '^SeeAlso^See Also^SeeAlso^',
    Summary: '^Summary^Summary^Summary^',
    Tasks: '^Tasks^Tasks^Tasks^',
    About: '^About^About^About^'
}

Web.DataViewResources.HeaderFilter = {
    GenericSortAscending: '^GenericSortAscending^Smallest on Top^GenericSortAscending^',
    GenericSortDescending: '^GenericSortDescending^Largest on Top^GenericSortDescending^',
    StringSortAscending: '^StringSortAscending^Ascending^StringSortAscending^',
    StringSortDescending: '^StringSortDescending^Descending^StringSortDescending^',
    DateSortAscending: '^DateSortAscending^Earliest on Top^DateSortAscending^',
    DateSortDescending: '^DateSortDescending^Latest on Top^DateSortDescending^',
    EmptyValue: '^EmptyValue^(Empty)^EmptyValue^',
    BlankValue: '^BlankValue^(Blank)^BlankValue^',
    Loading: '^Loading^Loading...^Loading^',
    ClearFilter: '^ClearFilter^Clear Filter from {0}^ClearFilter^',
    SortBy: '^SortBy^Sort by {0}^SortBy^',
    MaxSampleTextLen: 80,
    CustomFilterOption: '^CustomFilterOption^Filter...^CustomFilterOption^'
}

Web.DataViewResources.InfoBar = {
    FilterApplied: '^FilterApplied^A filter has been applied.^FilterApplied^',
    ValueIs: ' <span class="Highlight">{0}</span> ',
    Or: ' ^InfoBarOr^or^InfoBarOr^ ',
    And: ' ^InfoBarAnd^and^InfoBarAnd^ ',
    EqualTo: '^InfoBarEqualTo^is equal to^InfoBarEqualTo^ ',
    LessThan: '^InfoBarLessThan^is less than^InfoBarLessThan^ ',
    LessThanOrEqual: '^InfoBarLessThanOrEqual^is less than or equal to^InfoBarLessThanOrEqual^ ',
    GreaterThan: '^InfoBarGreaterThan^is greater than^InfoBarGreaterThan^ ',
    GreaterThanOrEqual: '^InfoBarGreaterThanOrEqual^is greater than or equal to^InfoBarGreaterThanOrEqual^ ',
    Like: '^InfoBarLike^is like^InfoBarLike^ ',
    StartsWith: '^InfoBarStartsWith^starts with^InfoBarStartsWith^ ',
    Empty: '^InfoBarEmpty^empty^InfoBarEmpty^',
    QuickFind: ' ^InfoBarQuickFind^Any field contains^InfoBarQuickFind^ '
}

Web.DataViewResources.Lookup = {
    SelectToolTip: '^SelectToolTip^Select {0}^SelectToolTip^',
    ClearToolTip: '^ClearToolTip^Clear {0}^ClearToolTip^',
    NewToolTip: '^NewToolTip^New {0}^NewToolTip^',
    SelectLink: '^SelectLink^(select)^SelectLink^',
    ShowActionBar: true,
    DetailsToolTip: '^DetailsToolTip^View details for {0}^DetailsToolTip^',
    ShowDetailsInPopup: true,
    GenericNewToolTip: '^GenericNewToolTip^Create New^GenericNewToolTip^'
}

Web.DataViewResources.Validator = {
    RequiredField: '^RequiredField^This field is required.^RequiredField^',
    EnforceRequiredFieldsWithDefaultValue: false,
    NumberIsExpected: '^NumberIsExpected^A number is expected.^NumberIsExpected^',
    BooleanIsExpected: '^BooleanIsExpected^A logical value is expected.^BooleanIsExpected^',
    DateIsExpected: '^DateIsExpected^A date is expected.^DateIsExpected^'
}

var _mn = Sys.CultureInfo.CurrentCulture.dateTimeFormat.MonthNames;

Web.DataViewResources.Data = {
    NullValue: '<span class="NA">^NullValue^n/a^NullValue^</span>',
    NullValueInForms: '^NullValueInForms^N/A^NullValueInForms^',
    BooleanDefaultStyle: 'DropDownList',
    BooleanOptionalDefaultItems: [[null, '^NullValueInForms^N/A^NullValueInForms^'], [false, '^No^No^No^'], [true, '^Yes^Yes^Yes^']],
    BooleanDefaultItems: [[false, '^No^No^No^'], [true, '^Yes^Yes^Yes^']],
    MaxReadOnlyStringLen: 600,
    NoRecords: '^NoRecords^No records found.^NoRecords^',
    BlobHandler: 'Blob.ashx',
    BlobDownloadLink: '^BlobDownloadLink^download^BlobDownloadLink^',
    BlobDownloadLinkReadOnly: '<span style="color:gray;">^BlobDownloadLink^download^BlobDownloadLink^</span>',
    BlobDownloadHint: '^BlobDownloadHint^Click here to download the original file.^BlobDownloadHint^',
    BatchUpdate: '^BatchUpdate^update^BatchUpdate^',
    NoteEditLabel: '^NoteEditLabel^edit^NoteEditLabel^',
    NoteDeleteLabel: '^NoteDeleteLabel^delete^NoteDeleteLabel^',
    NoteDeleteConfirm: '^NoteDeleteConfirm^Delete?^NoteDeleteConfirm^',
    UseLEV: '^UseLEV^Paste "{0}"^UseLEV^',
    Import: {
        UploadInstruction: '^ImportUploadInstruction^Please select the file to upload. The file must be in <b>CSV</b>, <b>XLS</b>, or <b>XLSX</b> format.^ImportUploadInstruction^',
        DownloadTemplate: '^ImportDownloadTemplate^Download import file template.^ImportDownloadTemplate^',
        Uploading: '^ImportUploading^Your file is being uploaded to the server. Please wait...^ImportUploading^',
        MappingInstruction: '^ImportMappingInstruction^There are <b>{0}</b> record(s) in the file <b>{1}</b> ready to be processed.<br/>Please map the import fields from data file to the application fields and click <i>Import</i> to start processing.^ImportMappingInstruction^',
        StartButton: '^ImportStartButton^Import^ImportStartButton^',
        AutoDetect: '^ImportAutoDetect^(auto detect)^ImportAutoDetect^',
        Processing: '^ImportProcessing^Import file processing has been initiated. The imported data records will become available upon successful processing. You may need to refresh the relevant views/pages to see the imported records.^ImportProcessing^',
        Email: '^ImportEmail^Send the import log to the following email addresses (optional)^ImportEmail^',
        EmailNotSpecified: '^ImportEmailNotSpecified^Recipient of the import log has not been specified. Proceed anyway?^ImportEmailNotSpecified^'
    },
    Filters: {
        Labels: {
            And: '^FilterLabelAnd^and^FilterLabelAnd^',
            Or: '^FilterLabelOr^or^FilterLabelOr^',
            Equals: '^FilterLabelEquals^equals^FilterLabelEquals^',
            Clear: '^FilterLabelClear^Clear^FilterLabelClear^',
            SelectAll: '^FilterLabelSelectAll^(Select All)^FilterLabelSelectAll^',
            Includes: '^FilterLabelIncludes^includes^FilterLabelIncludes^',
            FilterToolTip: '^FilterLabelFilterToolTip^Change^FilterLabelFilterToolTip^'
        },
        Number: {
            Text: '^NumberFilterText^Number Filters^NumberFilterText^',
            List: [
                    { Function: '=', Text: '^Equals^Equals^Equals^', Prompt: true },
                    { Function: '<>', Text: '^DoesNotEqual^Does Not Equal^DoesNotEqual^', Prompt: true },
                    { Function: '<=', Text: '^LessThan^Less Than^LessThan^', Prompt: true },
                    { Function: '>=', Text: '^GreaterThan^Greater Than^GreaterThan^', Prompt: true },
                    { Function: '$between', Text: '^Between^Between^Between^', Prompt: true },
                    { Function: '$in', Text: '^Includes^Includes^Includes^', Prompt: true, Hidden: true },
                    { Function: '$notin', Text: '^DoesNotInclude^Does Not Include^DoesNotInclude^', Prompt: true, Hidden: true }
                ]
        },
        Text: {
            Text: '^TextFilterText^Text Filters^TextFilterText^',
            List: [
                    { Function: '=', Text: '^Equals^Equals^Equals^', Prompt: true },
                    { Function: '<>', Text: '^DoesNotEqual^Does Not Equal^DoesNotEqual^', Prompt: true },
                    { Function: '$beginswith', Text: '^BeginsWith^Begins With^BeginsWith^', Prompt: true },
                    { Function: '$doesnotbeginwith', Text: '^DoesNotBeginWith^Does Not Begin With^DoesNotBeginWith^', Prompt: true },
                    { Function: '$contains', Text: '^Contains^Contains^Contains^', Prompt: true },
                    { Function: '$doesnotcontain', Text: '^DoesNotContain^Does Not Contain^DoesNotContain^', Prompt: true },
                    { Function: '$endswith', Text: '^EndsWith^Ends With^EndsWith^', Prompt: true },
                    { Function: '$doesnotendwith', Text: '^DoesNotEndWith^Does Not End With^DoesNotEndWith^', Prompt: true },
                    { Function: '$in', Text: '^Includes^Includes^Includes^', Prompt: true, Hidden: true },
                    { Function: '$notin', Text: '^DoesNotInclude^Does Not Include^DoesNotInclude^', Prompt: true, Hidden: true }
                ]
        },
        Boolean: {
            Text: '^BooleanFilterText^Logical Filters^BooleanFilterText^',
            List: [
                    { Function: '$true', Text: '^Yes^Yes^Yes^' },
                    { Function: '$false', Text: '^No^No^No^' }
                ]
        },
        Date: {
            Text: '^DateFilterText^Date Filters^DateFilterText^',
            List: [
                    { Function: '=', Text: '^Equals^Equals^Equals^', Prompt: true },
                    { Function: '<>', Text: '^DoesNotEqual^Does Not Equal^DoesNotEqual^', Prompt: true },
                    { Function: '<', Text: '^Before^Before^Before^', Prompt: true },
                    { Function: '>', Text: '^After^After^After^', Prompt: true },
                    { Function: '$between', Text: '^Between^Between^Between^', Prompt: true },
                    { Function: '$in', Text: '^Includes^Includes^Includes^', Prompt: true, Hidden: true },
                    { Function: '$notin', Text: '^DoesNotInclude^Does Not Include^DoesNotInclude^', Prompt: true, Hidden: true },
                    null,
                    { Function: '$tomorrow', Text: '^Tomorrow^Tomorrow^Tomorrow^' },
                    { Function: '$today', Text: '^Today^Today^Today^' },
                    { Function: '$yesterday', Text: '^Yesterday^Yesterday^Yesterday^' },
                    null,
                    { Function: '$nextweek', Text: '^NextWeek^Next Week^NextWeek^' },
                    { Function: '$thisweek', Text: '^ThisWeek^This Week^ThisWeek^' },
                    { Function: '$lastweek', Text: '^LastWeek^Last Week^LastWeek^' },
                    null,
                    { Function: '$nextmonth', Text: '^NextMonth^Next Month^NextMonth^' },
                    { Function: '$thismonth', Text: '^ThisMonth^This Month^ThisMonth^' },
                    { Function: '$lastmonth', Text: '^LastMonth^Last Month^LastMonth^' },
                    null,
                    { Function: '$nextquarter', Text: '^NextQuarter^Next Quarter^NextQuarter^' },
                    { Function: '$thisquarter', Text: '^ThisQuarter^This Quarter^ThisQuarter^' },
                    { Function: '$lastquarter', Text: '^LastQuarter^Last Quarter^LastQuarter^' },
                    null,
                    { Function: '$nextyear', Text: '^NextYear^Next Year^NextYear^' },
                    { Function: '$thisyear', Text: '^ThisYear^This Year^ThisYear^' },
                    { Function: '$yeartodate', Text: '^YearToDate^Year to Date^YearToDate^' },
                    { Function: '$lastyear', Text: '^LastYear^Last Year^LastYear^' },
                    null,
                    { Function: '$past', Text: '^Past^Past^Past^' },
                    { Function: '$future', Text: '^Future^Future^Future^' },
                    null,
                    {
                        Text: '^AllDatesInPreriod^All Dates in Period^AllDatesInPreriod^',
                        List: [
                            { Function: '$quarter1', Text: '^Quarter1^Quarter 1^Quarter1^' },
                            { Function: '$quarter2', Text: '^Quarter2^Quarter 2^Quarter2^' },
                            { Function: '$quarter3', Text: '^Quarter3^Quarter 3^Quarter3^' },
                            { Function: '$quarter4', Text: '^Quarter4^Quarter 4^Quarter4^' },
                            null,
                            { Function: '$month1', Text: _mn[0] },
                            { Function: '$month2', Text: _mn[1] },
                            { Function: '$month3', Text: _mn[2] },
                            { Function: '$month4', Text: _mn[3] },
                            { Function: '$month5', Text: _mn[4] },
                            { Function: '$month6', Text: _mn[5] },
                            { Function: '$month7', Text: _mn[6] },
                            { Function: '$month8', Text: _mn[7] },
                            { Function: '$month9', Text: _mn[8] },
                            { Function: '$month10', Text: _mn[9] },
                            { Function: '$month11', Text: _mn[10] },
                            { Function: '$month12', Text: _mn[11] }
                        ]
                    }
            ]
        }
    }
}


Web.DataViewResources.Form = {
    ShowActionBar: true,
    ShowCalendarButton: true,
    RequiredFieldMarker: '<span class="Required">*</span>',
    RequiredFiledMarkerFootnote: '* - ^RequiredFiledMarkerFootNote^indicates a required field^RequiredFiledMarkerFootNote^',
    SingleButtonRowFieldLimit: 7,
    GeneralTabText: '^GeneralTabText^General^GeneralTabText^',
    Minimize: '^Minimize^Collapse^Minimize^',
    Maximize: '^Maximize^Expand^Maximize^'
}

Web.DataViewResources.Grid = {
    InPlaceEditContextMenuEnabled: true,
    QuickFindText: '^QuickFindText^Quick Find^QuickFindText^',
    QuickFindToolTip: '^QuickFindToolTip^Type to search the records and press Enter^QuickFindToolTip^',
    ShowAdvancedSearch: '^ShowAdvancedSearch^Show Advanced Search^ShowAdvancedSearch^',
    VisibleSearchBarFields: 3,
    DeleteSearchBarField: '^DeleteSearchBarField^(delete)^DeleteSearchBarField^',
    //AddSearchBarField: '^AddSearchBarField^More Search Fields^AddSearchBarField^',
    HideAdvancedSearch: '^HideAdvancedSearch^Hide Advanced Search^HideAdvancedSearch^',
    PerformAdvancedSearch: '^PerformAdvancedSearch^Search^PerformAdvancedSearch^',
    ResetAdvancedSearch: '^ResetAdvancedSearch^Reset^ResetAdvancedSearch^',
    NewRowLink: '^NewRowLink^Click here to create a new record.^NewRowLink^',
    RootNodeText: '^RootNodeText^Top Level^RootNodeText^',
    FlatTreeToggle: '^FlatTreeToggle^Switch to Hierarchy^FlatTreeToggle^',
    HierarchyTreeModeToggle: '^HierarchyTreeModeToggle^Switch to Flat List^HierarchyTreeModeToggle^',
    AddConditionText: '^AddConditionText^Add search condition^AddConditionText^',
    AddCondition: '^AddCondition^Add Condition^AddCondition^',
    RemoveCondition: '^RemoveCondition^Remove Condition^RemoveCondition^',
    ActionColumnHeaderText: '^ActionBarActionsHeaderText^Actions^ActionBarActionsHeaderText^',
    Aggregates: {
        None: { FmtStr: '', ToolTip: '' },
        Sum: { FmtStr: '^SumAggregate^Sum: {0}^SumAggregate^', ToolTip: '^SumAggregateToolTip^Sum of {0}^SumAggregateToolTip^' },
        Count: { FmtStr: '^CountAggregate^Count: {0}^CountAggregate^', ToolTip: '^CountAggregateToolTip^Count of {0}^CountAggregateToolTip^' },
        Avg: { FmtStr: '^AvgAggregate^Avg: {0}^AvgAggregate^', ToolTip: '^AvgAggregateToolTip^Average of {0}^AvgAggregateToolTip^' },
        Max: { FmtStr: '^MaxAggregate^Max: {0}^MaxAggregate^', ToolTip: '^MaxAggregateToolTip^Maximum of {0}^MaxAggregateToolTip^' },
        Min: { FmtStr: '^MinAggregate^Min: {0}^MinAggregate^', ToolTip: '^MinAggregateToolTip^Minimum of {0}^MinAggregateToolTip^' }
    },
    Freeze: '^Freeze^Freeze^Freeze^',
    Unfreeze: '^Unfreeze^Unfreeze^Unfreeze^'
}

Web.DataViewResources.Views = {
    DefaultDescriptions: {
        '$DefaultGridViewDescription': '^DefaultGridViewDescription^This is a list of {0}.^DefaultGridViewDescription^',
        '$DefaultEditViewDescription': '^DefaultEditViewDescription^Please review {0} information below. Click Edit to change this record, click Delete to delete the record, or click Cancel/Close to return back.^DefaultEditViewDescription^',
        '$DefaultCreateViewDescription': '^DefaultCreateViewDescription^Please fill this form and click OK button to create a new {0} record. Click Cancel to return to the previous screen.^DefaultCreateViewDescription^'
    },
    DefaultCategoryDescriptions: {
        '$DefaultEditDescription': '^DefaultEditDescription^These are the fields of the {0} record that can be edited.^DefaultEditDescription^',
        '$DefaultNewDescription': '^DefaultNewDescription^Complete the form. Make sure to enter all required fields.^DefaultNewDescription^',
        '$DefaultReferenceDescription': '^DefaultReferenceDescription^Additional details about {0} are provided in the reference information section.^DefaultReferenceDescription^'
    }
}

Web.DataViewResources.Actions = {
    Scopes: {
        'Grid': {
            'Select': {
                HeaderText: '^SelectActionHeaderText^Select^SelectActionHeaderText^'
            },
            'Edit': {
                HeaderText: '^EditActionHeaderText^Edit^EditActionHeaderText^'
            },
            'Delete': {
                HeaderText: '^DeleteActionHeaderText^Delete^DeleteActionHeaderText^',
                Confirmation: '^DeleteActionConfirmation^Delete?^DeleteActionConfirmation^'
            },
            'Select': {
                HeaderText: '^SelectActionHeaderText^Select^SelectActionHeaderText^'
            },
            'Duplicate': {
                HeaderText: '^DuplicateActionHeaderText^Duplicate^DuplicateActionHeaderText^'
            },
            'New': {
                HeaderText: '^NewActionHeaderText^New^NewActionHeaderText^'
            },
            'BatchEdit': {
                HeaderText: '^BatchEditActionHeaderText^Batch Edit^BatchEditActionHeaderText^',
                CommandArgument: {
                    'editForm1': {
                        HeaderText: '^BatchEditInFormActionHeaderText^Batch Edit (Form)^BatchEditInFormActionHeaderText^'
                    }
                }
            },
            'Open': {
                HeaderText: '^OpenActionHeaderText^Open^OpenActionHeaderText^'
            }
        },
        'Form': {
            'Edit': {
                HeaderText: '^EditActionHeaderText^Edit^EditActionHeaderText^'
            },
            'Delete': {
                HeaderText: '^DeleteActionHeaderText^Delete^DeleteActionHeaderText^',
                Confirmation: '^DeleteActionConfirmation^Delete?^DeleteActionConfirmation^'
            },
            'Cancel': {
                HeaderText: '^DefaultCancelActionHeaderText^Close^DefaultCancelActionHeaderText^',
                WhenLastCommandName: {
                    'Duplicate': {
                        HeaderText: '^EditModeCancelActionHeaderText^Cancel^EditModeCancelActionHeaderText^'
                    },
                    'Edit': {
                        HeaderText: '^EditModeCancelActionHeaderText^Cancel^EditModeCancelActionHeaderText^'
                    },
                    'New': {
                        HeaderText: '^EditModeCancelActionHeaderText^Cancel^EditModeCancelActionHeaderText^'
                    }

                }
            },
            'Update': {
                HeaderText: '^UpdateActionHeaderText^OK^UpdateActionHeaderText^',
                WhenLastCommandName: {
                    'BatchEdit': {
                        HeaderText: '^UpdateActionInBatchModeHeaderText^Update Selection^UpdateActionInBatchModeHeaderText^',
                        Confirmation: '^UpdateActionInBatchModeConfirmation^Update?^UpdateActionInBatchModeConfirmation^'
                    }
                }
            },
            'Insert': {
                HeaderText: '^InsertActionHeaderText^OK^InsertActionHeaderText^'
            },
            'Confirm': {
                HeaderText: '^UpdateActionHeaderText^OK^UpdateActionHeaderText^'
            }
        },
        'ActionBar': {
            _Self: {
                'Actions': {
                    HeaderText: '^ActionBarActionsHeaderText^Actions^ActionBarActionsHeaderText^'
                },
                'Report': {
                    HeaderText: '^ActionBarReportHeaderText^Report^ActionBarReportHeaderText^'
                },
                'Record': {
                    HeaderText: '^ActionBarRecordHeaderText^Record^ActionBarRecordHeaderText^'
                }
            },
            'New': {
                HeaderText: '^ActionBarNewHeaderText^New {0}^ActionBarNewHeaderText^',
                Description: '^ActionBarNewHeaderDescription^Create a new {0} record.^ActionBarNewHeaderDescription^',
                HeaderText2: '^ActionBarNewHeaderText2^New^ActionBarNewHeaderText2^',
                VarMaxLen: 15
            },
            'Edit': {
                HeaderText: '^EditActionHeaderText^Edit^EditActionHeaderText^'
            },
            'Delete': {
                HeaderText: '^DeleteActionHeaderText^Delete^DeleteActionHeaderText^',
                Confirmation: '^DeleteActionConfirmation^Delete?^DeleteActionConfirmation^'
            },
            'ExportCsv': {
                HeaderText: '^ExportCsvActionHeaderText^Download^ExportCsvActionHeaderText^',
                Description: '^ExportCsvActionDescription^Download items in CSV format.^ExportCsvActionDescription^'
            },
            'ExportRowset': {
                HeaderText: '^ExportRowsetActionHeaderText^Export to Spreadsheet^ExportRowsetActionHeaderText^',
                Description: '^ExportRowsetActionDescription^Analyze items with spreadsheet<br/>application.^ExportRowsetActionDescription^'
            },
            'ExportRss': {
                HeaderText: '^ExportRssActionHeaderText^View RSS Feed^ExportRssActionHeaderText^',
                Description: '^ExportRssActionDescription^Syndicate items with an RSS reader.^ExportRssActionDescription^'
            },
            'Import': {
                HeaderText: '^ImportActionHeaderText^Import From File^ImportActionHeaderText^',
                Description: '^ImportActionDescription^Upload a CSV, XLS, or XLSX file<br/>to import records.^ImportActionDescription^'
            },
            'Update': {
                HeaderText: '^ActionBarUpdateActionHeaderText^Save^ActionBarUpdateActionHeaderText^',
                Description: '^ActionBarUpdateActionDescription^Save changes to the database.^ActionBarUpdateActionDescription^'
            },
            'Insert': {
                HeaderText: '^ActionBarInsertActionHeaderText^Save^ActionBarInsertActionHeaderText^',
                Description: '^ActionBarInsertActionDescription^Save new record to the database.^ActionBarInsertActionDescription^'
            },
            'Cancel': {
                HeaderText: '^ActionBarCancelActionHeaderText^Cancel^ActionBarCancelActionHeaderText^',
                WhenLastCommandName: {
                    'Edit': {
                        HeaderText: '^ActionBarCancelActionHeaderText^Cancel^ActionBarCancelActionHeaderText^',
                        Description: '^ActionBarCancelWhenEditActionDescription^Cancel all record changes.^ActionBarCancelWhenEditActionDescription^'
                    },
                    'New': {
                        HeaderText: '^ActionBarCancelActionHeaderText^Cancel^ActionBarCancelActionHeaderText^',
                        Description: '^ActionBarCancelWhenNewActionDescription^Cancel new record.^ActionBarCancelWhenNewActionDescription^'
                    }
                }
            },
            'Report': {
                HeaderText: '^ReportActionHeaderText^Report^ReportActionHeaderText^',
                Description: '^ReportActionDescription^Render a report in PDF format^ReportActionDescription^'
            },
            'ReportAsPdf': {
                HeaderText: '^ReportAsPdfActionHeaderText^PDF Document^ReportAsPdfActionHeaderText^',
                Description: '^ReportAsPdfActionDescription^View items as Adobe PDF document.<br/>Requires a compatible reader.^ReportAsPdfActionDescription^'
            },
            'ReportAsImage': {
                HeaderText: '^ReportAsImageActionHeaderText^Multipage Image^ReportAsImageActionHeaderText^',
                Description: '^ReportAsImageActionDescription^View items as a multipage TIFF image.^ReportAsImageActionDescription^'
            },
            'ReportAsExcel': {
                HeaderText: '^ReportAsExcelActionHeaderText^Spreadsheet^ReportAsExcelActionHeaderText^',
                Description: '^ReportAsExcelActionDescription^View items in a formatted<br/>Microsoft Excel spreadsheet.^ReportAsExcelActionDescription^'
            },
            'ReportAsWord': {
                HeaderText: '^ReportAsWordActionHeaderText^Microsoft Word^ReportAsWordActionHeaderText^',
                Description: '^ReportAsWordActionDescription^View items in a formatted<br/>Microsoft Word document.^ReportAsWordActionDescription^'
            },
            'DataSheet': {
                HeaderText: '^DataSheetActionHeaderText^Show in Data Sheet^DataSheetActionHeaderText^',
                Description: '^DataSheetActionDescription^Display items using a data sheet<br/>format.^DataSheetActionDescription^'
            },
            'Grid': {
                HeaderText: '^GridActionHeaderText^Show in Standard View^GridActionHeaderText^',
                Description: '^GridActionDescription^Display items in the standard<br/>list format.^GridActionDescription^'
            },
            'Tree': {
                HeaderText: '^TreeActionHeaderText^Show Hierarchy^TreeActionHeaderText^',
                Description: '^TreeActionDescription^Display hierarchical relationships.^TreeActionDescription^'
            },
            'Search': {
                HeaderText: '^PerformAdvancedSearch^Search^PerformAdvancedSearch^',
                Description: '^PerformAdvancedSearch^Search^PerformAdvancedSearch^ {0}'
            }
        },
        'Row': {
            'Update': {
                HeaderText: '^RowUpdateActionHeaderText^Save^RowUpdateActionHeaderText^',
                WhenLastCommandName: {
                    'BatchEdit': {
                        HeaderText: '^RowUpdateWhenBatchEditActionHeaderText^Update Selection^RowUpdateWhenBatchEditActionHeaderText^',
                        Confirmation: '^RowUpdateWhenBatchEditActionConfirmation^Update?^RowUpdateWhenBatchEditActionConfirmation^'
                    }
                }
            },
            'Insert': {
                HeaderText: '^RowInsertActionHeaderText^Insert^RowInsertActionHeaderText^'
            },
            'Cancel': {
                HeaderText: '^RowCancelActionHeaderText^Cancel^RowCancelActionHeaderText^'
            }
        },
        'ActionColumn': {
            'Edit': {
                HeaderText: '^EditActionHeaderText^Edit^EditActionHeaderText^'
            },
            'Delete': {
                HeaderText: '^DeleteActionHeaderText^Delete^DeleteActionHeaderText^',
                Confirmation: '^DeleteActionConfirmation^Delete?^DeleteActionConfirmation^'
            }
        }
    }
}

Web.DataViewResources.Editor = { 
    Undo: '^Undo^Undo^Undo^',
    Redo: '^Redo^Redo^Redo^',
    Bold: '^Bold^Bold^Bold^',
    Italic: '^Italic^Italic^Italic^',
    Underline: '^Underline^Underline^Underline^',
    Strikethrough: '^StrikeThrough^Strike Through^StrikeThrough^',
    Subscript: '^Subscript^Sub Script^Subscript^',
    Superscript: '^Superscript^Super Script^Superscript^',
    JustifyLeft: '^JustifyLeft^Justify Left^JustifyLeft^',
    JustifyCenter: '^JustifyCenter^Justify Center^JustifyCenter^',
    JustifyRight: '^JustifyRight^Justify Right^JustifyRight^',
    JustifyFull: '^JustifyFull^Justify Full^JustifyFull^',
    InsertOrderedList: '^InsertOrderedList^Insert Ordered List^InsertOrderedList^',
    InsertUnorderedList: '^InsertUnorderedList^Insert Unordered List^InsertUnorderedList^',
    CreateLink: '^CreateLink^Create Link^CreateLink^',
    UnLink: '^UnLink^Unlink^UnLink^',
    RemoveFormat: '^RemoveFormat^Remove Format^RemoveFormat^',
    SelectAll: '^SelectAll^Select All^SelectAll^',
    UnSelect: '^UnSelect^UnSelect^UnSelect^',
    Delete: '^Delete^Delete^Delete^',
    Cut: '^Cut^Cut^Cut^',
    Copy: '^Copy^Copy^Copy^',
    Paste: '^Paste^Paste^Paste^',
    BackColor: '^BackColor^Back Color^BackColor^',
    ForeColor: '^ForeColor^Fore Color^ForeColor^',
    FontName: '^FontName^Font Name^FontName^',
    FontSize: '^FontSize^Font Size^FontSize^',
    Indent: '^Indent^Indent^Indent^',
    Outdent: '^Outdent^Outdent^Outdent^',
    InsertHorizontalRule: '^InsertHorizontalRule^Insert Horizontal Rule^InsertHorizontalRule^',
    HorizontalSeparator: '^Separator^Separator^Separator^'
}

Web.DataViewResources.Mobile = {
    UpOneLevel: '^UpOneLevel^Up One Level^UpOneLevel^',
    Back: '^Back^Back^Back^',
    Sort: '^Sort^Sort^Sort^',
    SortByField: '^SortByField^Select a field to change the sort order of <b>{0}</b>.^SortByField^',
    SortByOptions: '^SortByOptions^Select the sort order of <b>{0}</b> by the field <b>{1}</b> in the list of options below.^SortByOptions^',
    DefaultOption: '^DefaultOption^Default^DefaultOption^',
    Filter: '^Filter^Filter^Filter^',
    Dock: '^Dock^Dock^Dock^',
    Undock: '^Undock^Undock^Undock^',
    List: '^List^List^List^',
    Grid: '^Grid^Grid^Grid^',
    AlternativeView: '^AlternativeView^Select an alternative view of data.^AlternativeView^',
    PresentationStyle: '^PresentationStyle^Select a data presentation style.^PresentationStyle^',
    LookupViewAction: '^View^View^View^',
    LookupSelectAction: '^SelectActionHeaderText^Select^SelectActionHeaderText^',
    LookupClearAction: '^FilterLabelClear^Clear^FilterLabelClear^',
    LookupNewAction: '^NewActionHeaderText^New^NewActionHeaderText^',
    LookupInstruction: '^LookupInstruction^Please select <b>{0}</b> in the list. ^LookupInstruction^',
    LookupOriginalSelection: '^LookupOriginalSelection^The original selection is <b>"{0}"</b>. ^LookupOriginalSelection^'
}

if (typeof (Sys) !== 'undefined') Sys.Application.notifyScriptLoaded();
