// Auto-generated types. Do not edit by hand.
package imgui

import "core:c"

ImDrawIdx :: c.ushort
ImGuiID :: c.uint
ImS8 :: c.char
ImU8 :: u8
ImS16 :: c.short
ImU16 :: c.ushort
ImS32 :: c.int
ImU32 :: c.uint
ImS64 :: c.longlong
ImU64 :: c.ulonglong
ImGuiDir :: c.int
ImGuiKey :: c.int
ImGuiMouseSource :: c.int
ImGuiSortDirection :: ImU8
ImGuiCol :: c.int
ImGuiCond :: c.int
ImGuiDataType :: c.int
ImGuiMouseButton :: c.int
ImGuiMouseCursor :: c.int
ImGuiStyleVar :: c.int
ImGuiTableBgTarget :: c.int
ImDrawFlags :: c.int
ImDrawListFlags :: c.int
ImDrawTextFlags :: c.int
ImFontFlags :: c.int
ImFontAtlasFlags :: c.int
ImGuiBackendFlags :: c.int
ImGuiButtonFlags :: c.int
ImGuiChildFlags :: c.int
ImGuiColorEditFlags :: c.int
ImGuiConfigFlags :: c.int
ImGuiComboFlags :: c.int
ImGuiDockNodeFlags :: c.int
ImGuiDragDropFlags :: c.int
ImGuiFocusedFlags :: c.int
ImGuiHoveredFlags :: c.int
ImGuiInputFlags :: c.int
ImGuiInputTextFlags :: c.int
ImGuiItemFlags :: c.int
ImGuiKeyChord :: c.int
ImGuiListClipperFlags :: c.int
ImGuiPopupFlags :: c.int
ImGuiMultiSelectFlags :: c.int
ImGuiSelectableFlags :: c.int
ImGuiSliderFlags :: c.int
ImGuiTabBarFlags :: c.int
ImGuiTabItemFlags :: c.int
ImGuiTableFlags :: c.int
ImGuiTableColumnFlags :: c.int
ImGuiTableRowFlags :: c.int
ImGuiTreeNodeFlags :: c.int
ImGuiViewportFlags :: c.int
ImGuiWindowFlags :: c.int
ImWchar32 :: c.uint
ImWchar16 :: c.ushort
ImWchar :: ImWchar32
ImGuiSelectionUserData :: ImS64
ImGuiInputTextCallback :: proc "c" (data: ^ImGuiInputTextCallbackData) -> c.int
ImGuiSizeCallback :: proc "c" (data: ^ImGuiSizeCallbackData)
ImGuiMemAllocFunc :: proc "c" (sz: c.size_t, user_data: rawptr) -> rawptr
ImGuiMemFreeFunc :: proc "c" (ptr: rawptr, user_data: rawptr)
ImTextureID :: ImU64
ImDrawCallback :: proc "c" (parent_list: ^ImDrawList, cmd: ^ImDrawCmd)
ImFontAtlasRectId :: c.int
ImFontAtlasCustomRect :: ImFontAtlasRect

ImDrawListSharedData :: struct {}
ImFontAtlasBuilder :: struct {}
ImFontLoader :: struct {}
ImGuiContext :: struct {}
ImVec2 :: struct {
	x: f32,
	y: f32,
}
ImVec4 :: struct {
	x: f32,
	y: f32,
	z: f32,
	w: f32,
}
ImTextureRef :: struct {
	_TexData: ^ImTextureData,
	_TexID: ImTextureID,
}
ImGuiTableSortSpecs :: struct {
	Specs: ^ImGuiTableColumnSortSpecs,
	SpecsCount: c.int,
	SpecsDirty: bool,
}
ImGuiTableColumnSortSpecs :: struct {
	ColumnUserID: ImGuiID,
	ColumnIndex: ImS16,
	SortOrder: ImS16,
	SortDirection: ImGuiSortDirection,
}
ImVector_ImGuiTextRange :: struct {
	Size: c.int,
	Capacity: c.int,
	Data: ^ImGuiTextFilter_ImGuiTextRange,
}
ImVector_char :: struct {
	Size: c.int,
	Capacity: c.int,
	Data: [^]c.char,
}
ImVector_ImGuiStoragePair :: struct {
	Size: c.int,
	Capacity: c.int,
	Data: ^ImGuiStoragePair,
}
ImVector_ImGuiSelectionRequest :: struct {
	Size: c.int,
	Capacity: c.int,
	Data: ^ImGuiSelectionRequest,
}
ImVector_ImDrawChannel :: struct {
	Size: c.int,
	Capacity: c.int,
	Data: ^ImDrawChannel,
}
ImVector_ImDrawCmd :: struct {
	Size: c.int,
	Capacity: c.int,
	Data: ^ImDrawCmd,
}
ImVector_ImDrawIdx :: struct {
	Size: c.int,
	Capacity: c.int,
	Data: ^ImDrawIdx,
}
ImVector_ImDrawVert :: struct {
	Size: c.int,
	Capacity: c.int,
	Data: ^ImDrawVert,
}
ImVector_ImVec2 :: struct {
	Size: c.int,
	Capacity: c.int,
	Data: ^ImVec2,
}
ImVector_ImVec4 :: struct {
	Size: c.int,
	Capacity: c.int,
	Data: ^ImVec4,
}
ImVector_ImTextureRef :: struct {
	Size: c.int,
	Capacity: c.int,
	Data: ^ImTextureRef,
}
ImVector_ImU8 :: struct {
	Size: c.int,
	Capacity: c.int,
	Data: ^ImU8,
}
ImVector_ImDrawListPtr :: struct {
	Size: c.int,
	Capacity: c.int,
	Data: ^^ImDrawList,
}
ImVector_ImTextureRect :: struct {
	Size: c.int,
	Capacity: c.int,
	Data: ^ImTextureRect,
}
ImVector_ImU32 :: struct {
	Size: c.int,
	Capacity: c.int,
	Data: ^ImU32,
}
ImVector_ImWchar :: struct {
	Size: c.int,
	Capacity: c.int,
	Data: ^ImWchar,
}
ImVector_ImFontPtr :: struct {
	Size: c.int,
	Capacity: c.int,
	Data: ^^ImFont,
}
ImVector_ImFontConfig :: struct {
	Size: c.int,
	Capacity: c.int,
	Data: ^ImFontConfig,
}
ImVector_ImDrawListSharedDataPtr :: struct {
	Size: c.int,
	Capacity: c.int,
	Data: ^^ImDrawListSharedData,
}
ImVector_float :: struct {
	Size: c.int,
	Capacity: c.int,
	Data: ^f32,
}
ImVector_ImU16 :: struct {
	Size: c.int,
	Capacity: c.int,
	Data: ^ImU16,
}
ImVector_ImFontGlyph :: struct {
	Size: c.int,
	Capacity: c.int,
	Data: ^ImFontGlyph,
}
ImVector_ImFontConfigPtr :: struct {
	Size: c.int,
	Capacity: c.int,
	Data: ^^ImFontConfig,
}
ImVector_ImGuiPlatformMonitor :: struct {
	Size: c.int,
	Capacity: c.int,
	Data: ^ImGuiPlatformMonitor,
}
ImVector_ImTextureDataPtr :: struct {
	Size: c.int,
	Capacity: c.int,
	Data: ^^ImTextureData,
}
ImVector_ImGuiViewportPtr :: struct {
	Size: c.int,
	Capacity: c.int,
	Data: ^^ImGuiViewport,
}
ImGuiStyle :: struct {
	FontSizeBase: f32,
	FontScaleMain: f32,
	FontScaleDpi: f32,
	Alpha: f32,
	DisabledAlpha: f32,
	WindowPadding: ImVec2,
	WindowRounding: f32,
	WindowBorderSize: f32,
	WindowBorderHoverPadding: f32,
	WindowMinSize: ImVec2,
	WindowTitleAlign: ImVec2,
	WindowMenuButtonPosition: ImGuiDir,
	ChildRounding: f32,
	ChildBorderSize: f32,
	PopupRounding: f32,
	PopupBorderSize: f32,
	FramePadding: ImVec2,
	FrameRounding: f32,
	FrameBorderSize: f32,
	ItemSpacing: ImVec2,
	ItemInnerSpacing: ImVec2,
	CellPadding: ImVec2,
	TouchExtraPadding: ImVec2,
	IndentSpacing: f32,
	ColumnsMinSpacing: f32,
	ScrollbarSize: f32,
	ScrollbarRounding: f32,
	ScrollbarPadding: f32,
	GrabMinSize: f32,
	GrabRounding: f32,
	LogSliderDeadzone: f32,
	ImageRounding: f32,
	ImageBorderSize: f32,
	TabRounding: f32,
	TabBorderSize: f32,
	TabMinWidthBase: f32,
	TabMinWidthShrink: f32,
	TabCloseButtonMinWidthSelected: f32,
	TabCloseButtonMinWidthUnselected: f32,
	TabBarBorderSize: f32,
	TabBarOverlineSize: f32,
	TableAngledHeadersAngle: f32,
	TableAngledHeadersTextAlign: ImVec2,
	TreeLinesFlags: ImGuiTreeNodeFlags,
	TreeLinesSize: f32,
	TreeLinesRounding: f32,
	DragDropTargetRounding: f32,
	DragDropTargetBorderSize: f32,
	DragDropTargetPadding: f32,
	ColorMarkerSize: f32,
	ColorButtonPosition: ImGuiDir,
	ButtonTextAlign: ImVec2,
	SelectableTextAlign: ImVec2,
	SeparatorSize: f32,
	SeparatorTextBorderSize: f32,
	SeparatorTextAlign: ImVec2,
	SeparatorTextPadding: ImVec2,
	DisplayWindowPadding: ImVec2,
	DisplaySafeAreaPadding: ImVec2,
	DockingNodeHasCloseButton: bool,
	DockingSeparatorSize: f32,
	MouseCursorScale: f32,
	AntiAliasedLines: bool,
	AntiAliasedLinesUseTex: bool,
	AntiAliasedFill: bool,
	CurveTessellationTol: f32,
	CircleTessellationMaxError: f32,
	Colors: [ImGuiCol_COUNT]ImVec4,
	HoverStationaryDelay: f32,
	HoverDelayShort: f32,
	HoverDelayNormal: f32,
	HoverFlagsForTooltipMouse: ImGuiHoveredFlags,
	HoverFlagsForTooltipNav: ImGuiHoveredFlags,
	_MainScale: f32,
	_NextFrameFontSizeBase: f32,
}
ImGuiKeyData :: struct {
	Down: bool,
	DownDuration: f32,
	DownDurationPrev: f32,
	AnalogValue: f32,
}
ImGuiIO :: struct {
	ConfigFlags: ImGuiConfigFlags,
	BackendFlags: ImGuiBackendFlags,
	DisplaySize: ImVec2,
	DisplayFramebufferScale: ImVec2,
	DeltaTime: f32,
	IniSavingRate: f32,
	IniFilename: cstring,
	LogFilename: cstring,
	UserData: rawptr,
	Fonts: ^ImFontAtlas,
	FontDefault: ^ImFont,
	FontAllowUserScaling: bool,
	ConfigNavSwapGamepadButtons: bool,
	ConfigNavMoveSetMousePos: bool,
	ConfigNavCaptureKeyboard: bool,
	ConfigNavEscapeClearFocusItem: bool,
	ConfigNavEscapeClearFocusWindow: bool,
	ConfigNavCursorVisibleAuto: bool,
	ConfigNavCursorVisibleAlways: bool,
	ConfigDockingNoSplit: bool,
	ConfigDockingNoDockingOver: bool,
	ConfigDockingWithShift: bool,
	ConfigDockingAlwaysTabBar: bool,
	ConfigDockingTransparentPayload: bool,
	ConfigViewportsNoAutoMerge: bool,
	ConfigViewportsNoTaskBarIcon: bool,
	ConfigViewportsNoDecoration: bool,
	ConfigViewportsNoDefaultParent: bool,
	ConfigViewportsPlatformFocusSetsImGuiFocus: bool,
	ConfigDpiScaleFonts: bool,
	ConfigDpiScaleViewports: bool,
	MouseDrawCursor: bool,
	ConfigMacOSXBehaviors: bool,
	ConfigInputTrickleEventQueue: bool,
	ConfigInputTextCursorBlink: bool,
	ConfigInputTextEnterKeepActive: bool,
	ConfigDragClickToInputText: bool,
	ConfigWindowsResizeFromEdges: bool,
	ConfigWindowsMoveFromTitleBarOnly: bool,
	ConfigWindowsCopyContentsWithCtrlC: bool,
	ConfigScrollbarScrollByPage: bool,
	ConfigMemoryCompactTimer: f32,
	MouseDoubleClickTime: f32,
	MouseDoubleClickMaxDist: f32,
	MouseDragThreshold: f32,
	KeyRepeatDelay: f32,
	KeyRepeatRate: f32,
	ConfigErrorRecovery: bool,
	ConfigErrorRecoveryEnableAssert: bool,
	ConfigErrorRecoveryEnableDebugLog: bool,
	ConfigErrorRecoveryEnableTooltip: bool,
	ConfigDebugIsDebuggerPresent: bool,
	ConfigDebugHighlightIdConflicts: bool,
	ConfigDebugHighlightIdConflictsShowItemPicker: bool,
	ConfigDebugBeginReturnValueOnce: bool,
	ConfigDebugBeginReturnValueLoop: bool,
	ConfigDebugIgnoreFocusLoss: bool,
	ConfigDebugIniSettings: bool,
	BackendPlatformName: cstring,
	BackendRendererName: cstring,
	BackendPlatformUserData: rawptr,
	BackendRendererUserData: rawptr,
	BackendLanguageUserData: rawptr,
	WantCaptureMouse: bool,
	WantCaptureKeyboard: bool,
	WantTextInput: bool,
	WantSetMousePos: bool,
	WantSaveIniSettings: bool,
	NavActive: bool,
	NavVisible: bool,
	Framerate: f32,
	MetricsRenderVertices: c.int,
	MetricsRenderIndices: c.int,
	MetricsRenderWindows: c.int,
	MetricsActiveWindows: c.int,
	MouseDelta: ImVec2,
	Ctx: ^ImGuiContext,
	MousePos: ImVec2,
	MouseDown: [5]bool,
	MouseWheel: f32,
	MouseWheelH: f32,
	MouseSource: ImGuiMouseSource,
	MouseHoveredViewport: ImGuiID,
	KeyCtrl: bool,
	KeyShift: bool,
	KeyAlt: bool,
	KeySuper: bool,
	KeyMods: ImGuiKeyChord,
	KeysData: [ImGuiKey_NamedKey_COUNT]ImGuiKeyData,
	WantCaptureMouseUnlessPopupClose: bool,
	MousePosPrev: ImVec2,
	MouseClickedPos: [5]ImVec2,
	MouseClickedTime: [5]f64,
	MouseClicked: [5]bool,
	MouseDoubleClicked: [5]bool,
	MouseClickedCount: [5]ImU16,
	MouseClickedLastCount: [5]ImU16,
	MouseReleased: [5]bool,
	MouseReleasedTime: [5]f64,
	MouseDownOwned: [5]bool,
	MouseDownOwnedUnlessPopupClose: [5]bool,
	MouseWheelRequestAxisSwap: bool,
	MouseCtrlLeftAsRightClick: bool,
	MouseDownDuration: [5]f32,
	MouseDownDurationPrev: [5]f32,
	MouseDragMaxDistanceAbs: [5]ImVec2,
	MouseDragMaxDistanceSqr: [5]f32,
	PenPressure: f32,
	AppFocusLost: bool,
	AppAcceptingEvents: bool,
	InputQueueSurrogate: ImWchar16,
	InputQueueCharacters: ImVector_ImWchar,
	FontGlobalScale: f32,
	GetClipboardTextFn: proc "c" (user_data: rawptr) -> cstring,
	SetClipboardTextFn: proc "c" (user_data: rawptr, text: cstring),
	ClipboardUserData: rawptr,
}
ImGuiInputTextCallbackData :: struct {
	Ctx: ^ImGuiContext,
	EventFlag: ImGuiInputTextFlags,
	Flags: ImGuiInputTextFlags,
	UserData: rawptr,
	ID: ImGuiID,
	EventKey: ImGuiKey,
	EventChar: ImWchar,
	EventActivated: bool,
	BufDirty: bool,
	Buf: [^]c.char,
	BufTextLen: c.int,
	BufSize: c.int,
	CursorPos: c.int,
	SelectionStart: c.int,
	SelectionEnd: c.int,
}
ImGuiSizeCallbackData :: struct {
	UserData: rawptr,
	Pos: ImVec2,
	CurrentSize: ImVec2,
	DesiredSize: ImVec2,
}
ImGuiWindowClass :: struct {
	ClassId: ImGuiID,
	ParentViewportId: ImGuiID,
	FocusRouteParentWindowId: ImGuiID,
	ViewportFlagsOverrideSet: ImGuiViewportFlags,
	ViewportFlagsOverrideClear: ImGuiViewportFlags,
	TabItemFlagsOverrideSet: ImGuiTabItemFlags,
	DockNodeFlagsOverrideSet: ImGuiDockNodeFlags,
	DockingAlwaysTabBar: bool,
	DockingAllowUnclassed: bool,
	PlatformIconData: rawptr,
}
ImGuiPayload :: struct {
	Data: rawptr,
	DataSize: c.int,
	SourceId: ImGuiID,
	SourceParentId: ImGuiID,
	DataFrameCount: c.int,
	DataType: [32+1]c.char,
	Preview: bool,
	Delivery: bool,
}
ImGuiTextFilter_ImGuiTextRange :: struct {
	b: cstring,
	e: cstring,
}
ImGuiTextFilter :: struct {
	InputBuf: [256]c.char,
	Filters: ImVector_ImGuiTextRange,
	CountGrep: c.int,
}
ImGuiTextBuffer :: struct {
	Buf: ImVector_char,
}
ImGuiStoragePair :: struct {
	key: ImGuiID,
	__anonymous_type0: __anonymous_type0,
}
__anonymous_type0 :: struct {
	val_i: c.int,
	val_f: f32,
	val_p: rawptr,
}
ImGuiStorage :: struct {
	Data: ImVector_ImGuiStoragePair,
}
ImGuiListClipper :: struct {
	DisplayStart: c.int,
	DisplayEnd: c.int,
	UserIndex: c.int,
	ItemsCount: c.int,
	ItemsHeight: f32,
	Flags: ImGuiListClipperFlags,
	StartPosY: f64,
	StartSeekOffsetY: f64,
	Ctx: ^ImGuiContext,
	TempData: rawptr,
}
ImColor :: struct {
	Value: ImVec4,
}
ImGuiMultiSelectIO :: struct {
	Requests: ImVector_ImGuiSelectionRequest,
	RangeSrcItem: ImGuiSelectionUserData,
	NavIdItem: ImGuiSelectionUserData,
	NavIdSelected: bool,
	RangeSrcReset: bool,
	ItemsCount: c.int,
}
ImGuiSelectionRequest :: struct {
	Type: ImGuiSelectionRequestType,
	Selected: bool,
	RangeDirection: ImS8,
	RangeFirstItem: ImGuiSelectionUserData,
	RangeLastItem: ImGuiSelectionUserData,
}
ImGuiSelectionBasicStorage :: struct {
	Size: c.int,
	PreserveOrder: bool,
	UserData: rawptr,
	AdapterIndexToStorageId: proc "c" (self: ^ImGuiSelectionBasicStorage, idx: c.int) -> ImGuiID,
	_SelectionOrder: c.int,
	_Storage: ImGuiStorage,
}
ImGuiSelectionExternalStorage :: struct {
	UserData: rawptr,
	AdapterSetItemSelected: proc "c" (self: ^ImGuiSelectionExternalStorage, idx: c.int, selected: bool),
}
ImDrawCmd :: struct {
	ClipRect: ImVec4,
	TexRef: ImTextureRef,
	VtxOffset: c.uint,
	IdxOffset: c.uint,
	ElemCount: c.uint,
	UserCallback: ImDrawCallback,
	UserCallbackData: rawptr,
	UserCallbackDataSize: c.int,
	UserCallbackDataOffset: c.int,
}
ImDrawVert :: struct {
	pos: ImVec2,
	uv: ImVec2,
	col: ImU32,
}
ImDrawCmdHeader :: struct {
	ClipRect: ImVec4,
	TexRef: ImTextureRef,
	VtxOffset: c.uint,
}
ImDrawChannel :: struct {
	_CmdBuffer: ImVector_ImDrawCmd,
	_IdxBuffer: ImVector_ImDrawIdx,
}
ImDrawListSplitter :: struct {
	_Current: c.int,
	_Count: c.int,
	_Channels: ImVector_ImDrawChannel,
}
ImDrawList :: struct {
	CmdBuffer: ImVector_ImDrawCmd,
	IdxBuffer: ImVector_ImDrawIdx,
	VtxBuffer: ImVector_ImDrawVert,
	Flags: ImDrawListFlags,
	_VtxCurrentIdx: c.uint,
	_Data: ^ImDrawListSharedData,
	_VtxWritePtr: ^ImDrawVert,
	_IdxWritePtr: ^ImDrawIdx,
	_Path: ImVector_ImVec2,
	_CmdHeader: ImDrawCmdHeader,
	_Splitter: ImDrawListSplitter,
	_ClipRectStack: ImVector_ImVec4,
	_TextureStack: ImVector_ImTextureRef,
	_CallbacksDataBuf: ImVector_ImU8,
	_FringeScale: f32,
	_OwnerName: cstring,
}
ImDrawData :: struct {
	Valid: bool,
	CmdListsCount: c.int,
	TotalIdxCount: c.int,
	TotalVtxCount: c.int,
	CmdLists: ImVector_ImDrawListPtr,
	DisplayPos: ImVec2,
	DisplaySize: ImVec2,
	FramebufferScale: ImVec2,
	OwnerViewport: ^ImGuiViewport,
	Textures: ^ImVector_ImTextureDataPtr,
}
ImTextureRect :: struct {
	x: c.ushort,
	y: c.ushort,
	w: c.ushort,
	h: c.ushort,
}
ImTextureData :: struct {
	UniqueID: c.int,
	Status: ImTextureStatus,
	BackendUserData: rawptr,
	TexID: ImTextureID,
	Format: ImTextureFormat,
	Width: c.int,
	Height: c.int,
	BytesPerPixel: c.int,
	Pixels: ^u8,
	UsedRect: ImTextureRect,
	UpdateRect: ImTextureRect,
	Updates: ImVector_ImTextureRect,
	UnusedFrames: c.int,
	RefCount: c.ushort,
	UseColors: bool,
	WantDestroyNextFrame: bool,
}
ImFontConfig :: struct {
	Name: [40]c.char,
	FontData: rawptr,
	FontDataSize: c.int,
	FontDataOwnedByAtlas: bool,
	MergeMode: bool,
	PixelSnapH: bool,
	OversampleH: ImS8,
	OversampleV: ImS8,
	EllipsisChar: ImWchar,
	SizePixels: f32,
	GlyphRanges: ^ImWchar,
	GlyphExcludeRanges: ^ImWchar,
	GlyphOffset: ImVec2,
	GlyphMinAdvanceX: f32,
	GlyphMaxAdvanceX: f32,
	GlyphExtraAdvanceX: f32,
	FontNo: ImU32,
	FontLoaderFlags: c.uint,
	RasterizerMultiply: f32,
	RasterizerDensity: f32,
	ExtraSizeScale: f32,
	Flags: ImFontFlags,
	DstFont: ^ImFont,
	FontLoader: ^ImFontLoader,
	FontLoaderData: rawptr,
	PixelSnapV: bool,
}
ImFontGlyph :: struct {
	Colored: c.uint,
	Visible: c.uint,
	SourceIdx: c.uint,
	Codepoint: c.uint,
	AdvanceX: f32,
	X0: f32,
	Y0: f32,
	X1: f32,
	Y1: f32,
	U0: f32,
	V0: f32,
	U1: f32,
	V1: f32,
	PackId: c.int,
}
ImFontGlyphRangesBuilder :: struct {
	UsedChars: ImVector_ImU32,
}
ImFontAtlasRect :: struct {
	x: c.ushort,
	y: c.ushort,
	w: c.ushort,
	h: c.ushort,
	uv0: ImVec2,
	uv1: ImVec2,
}
ImFontAtlas :: struct {
	Flags: ImFontAtlasFlags,
	TexDesiredFormat: ImTextureFormat,
	TexGlyphPadding: c.int,
	TexMinWidth: c.int,
	TexMinHeight: c.int,
	TexMaxWidth: c.int,
	TexMaxHeight: c.int,
	UserData: rawptr,
	TexRef: ImTextureRef,
	__anonymous_type1: __anonymous_type1,
	TexData: ^ImTextureData,
	TexList: ImVector_ImTextureDataPtr,
	Locked: bool,
	RendererHasTextures: bool,
	TexIsBuilt: bool,
	TexPixelsUseColors: bool,
	TexUvScale: ImVec2,
	TexUvWhitePixel: ImVec2,
	Fonts: ImVector_ImFontPtr,
	Sources: ImVector_ImFontConfig,
	TexUvLines: [IM_DRAWLIST_TEX_LINES_WIDTH_MAX+1]ImVec4,
	TexNextUniqueID: c.int,
	FontNextUniqueID: c.int,
	DrawListSharedDatas: ImVector_ImDrawListSharedDataPtr,
	Builder: ^ImFontAtlasBuilder,
	FontLoader: ^ImFontLoader,
	FontLoaderName: cstring,
	FontLoaderData: rawptr,
	FontLoaderFlags: c.uint,
	RefCount: c.int,
	OwnerContext: ^ImGuiContext,
	TempRect: ImFontAtlasRect,
}
__anonymous_type1 :: struct {
	TexRef: ImTextureRef,
	TexID: ImTextureRef,
}
ImFontBaked :: struct {
	IndexAdvanceX: ImVector_float,
	FallbackAdvanceX: f32,
	Size: f32,
	RasterizerDensity: f32,
	IndexLookup: ImVector_ImU16,
	Glyphs: ImVector_ImFontGlyph,
	FallbackGlyphIndex: c.int,
	Ascent: f32,
	Descent: f32,
	MetricsTotalSurface: c.uint,
	WantDestroy: c.uint,
	LoadNoFallback: c.uint,
	LoadNoRenderOnLayout: c.uint,
	LastUsedFrame: c.int,
	BakedId: ImGuiID,
	OwnerFont: ^ImFont,
	FontLoaderDatas: rawptr,
}
ImFont :: struct {
	LastBaked: ^ImFontBaked,
	OwnerAtlas: ^ImFontAtlas,
	Flags: ImFontFlags,
	CurrentRasterizerDensity: f32,
	FontId: ImGuiID,
	LegacySize: f32,
	Sources: ImVector_ImFontConfigPtr,
	EllipsisChar: ImWchar,
	FallbackChar: ImWchar,
	Used8kPagesMap: [(IM_UNICODE_CODEPOINT_MAX +1)/8192/8]ImU8,
	EllipsisAutoBake: bool,
	RemapPairs: ImGuiStorage,
	Scale: f32,
}
ImGuiViewport :: struct {
	ID: ImGuiID,
	Flags: ImGuiViewportFlags,
	Pos: ImVec2,
	Size: ImVec2,
	FramebufferScale: ImVec2,
	WorkPos: ImVec2,
	WorkSize: ImVec2,
	DpiScale: f32,
	ParentViewportId: ImGuiID,
	ParentViewport: ^ImGuiViewport,
	DrawData: ^ImDrawData,
	RendererUserData: rawptr,
	PlatformUserData: rawptr,
	PlatformIconData: rawptr,
	PlatformHandle: rawptr,
	PlatformHandleRaw: rawptr,
	PlatformWindowCreated: bool,
	PlatformRequestMove: bool,
	PlatformRequestResize: bool,
	PlatformRequestClose: bool,
}
ImGuiPlatformIO :: struct {
	Platform_GetClipboardTextFn: proc "c" (ctx: ^ImGuiContext) -> cstring,
	Platform_SetClipboardTextFn: proc "c" (ctx: ^ImGuiContext, text: cstring),
	Platform_ClipboardUserData: rawptr,
	Platform_OpenInShellFn: proc "c" (ctx: ^ImGuiContext, path: cstring) -> bool,
	Platform_OpenInShellUserData: rawptr,
	Platform_SetImeDataFn: proc "c" (ctx: ^ImGuiContext, viewport: ^ImGuiViewport, data: ^ImGuiPlatformImeData),
	Platform_ImeUserData: rawptr,
	Platform_LocaleDecimalPoint: ImWchar,
	Renderer_TextureMaxWidth: c.int,
	Renderer_TextureMaxHeight: c.int,
	Renderer_RenderState: rawptr,
	DrawCallback_ResetRenderState: ImDrawCallback,
	DrawCallback_SetSamplerLinear: ImDrawCallback,
	DrawCallback_SetSamplerNearest: ImDrawCallback,
	Platform_CreateWindow: proc "c" (vp: ^ImGuiViewport),
	Platform_DestroyWindow: proc "c" (vp: ^ImGuiViewport),
	Platform_ShowWindow: proc "c" (vp: ^ImGuiViewport),
	Platform_SetWindowPos: proc "c" (vp: ^ImGuiViewport, pos: ImVec2),
	Platform_GetWindowPos: proc "c" (vp: ^ImGuiViewport) -> ImVec2,
	Platform_SetWindowSize: proc "c" (vp: ^ImGuiViewport, size: ImVec2),
	Platform_GetWindowSize: proc "c" (vp: ^ImGuiViewport) -> ImVec2,
	Platform_GetWindowFramebufferScale: proc "c" (vp: ^ImGuiViewport) -> ImVec2,
	Platform_SetWindowFocus: proc "c" (vp: ^ImGuiViewport),
	Platform_GetWindowFocus: proc "c" (vp: ^ImGuiViewport) -> bool,
	Platform_GetWindowMinimized: proc "c" (vp: ^ImGuiViewport) -> bool,
	Platform_SetWindowTitle: proc "c" (vp: ^ImGuiViewport, str: cstring),
	Platform_SetWindowAlpha: proc "c" (vp: ^ImGuiViewport, alpha: f32),
	Platform_UpdateWindow: proc "c" (vp: ^ImGuiViewport),
	Platform_RenderWindow: proc "c" (vp: ^ImGuiViewport, render_arg: rawptr),
	Platform_SwapBuffers: proc "c" (vp: ^ImGuiViewport, render_arg: rawptr),
	Platform_GetWindowDpiScale: proc "c" (vp: ^ImGuiViewport) -> f32,
	Platform_OnChangedViewport: proc "c" (vp: ^ImGuiViewport),
	Platform_GetWindowWorkAreaInsets: proc "c" (vp: ^ImGuiViewport) -> ImVec4,
	Platform_CreateVkSurface: proc "c" (vp: ^ImGuiViewport, vk_inst: ImU64, vk_allocators: rawptr, out_vk_surface: ^ImU64) -> c.int,
	Renderer_CreateWindow: proc "c" (vp: ^ImGuiViewport),
	Renderer_DestroyWindow: proc "c" (vp: ^ImGuiViewport),
	Renderer_SetWindowSize: proc "c" (vp: ^ImGuiViewport, size: ImVec2),
	Renderer_RenderWindow: proc "c" (vp: ^ImGuiViewport, render_arg: rawptr),
	Renderer_SwapBuffers: proc "c" (vp: ^ImGuiViewport, render_arg: rawptr),
	Monitors: ImVector_ImGuiPlatformMonitor,
	Textures: ImVector_ImTextureDataPtr,
	Viewports: ImVector_ImGuiViewportPtr,
}
ImGuiPlatformMonitor :: struct {
	MainPos: ImVec2,
	MainSize: ImVec2,
	WorkPos: ImVec2,
	WorkSize: ImVec2,
	DpiScale: f32,
	PlatformHandle: rawptr,
}
ImGuiPlatformImeData :: struct {
	WantVisible: bool,
	WantTextInput: bool,
	InputPos: ImVec2,
	InputLineHeight: f32,
	ViewportId: ImGuiID,
}

Color :: ImColor
DrawCallback :: ImDrawCallback
DrawChannel :: ImDrawChannel
DrawCmd :: ImDrawCmd
DrawCmdHeader :: ImDrawCmdHeader
DrawData :: ImDrawData
DrawFlags :: ImDrawFlags
DrawIdx :: ImDrawIdx
DrawList :: ImDrawList
DrawListFlags :: ImDrawListFlags
DrawListSharedData :: ImDrawListSharedData
DrawListSplitter :: ImDrawListSplitter
DrawTextFlags :: ImDrawTextFlags
DrawVert :: ImDrawVert
Font :: ImFont
FontAtlas :: ImFontAtlas
FontAtlasBuilder :: ImFontAtlasBuilder
FontAtlasCustomRect :: ImFontAtlasCustomRect
FontAtlasFlags :: ImFontAtlasFlags
FontAtlasRect :: ImFontAtlasRect
FontAtlasRectId :: ImFontAtlasRectId
FontBaked :: ImFontBaked
FontConfig :: ImFontConfig
FontFlags :: ImFontFlags
FontGlyph :: ImFontGlyph
FontGlyphRangesBuilder :: ImFontGlyphRangesBuilder
FontLoader :: ImFontLoader
BackendFlags :: ImGuiBackendFlags
ButtonFlags :: ImGuiButtonFlags
ChildFlags :: ImGuiChildFlags
Col :: ImGuiCol
ColorEditFlags :: ImGuiColorEditFlags
ComboFlags :: ImGuiComboFlags
Cond :: ImGuiCond
ConfigFlags :: ImGuiConfigFlags
Context :: ImGuiContext
DataType :: ImGuiDataType
Dir :: ImGuiDir
DockNodeFlags :: ImGuiDockNodeFlags
DragDropFlags :: ImGuiDragDropFlags
FocusedFlags :: ImGuiFocusedFlags
HoveredFlags :: ImGuiHoveredFlags
ID :: ImGuiID
IO :: ImGuiIO
InputFlags :: ImGuiInputFlags
InputTextCallback :: ImGuiInputTextCallback
InputTextCallbackData :: ImGuiInputTextCallbackData
InputTextFlags :: ImGuiInputTextFlags
ItemFlags :: ImGuiItemFlags
Key :: ImGuiKey
KeyChord :: ImGuiKeyChord
KeyData :: ImGuiKeyData
ListClipper :: ImGuiListClipper
ListClipperFlags :: ImGuiListClipperFlags
MemAllocFunc :: ImGuiMemAllocFunc
MemFreeFunc :: ImGuiMemFreeFunc
MouseButton :: ImGuiMouseButton
MouseCursor :: ImGuiMouseCursor
MouseSource :: ImGuiMouseSource
MultiSelectFlags :: ImGuiMultiSelectFlags
MultiSelectIO :: ImGuiMultiSelectIO
Payload :: ImGuiPayload
PlatformIO :: ImGuiPlatformIO
PlatformImeData :: ImGuiPlatformImeData
PlatformMonitor :: ImGuiPlatformMonitor
PopupFlags :: ImGuiPopupFlags
SelectableFlags :: ImGuiSelectableFlags
SelectionBasicStorage :: ImGuiSelectionBasicStorage
SelectionExternalStorage :: ImGuiSelectionExternalStorage
SelectionRequest :: ImGuiSelectionRequest
SelectionUserData :: ImGuiSelectionUserData
SizeCallback :: ImGuiSizeCallback
SizeCallbackData :: ImGuiSizeCallbackData
SliderFlags :: ImGuiSliderFlags
SortDirection :: ImGuiSortDirection
Storage :: ImGuiStorage
StoragePair :: ImGuiStoragePair
Style :: ImGuiStyle
StyleVar :: ImGuiStyleVar
TabBarFlags :: ImGuiTabBarFlags
TabItemFlags :: ImGuiTabItemFlags
TableBgTarget :: ImGuiTableBgTarget
TableColumnFlags :: ImGuiTableColumnFlags
TableColumnSortSpecs :: ImGuiTableColumnSortSpecs
TableFlags :: ImGuiTableFlags
TableRowFlags :: ImGuiTableRowFlags
TableSortSpecs :: ImGuiTableSortSpecs
TextBuffer :: ImGuiTextBuffer
TextFilter :: ImGuiTextFilter
TextFilter_ImGuiTextRange :: ImGuiTextFilter_ImGuiTextRange
TreeNodeFlags :: ImGuiTreeNodeFlags
Viewport :: ImGuiViewport
ViewportFlags :: ImGuiViewportFlags
WindowClass :: ImGuiWindowClass
WindowFlags :: ImGuiWindowFlags
S16 :: ImS16
S32 :: ImS32
S64 :: ImS64
S8 :: ImS8
TextureData :: ImTextureData
TextureID :: ImTextureID
TextureRect :: ImTextureRect
TextureRef :: ImTextureRef
U16 :: ImU16
U32 :: ImU32
U64 :: ImU64
U8 :: ImU8
Vec2 :: ImVec2
Vec4 :: ImVec4
Vector_ImDrawChannel :: ImVector_ImDrawChannel
Vector_ImDrawCmd :: ImVector_ImDrawCmd
Vector_ImDrawIdx :: ImVector_ImDrawIdx
Vector_ImDrawListPtr :: ImVector_ImDrawListPtr
Vector_ImDrawListSharedDataPtr :: ImVector_ImDrawListSharedDataPtr
Vector_ImDrawVert :: ImVector_ImDrawVert
Vector_ImFontConfig :: ImVector_ImFontConfig
Vector_ImFontConfigPtr :: ImVector_ImFontConfigPtr
Vector_ImFontGlyph :: ImVector_ImFontGlyph
Vector_ImFontPtr :: ImVector_ImFontPtr
Vector_ImGuiPlatformMonitor :: ImVector_ImGuiPlatformMonitor
Vector_ImGuiSelectionRequest :: ImVector_ImGuiSelectionRequest
Vector_ImGuiStoragePair :: ImVector_ImGuiStoragePair
Vector_ImGuiTextRange :: ImVector_ImGuiTextRange
Vector_ImGuiViewportPtr :: ImVector_ImGuiViewportPtr
Vector_ImTextureDataPtr :: ImVector_ImTextureDataPtr
Vector_ImTextureRect :: ImVector_ImTextureRect
Vector_ImTextureRef :: ImVector_ImTextureRef
Vector_ImU16 :: ImVector_ImU16
Vector_ImU32 :: ImVector_ImU32
Vector_ImU8 :: ImVector_ImU8
Vector_ImVec2 :: ImVector_ImVec2
Vector_ImVec4 :: ImVector_ImVec4
Vector_ImWchar :: ImVector_ImWchar
Vector_char :: ImVector_char
Vector_float :: ImVector_float
Wchar :: ImWchar
Wchar16 :: ImWchar16
Wchar32 :: ImWchar32
