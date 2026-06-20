// Auto-generated raw ABI. Do not edit by hand.
package imgui

import "core:c"

when ODIN_OS == .Windows {
	IMGUI_ODIN_LIB_DCIMGUI_CORE :: #config(IMGUI_ODIN_LIB_DCIMGUI_CORE, "lib/windows_amd64/dcimgui_core.lib")
	foreign import dcimgui_core { IMGUI_ODIN_LIB_DCIMGUI_CORE }
} else when ODIN_OS == .Darwin {
	IMGUI_ODIN_LIB_DCIMGUI_CORE :: #config(IMGUI_ODIN_LIB_DCIMGUI_CORE, "lib/darwin_amd64/libdcimgui_core.a")
	foreign import dcimgui_core { IMGUI_ODIN_LIB_DCIMGUI_CORE }
} else {
	IMGUI_ODIN_LIB_DCIMGUI_CORE :: #config(IMGUI_ODIN_LIB_DCIMGUI_CORE, "lib/linux_amd64/libdcimgui_core.a")
	foreign import dcimgui_core { IMGUI_ODIN_LIB_DCIMGUI_CORE }
}

@(default_calling_convention="c")
foreign dcimgui_core {
	ImTextureRef_GetTexID :: proc(self: ^ImTextureRef) -> ImTextureID ---
	ImGui_CreateContext :: proc(shared_font_atlas: ^ImFontAtlas) -> ^ImGuiContext ---
	ImGui_DestroyContext :: proc(ctx: ^ImGuiContext) ---
	ImGui_GetCurrentContext :: proc() -> ^ImGuiContext ---
	ImGui_SetCurrentContext :: proc(ctx: ^ImGuiContext) ---
	ImGui_GetIO :: proc() -> ^ImGuiIO ---
	ImGui_GetPlatformIO :: proc() -> ^ImGuiPlatformIO ---
	ImGui_GetStyle :: proc() -> ^ImGuiStyle ---
	ImGui_NewFrame :: proc() ---
	ImGui_EndFrame :: proc() ---
	ImGui_Render :: proc() ---
	ImGui_GetDrawData :: proc() -> ^ImDrawData ---
	ImGui_ShowDemoWindow :: proc(p_open: ^bool) ---
	ImGui_ShowMetricsWindow :: proc(p_open: ^bool) ---
	ImGui_ShowDebugLogWindow :: proc(p_open: ^bool) ---
	ImGui_ShowIDStackToolWindow :: proc() ---
	ImGui_ShowIDStackToolWindowEx :: proc(p_open: ^bool) ---
	ImGui_ShowAboutWindow :: proc(p_open: ^bool) ---
	ImGui_ShowStyleEditor :: proc(ref: ^ImGuiStyle) ---
	ImGui_ShowStyleSelector :: proc(label: cstring) -> bool ---
	ImGui_ShowFontSelector :: proc(label: cstring) ---
	ImGui_ShowUserGuide :: proc() ---
	ImGui_GetVersion :: proc() -> cstring ---
	ImGui_StyleColorsDark :: proc(dst: ^ImGuiStyle) ---
	ImGui_StyleColorsLight :: proc(dst: ^ImGuiStyle) ---
	ImGui_StyleColorsClassic :: proc(dst: ^ImGuiStyle) ---
	ImGui_Begin :: proc(name: cstring, p_open: ^bool, flags: ImGuiWindowFlags) -> bool ---
	ImGui_End :: proc() ---
	ImGui_BeginChild :: proc(str_id: cstring, size: ImVec2, child_flags: ImGuiChildFlags, window_flags: ImGuiWindowFlags) -> bool ---
	ImGui_BeginChildID :: proc(id: ImGuiID, size: ImVec2, child_flags: ImGuiChildFlags, window_flags: ImGuiWindowFlags) -> bool ---
	ImGui_EndChild :: proc() ---
	ImGui_IsWindowAppearing :: proc() -> bool ---
	ImGui_IsWindowCollapsed :: proc() -> bool ---
	ImGui_IsWindowFocused :: proc(flags: ImGuiFocusedFlags) -> bool ---
	ImGui_IsWindowHovered :: proc(flags: ImGuiHoveredFlags) -> bool ---
	ImGui_GetWindowDrawList :: proc() -> ^ImDrawList ---
	ImGui_GetWindowDpiScale :: proc() -> f32 ---
	ImGui_GetWindowPos :: proc() -> ImVec2 ---
	ImGui_GetWindowSize :: proc() -> ImVec2 ---
	ImGui_GetWindowWidth :: proc() -> f32 ---
	ImGui_GetWindowHeight :: proc() -> f32 ---
	ImGui_GetWindowViewport :: proc() -> ^ImGuiViewport ---
	ImGui_SetNextWindowPos :: proc(pos: ImVec2, cond: ImGuiCond) ---
	ImGui_SetNextWindowPosEx :: proc(pos: ImVec2, cond: ImGuiCond, pivot: ImVec2) ---
	ImGui_SetNextWindowSize :: proc(size: ImVec2, cond: ImGuiCond) ---
	ImGui_SetNextWindowSizeConstraints :: proc(size_min: ImVec2, size_max: ImVec2, custom_callback: ImGuiSizeCallback, custom_callback_data: rawptr) ---
	ImGui_SetNextWindowContentSize :: proc(size: ImVec2) ---
	ImGui_SetNextWindowCollapsed :: proc(collapsed: bool, cond: ImGuiCond) ---
	ImGui_SetNextWindowFocus :: proc() ---
	ImGui_SetNextWindowScroll :: proc(scroll: ImVec2) ---
	ImGui_SetNextWindowBgAlpha :: proc(alpha: f32) ---
	ImGui_SetNextWindowViewport :: proc(viewport_id: ImGuiID) ---
	ImGui_SetWindowPos :: proc(pos: ImVec2, cond: ImGuiCond) ---
	ImGui_SetWindowSize :: proc(size: ImVec2, cond: ImGuiCond) ---
	ImGui_SetWindowCollapsed :: proc(collapsed: bool, cond: ImGuiCond) ---
	ImGui_SetWindowFocus :: proc() ---
	ImGui_SetWindowPosStr :: proc(name: cstring, pos: ImVec2, cond: ImGuiCond) ---
	ImGui_SetWindowSizeStr :: proc(name: cstring, size: ImVec2, cond: ImGuiCond) ---
	ImGui_SetWindowCollapsedStr :: proc(name: cstring, collapsed: bool, cond: ImGuiCond) ---
	ImGui_SetWindowFocusStr :: proc(name: cstring) ---
	ImGui_GetScrollX :: proc() -> f32 ---
	ImGui_GetScrollY :: proc() -> f32 ---
	ImGui_SetScrollX :: proc(scroll_x: f32) ---
	ImGui_SetScrollY :: proc(scroll_y: f32) ---
	ImGui_GetScrollMaxX :: proc() -> f32 ---
	ImGui_GetScrollMaxY :: proc() -> f32 ---
	ImGui_SetScrollHereX :: proc(center_x_ratio: f32) ---
	ImGui_SetScrollHereY :: proc(center_y_ratio: f32) ---
	ImGui_SetScrollFromPosX :: proc(local_x: f32, center_x_ratio: f32) ---
	ImGui_SetScrollFromPosY :: proc(local_y: f32, center_y_ratio: f32) ---
	ImGui_PushFontFloat :: proc(font: ^ImFont, font_size_base_unscaled: f32) ---
	ImGui_PopFont :: proc() ---
	ImGui_GetFont :: proc() -> ^ImFont ---
	ImGui_GetFontSize :: proc() -> f32 ---
	ImGui_GetFontBaked :: proc() -> ^ImFontBaked ---
	ImGui_PushStyleColor :: proc(idx: ImGuiCol, col: ImU32) ---
	ImGui_PushStyleColorImVec4 :: proc(idx: ImGuiCol, col: ImVec4) ---
	ImGui_PopStyleColor :: proc() ---
	ImGui_PopStyleColorEx :: proc(count: c.int) ---
	ImGui_PushStyleVar :: proc(idx: ImGuiStyleVar, val: f32) ---
	ImGui_PushStyleVarImVec2 :: proc(idx: ImGuiStyleVar, val: ImVec2) ---
	ImGui_PushStyleVarX :: proc(idx: ImGuiStyleVar, val_x: f32) ---
	ImGui_PushStyleVarY :: proc(idx: ImGuiStyleVar, val_y: f32) ---
	ImGui_PopStyleVar :: proc() ---
	ImGui_PopStyleVarEx :: proc(count: c.int) ---
	ImGui_PushItemFlag :: proc(option: ImGuiItemFlags, enabled: bool) ---
	ImGui_PopItemFlag :: proc() ---
	ImGui_PushItemWidth :: proc(item_width: f32) ---
	ImGui_PopItemWidth :: proc() ---
	ImGui_SetNextItemWidth :: proc(item_width: f32) ---
	ImGui_CalcItemWidth :: proc() -> f32 ---
	ImGui_PushTextWrapPos :: proc(wrap_local_pos_x: f32) ---
	ImGui_PopTextWrapPos :: proc() ---
	ImGui_GetFontTexUvWhitePixel :: proc() -> ImVec2 ---
	ImGui_GetColorU32 :: proc(idx: ImGuiCol) -> ImU32 ---
	ImGui_GetColorU32Ex :: proc(idx: ImGuiCol, alpha_mul: f32) -> ImU32 ---
	ImGui_GetColorU32ImVec4 :: proc(col: ImVec4) -> ImU32 ---
	ImGui_GetColorU32ImU32 :: proc(col: ImU32) -> ImU32 ---
	ImGui_GetColorU32ImU32Ex :: proc(col: ImU32, alpha_mul: f32) -> ImU32 ---
	ImGui_GetStyleColorVec4 :: proc(idx: ImGuiCol) -> ^ImVec4 ---
	ImGui_GetCursorScreenPos :: proc() -> ImVec2 ---
	ImGui_SetCursorScreenPos :: proc(pos: ImVec2) ---
	ImGui_GetContentRegionAvail :: proc() -> ImVec2 ---
	ImGui_GetCursorPos :: proc() -> ImVec2 ---
	ImGui_GetCursorPosX :: proc() -> f32 ---
	ImGui_GetCursorPosY :: proc() -> f32 ---
	ImGui_SetCursorPos :: proc(local_pos: ImVec2) ---
	ImGui_SetCursorPosX :: proc(local_x: f32) ---
	ImGui_SetCursorPosY :: proc(local_y: f32) ---
	ImGui_GetCursorStartPos :: proc() -> ImVec2 ---
	ImGui_Separator :: proc() ---
	ImGui_SameLine :: proc() ---
	ImGui_SameLineEx :: proc(offset_from_start_x: f32, spacing: f32) ---
	ImGui_NewLine :: proc() ---
	ImGui_Spacing :: proc() ---
	ImGui_Dummy :: proc(size: ImVec2) ---
	ImGui_Indent :: proc() ---
	ImGui_IndentEx :: proc(indent_w: f32) ---
	ImGui_Unindent :: proc() ---
	ImGui_UnindentEx :: proc(indent_w: f32) ---
	ImGui_BeginGroup :: proc() ---
	ImGui_EndGroup :: proc() ---
	ImGui_AlignTextToFramePadding :: proc() ---
	ImGui_GetTextLineHeight :: proc() -> f32 ---
	ImGui_GetTextLineHeightWithSpacing :: proc() -> f32 ---
	ImGui_GetFrameHeight :: proc() -> f32 ---
	ImGui_GetFrameHeightWithSpacing :: proc() -> f32 ---
	ImGui_PushID :: proc(str_id: cstring) ---
	ImGui_PushIDStr :: proc(str_id_begin: cstring, str_id_end: cstring) ---
	ImGui_PushIDPtr :: proc(ptr_id: rawptr) ---
	ImGui_PushIDInt :: proc(int_id: c.int) ---
	ImGui_PopID :: proc() ---
	ImGui_GetID :: proc(str_id: cstring) -> ImGuiID ---
	ImGui_GetIDStr :: proc(str_id_begin: cstring, str_id_end: cstring) -> ImGuiID ---
	ImGui_GetIDPtr :: proc(ptr_id: rawptr) -> ImGuiID ---
	ImGui_GetIDInt :: proc(int_id: c.int) -> ImGuiID ---
	ImGui_TextUnformatted :: proc(text: cstring) ---
	ImGui_TextUnformattedEx :: proc(text: cstring, text_end: cstring) ---
	ImGui_Text :: proc(fmt: cstring, #c_vararg args: ..any) ---
	ImGui_TextV :: proc(fmt: cstring, args: c.va_list) ---
	ImGui_TextColored :: proc(col: ImVec4, fmt: cstring, #c_vararg args: ..any) ---
	ImGui_TextColoredV :: proc(col: ImVec4, fmt: cstring, args: c.va_list) ---
	ImGui_TextDisabled :: proc(fmt: cstring, #c_vararg args: ..any) ---
	ImGui_TextDisabledV :: proc(fmt: cstring, args: c.va_list) ---
	ImGui_TextWrapped :: proc(fmt: cstring, #c_vararg args: ..any) ---
	ImGui_TextWrappedV :: proc(fmt: cstring, args: c.va_list) ---
	ImGui_LabelText :: proc(label: cstring, fmt: cstring, #c_vararg args: ..any) ---
	ImGui_LabelTextV :: proc(label: cstring, fmt: cstring, args: c.va_list) ---
	ImGui_BulletText :: proc(fmt: cstring, #c_vararg args: ..any) ---
	ImGui_BulletTextV :: proc(fmt: cstring, args: c.va_list) ---
	ImGui_SeparatorText :: proc(label: cstring) ---
	ImGui_Button :: proc(label: cstring) -> bool ---
	ImGui_ButtonEx :: proc(label: cstring, size: ImVec2) -> bool ---
	ImGui_SmallButton :: proc(label: cstring) -> bool ---
	ImGui_InvisibleButton :: proc(str_id: cstring, size: ImVec2, flags: ImGuiButtonFlags) -> bool ---
	ImGui_ArrowButton :: proc(str_id: cstring, dir: ImGuiDir) -> bool ---
	ImGui_Checkbox :: proc(label: cstring, v: ^bool) -> bool ---
	ImGui_CheckboxFlagsIntPtr :: proc(label: cstring, flags: ^c.int, flags_value: c.int) -> bool ---
	ImGui_CheckboxFlagsUintPtr :: proc(label: cstring, flags: ^c.uint, flags_value: c.uint) -> bool ---
	ImGui_RadioButton :: proc(label: cstring, active: bool) -> bool ---
	ImGui_RadioButtonIntPtr :: proc(label: cstring, v: ^c.int, v_button: c.int) -> bool ---
	ImGui_ProgressBar :: proc(fraction: f32, size_arg: ImVec2, overlay: cstring) ---
	ImGui_Bullet :: proc() ---
	ImGui_TextLink :: proc(label: cstring) -> bool ---
	ImGui_TextLinkOpenURL :: proc(label: cstring) -> bool ---
	ImGui_TextLinkOpenURLEx :: proc(label: cstring, url: cstring) -> bool ---
	ImGui_Image :: proc(tex_ref: ImTextureRef, image_size: ImVec2) ---
	ImGui_ImageEx :: proc(tex_ref: ImTextureRef, image_size: ImVec2, uv0: ImVec2, uv1: ImVec2) ---
	ImGui_ImageWithBg :: proc(tex_ref: ImTextureRef, image_size: ImVec2) ---
	ImGui_ImageWithBgEx :: proc(tex_ref: ImTextureRef, image_size: ImVec2, uv0: ImVec2, uv1: ImVec2, bg_col: ImVec4, tint_col: ImVec4) ---
	ImGui_ImageButton :: proc(str_id: cstring, tex_ref: ImTextureRef, image_size: ImVec2) -> bool ---
	ImGui_ImageButtonEx :: proc(str_id: cstring, tex_ref: ImTextureRef, image_size: ImVec2, uv0: ImVec2, uv1: ImVec2, bg_col: ImVec4, tint_col: ImVec4) -> bool ---
	ImGui_BeginCombo :: proc(label: cstring, preview_value: cstring, flags: ImGuiComboFlags) -> bool ---
	ImGui_EndCombo :: proc() ---
	ImGui_ComboChar :: proc(label: cstring, current_item: ^c.int, items: [^]cstring, items_count: c.int) -> bool ---
	ImGui_ComboCharEx :: proc(label: cstring, current_item: ^c.int, items: [^]cstring, items_count: c.int, popup_max_height_in_items: c.int) -> bool ---
	ImGui_Combo :: proc(label: cstring, current_item: ^c.int, items_separated_by_zeros: cstring) -> bool ---
	ImGui_ComboEx :: proc(label: cstring, current_item: ^c.int, items_separated_by_zeros: cstring, popup_max_height_in_items: c.int) -> bool ---
	ImGui_ComboCallback :: proc(label: cstring, current_item: ^c.int, getter: proc "c" (user_data: rawptr, idx: c.int) -> cstring, user_data: rawptr, items_count: c.int) -> bool ---
	ImGui_ComboCallbackEx :: proc(label: cstring, current_item: ^c.int, getter: proc "c" (user_data: rawptr, idx: c.int) -> cstring, user_data: rawptr, items_count: c.int, popup_max_height_in_items: c.int) -> bool ---
	ImGui_DragFloat :: proc(label: cstring, v: ^f32) -> bool ---
	ImGui_DragFloatEx :: proc(label: cstring, v: ^f32, v_speed: f32, v_min: f32, v_max: f32, format: cstring, flags: ImGuiSliderFlags) -> bool ---
	ImGui_DragFloat2 :: proc(label: cstring, v: ^f32) -> bool ---
	ImGui_DragFloat2Ex :: proc(label: cstring, v: ^f32, v_speed: f32, v_min: f32, v_max: f32, format: cstring, flags: ImGuiSliderFlags) -> bool ---
	ImGui_DragFloat3 :: proc(label: cstring, v: ^f32) -> bool ---
	ImGui_DragFloat3Ex :: proc(label: cstring, v: ^f32, v_speed: f32, v_min: f32, v_max: f32, format: cstring, flags: ImGuiSliderFlags) -> bool ---
	ImGui_DragFloat4 :: proc(label: cstring, v: ^f32) -> bool ---
	ImGui_DragFloat4Ex :: proc(label: cstring, v: ^f32, v_speed: f32, v_min: f32, v_max: f32, format: cstring, flags: ImGuiSliderFlags) -> bool ---
	ImGui_DragFloatRange2 :: proc(label: cstring, v_current_min: ^f32, v_current_max: ^f32) -> bool ---
	ImGui_DragFloatRange2Ex :: proc(label: cstring, v_current_min: ^f32, v_current_max: ^f32, v_speed: f32, v_min: f32, v_max: f32, format: cstring, format_max: cstring, flags: ImGuiSliderFlags) -> bool ---
	ImGui_DragInt :: proc(label: cstring, v: ^c.int) -> bool ---
	ImGui_DragIntEx :: proc(label: cstring, v: ^c.int, v_speed: f32, v_min: c.int, v_max: c.int, format: cstring, flags: ImGuiSliderFlags) -> bool ---
	ImGui_DragInt2 :: proc(label: cstring, v: ^c.int) -> bool ---
	ImGui_DragInt2Ex :: proc(label: cstring, v: ^c.int, v_speed: f32, v_min: c.int, v_max: c.int, format: cstring, flags: ImGuiSliderFlags) -> bool ---
	ImGui_DragInt3 :: proc(label: cstring, v: ^c.int) -> bool ---
	ImGui_DragInt3Ex :: proc(label: cstring, v: ^c.int, v_speed: f32, v_min: c.int, v_max: c.int, format: cstring, flags: ImGuiSliderFlags) -> bool ---
	ImGui_DragInt4 :: proc(label: cstring, v: ^c.int) -> bool ---
	ImGui_DragInt4Ex :: proc(label: cstring, v: ^c.int, v_speed: f32, v_min: c.int, v_max: c.int, format: cstring, flags: ImGuiSliderFlags) -> bool ---
	ImGui_DragIntRange2 :: proc(label: cstring, v_current_min: ^c.int, v_current_max: ^c.int) -> bool ---
	ImGui_DragIntRange2Ex :: proc(label: cstring, v_current_min: ^c.int, v_current_max: ^c.int, v_speed: f32, v_min: c.int, v_max: c.int, format: cstring, format_max: cstring, flags: ImGuiSliderFlags) -> bool ---
	ImGui_DragScalar :: proc(label: cstring, data_type: ImGuiDataType, p_data: rawptr) -> bool ---
	ImGui_DragScalarEx :: proc(label: cstring, data_type: ImGuiDataType, p_data: rawptr, v_speed: f32, p_min: rawptr, p_max: rawptr, format: cstring, flags: ImGuiSliderFlags) -> bool ---
	ImGui_DragScalarN :: proc(label: cstring, data_type: ImGuiDataType, p_data: rawptr, components: c.int) -> bool ---
	ImGui_DragScalarNEx :: proc(label: cstring, data_type: ImGuiDataType, p_data: rawptr, components: c.int, v_speed: f32, p_min: rawptr, p_max: rawptr, format: cstring, flags: ImGuiSliderFlags) -> bool ---
	ImGui_SliderFloat :: proc(label: cstring, v: ^f32, v_min: f32, v_max: f32) -> bool ---
	ImGui_SliderFloatEx :: proc(label: cstring, v: ^f32, v_min: f32, v_max: f32, format: cstring, flags: ImGuiSliderFlags) -> bool ---
	ImGui_SliderFloat2 :: proc(label: cstring, v: ^f32, v_min: f32, v_max: f32) -> bool ---
	ImGui_SliderFloat2Ex :: proc(label: cstring, v: ^f32, v_min: f32, v_max: f32, format: cstring, flags: ImGuiSliderFlags) -> bool ---
	ImGui_SliderFloat3 :: proc(label: cstring, v: ^f32, v_min: f32, v_max: f32) -> bool ---
	ImGui_SliderFloat3Ex :: proc(label: cstring, v: ^f32, v_min: f32, v_max: f32, format: cstring, flags: ImGuiSliderFlags) -> bool ---
	ImGui_SliderFloat4 :: proc(label: cstring, v: ^f32, v_min: f32, v_max: f32) -> bool ---
	ImGui_SliderFloat4Ex :: proc(label: cstring, v: ^f32, v_min: f32, v_max: f32, format: cstring, flags: ImGuiSliderFlags) -> bool ---
	ImGui_SliderAngle :: proc(label: cstring, v_rad: ^f32) -> bool ---
	ImGui_SliderAngleEx :: proc(label: cstring, v_rad: ^f32, v_degrees_min: f32, v_degrees_max: f32, format: cstring, flags: ImGuiSliderFlags) -> bool ---
	ImGui_SliderInt :: proc(label: cstring, v: ^c.int, v_min: c.int, v_max: c.int) -> bool ---
	ImGui_SliderIntEx :: proc(label: cstring, v: ^c.int, v_min: c.int, v_max: c.int, format: cstring, flags: ImGuiSliderFlags) -> bool ---
	ImGui_SliderInt2 :: proc(label: cstring, v: ^c.int, v_min: c.int, v_max: c.int) -> bool ---
	ImGui_SliderInt2Ex :: proc(label: cstring, v: ^c.int, v_min: c.int, v_max: c.int, format: cstring, flags: ImGuiSliderFlags) -> bool ---
	ImGui_SliderInt3 :: proc(label: cstring, v: ^c.int, v_min: c.int, v_max: c.int) -> bool ---
	ImGui_SliderInt3Ex :: proc(label: cstring, v: ^c.int, v_min: c.int, v_max: c.int, format: cstring, flags: ImGuiSliderFlags) -> bool ---
	ImGui_SliderInt4 :: proc(label: cstring, v: ^c.int, v_min: c.int, v_max: c.int) -> bool ---
	ImGui_SliderInt4Ex :: proc(label: cstring, v: ^c.int, v_min: c.int, v_max: c.int, format: cstring, flags: ImGuiSliderFlags) -> bool ---
	ImGui_SliderScalar :: proc(label: cstring, data_type: ImGuiDataType, p_data: rawptr, p_min: rawptr, p_max: rawptr) -> bool ---
	ImGui_SliderScalarEx :: proc(label: cstring, data_type: ImGuiDataType, p_data: rawptr, p_min: rawptr, p_max: rawptr, format: cstring, flags: ImGuiSliderFlags) -> bool ---
	ImGui_SliderScalarN :: proc(label: cstring, data_type: ImGuiDataType, p_data: rawptr, components: c.int, p_min: rawptr, p_max: rawptr) -> bool ---
	ImGui_SliderScalarNEx :: proc(label: cstring, data_type: ImGuiDataType, p_data: rawptr, components: c.int, p_min: rawptr, p_max: rawptr, format: cstring, flags: ImGuiSliderFlags) -> bool ---
	ImGui_VSliderFloat :: proc(label: cstring, size: ImVec2, v: ^f32, v_min: f32, v_max: f32) -> bool ---
	ImGui_VSliderFloatEx :: proc(label: cstring, size: ImVec2, v: ^f32, v_min: f32, v_max: f32, format: cstring, flags: ImGuiSliderFlags) -> bool ---
	ImGui_VSliderInt :: proc(label: cstring, size: ImVec2, v: ^c.int, v_min: c.int, v_max: c.int) -> bool ---
	ImGui_VSliderIntEx :: proc(label: cstring, size: ImVec2, v: ^c.int, v_min: c.int, v_max: c.int, format: cstring, flags: ImGuiSliderFlags) -> bool ---
	ImGui_VSliderScalar :: proc(label: cstring, size: ImVec2, data_type: ImGuiDataType, p_data: rawptr, p_min: rawptr, p_max: rawptr) -> bool ---
	ImGui_VSliderScalarEx :: proc(label: cstring, size: ImVec2, data_type: ImGuiDataType, p_data: rawptr, p_min: rawptr, p_max: rawptr, format: cstring, flags: ImGuiSliderFlags) -> bool ---
	ImGui_InputText :: proc(label: cstring, buf: [^]c.char, buf_size: c.size_t, flags: ImGuiInputTextFlags) -> bool ---
	ImGui_InputTextEx :: proc(label: cstring, buf: [^]c.char, buf_size: c.size_t, flags: ImGuiInputTextFlags, callback: ImGuiInputTextCallback, user_data: rawptr) -> bool ---
	ImGui_InputTextMultiline :: proc(label: cstring, buf: [^]c.char, buf_size: c.size_t) -> bool ---
	ImGui_InputTextMultilineEx :: proc(label: cstring, buf: [^]c.char, buf_size: c.size_t, size: ImVec2, flags: ImGuiInputTextFlags, callback: ImGuiInputTextCallback, user_data: rawptr) -> bool ---
	ImGui_InputTextWithHint :: proc(label: cstring, hint: cstring, buf: [^]c.char, buf_size: c.size_t, flags: ImGuiInputTextFlags) -> bool ---
	ImGui_InputTextWithHintEx :: proc(label: cstring, hint: cstring, buf: [^]c.char, buf_size: c.size_t, flags: ImGuiInputTextFlags, callback: ImGuiInputTextCallback, user_data: rawptr) -> bool ---
	ImGui_InputFloat :: proc(label: cstring, v: ^f32) -> bool ---
	ImGui_InputFloatEx :: proc(label: cstring, v: ^f32, step: f32, step_fast: f32, format: cstring, flags: ImGuiInputTextFlags) -> bool ---
	ImGui_InputFloat2 :: proc(label: cstring, v: ^f32) -> bool ---
	ImGui_InputFloat2Ex :: proc(label: cstring, v: ^f32, format: cstring, flags: ImGuiInputTextFlags) -> bool ---
	ImGui_InputFloat3 :: proc(label: cstring, v: ^f32) -> bool ---
	ImGui_InputFloat3Ex :: proc(label: cstring, v: ^f32, format: cstring, flags: ImGuiInputTextFlags) -> bool ---
	ImGui_InputFloat4 :: proc(label: cstring, v: ^f32) -> bool ---
	ImGui_InputFloat4Ex :: proc(label: cstring, v: ^f32, format: cstring, flags: ImGuiInputTextFlags) -> bool ---
	ImGui_InputInt :: proc(label: cstring, v: ^c.int) -> bool ---
	ImGui_InputIntEx :: proc(label: cstring, v: ^c.int, step: c.int, step_fast: c.int, flags: ImGuiInputTextFlags) -> bool ---
	ImGui_InputInt2 :: proc(label: cstring, v: ^c.int, flags: ImGuiInputTextFlags) -> bool ---
	ImGui_InputInt3 :: proc(label: cstring, v: ^c.int, flags: ImGuiInputTextFlags) -> bool ---
	ImGui_InputInt4 :: proc(label: cstring, v: ^c.int, flags: ImGuiInputTextFlags) -> bool ---
	ImGui_InputDouble :: proc(label: cstring, v: ^f64) -> bool ---
	ImGui_InputDoubleEx :: proc(label: cstring, v: ^f64, step: f64, step_fast: f64, format: cstring, flags: ImGuiInputTextFlags) -> bool ---
	ImGui_InputScalar :: proc(label: cstring, data_type: ImGuiDataType, p_data: rawptr) -> bool ---
	ImGui_InputScalarEx :: proc(label: cstring, data_type: ImGuiDataType, p_data: rawptr, p_step: rawptr, p_step_fast: rawptr, format: cstring, flags: ImGuiInputTextFlags) -> bool ---
	ImGui_InputScalarN :: proc(label: cstring, data_type: ImGuiDataType, p_data: rawptr, components: c.int) -> bool ---
	ImGui_InputScalarNEx :: proc(label: cstring, data_type: ImGuiDataType, p_data: rawptr, components: c.int, p_step: rawptr, p_step_fast: rawptr, format: cstring, flags: ImGuiInputTextFlags) -> bool ---
	ImGui_ColorEdit3 :: proc(label: cstring, col: ^f32, flags: ImGuiColorEditFlags) -> bool ---
	ImGui_ColorEdit4 :: proc(label: cstring, col: ^f32, flags: ImGuiColorEditFlags) -> bool ---
	ImGui_ColorPicker3 :: proc(label: cstring, col: ^f32, flags: ImGuiColorEditFlags) -> bool ---
	ImGui_ColorPicker4 :: proc(label: cstring, col: ^f32, flags: ImGuiColorEditFlags, ref_col: ^f32) -> bool ---
	ImGui_ColorButton :: proc(desc_id: cstring, col: ImVec4, flags: ImGuiColorEditFlags) -> bool ---
	ImGui_ColorButtonEx :: proc(desc_id: cstring, col: ImVec4, flags: ImGuiColorEditFlags, size: ImVec2) -> bool ---
	ImGui_SetColorEditOptions :: proc(flags: ImGuiColorEditFlags) ---
	ImGui_TreeNode :: proc(label: cstring) -> bool ---
	ImGui_TreeNodeStr :: proc(str_id: cstring, fmt: cstring, #c_vararg args: ..any) -> bool ---
	ImGui_TreeNodePtr :: proc(ptr_id: rawptr, fmt: cstring, #c_vararg args: ..any) -> bool ---
	ImGui_TreeNodeV :: proc(str_id: cstring, fmt: cstring, args: c.va_list) -> bool ---
	ImGui_TreeNodeVPtr :: proc(ptr_id: rawptr, fmt: cstring, args: c.va_list) -> bool ---
	ImGui_TreeNodeEx :: proc(label: cstring, flags: ImGuiTreeNodeFlags) -> bool ---
	ImGui_TreeNodeExStr :: proc(str_id: cstring, flags: ImGuiTreeNodeFlags, fmt: cstring, #c_vararg args: ..any) -> bool ---
	ImGui_TreeNodeExPtr :: proc(ptr_id: rawptr, flags: ImGuiTreeNodeFlags, fmt: cstring, #c_vararg args: ..any) -> bool ---
	ImGui_TreeNodeExV :: proc(str_id: cstring, flags: ImGuiTreeNodeFlags, fmt: cstring, args: c.va_list) -> bool ---
	ImGui_TreeNodeExVPtr :: proc(ptr_id: rawptr, flags: ImGuiTreeNodeFlags, fmt: cstring, args: c.va_list) -> bool ---
	ImGui_TreePush :: proc(str_id: cstring) ---
	ImGui_TreePushPtr :: proc(ptr_id: rawptr) ---
	ImGui_TreePop :: proc() ---
	ImGui_GetTreeNodeToLabelSpacing :: proc() -> f32 ---
	ImGui_CollapsingHeader :: proc(label: cstring, flags: ImGuiTreeNodeFlags) -> bool ---
	ImGui_CollapsingHeaderBoolPtr :: proc(label: cstring, p_visible: ^bool, flags: ImGuiTreeNodeFlags) -> bool ---
	ImGui_SetNextItemOpen :: proc(is_open: bool, cond: ImGuiCond) ---
	ImGui_SetNextItemStorageID :: proc(storage_id: ImGuiID) ---
	ImGui_TreeNodeGetOpen :: proc(storage_id: ImGuiID) -> bool ---
	ImGui_Selectable :: proc(label: cstring) -> bool ---
	ImGui_SelectableEx :: proc(label: cstring, selected: bool, flags: ImGuiSelectableFlags, size: ImVec2) -> bool ---
	ImGui_SelectableBoolPtr :: proc(label: cstring, p_selected: ^bool, flags: ImGuiSelectableFlags) -> bool ---
	ImGui_SelectableBoolPtrEx :: proc(label: cstring, p_selected: ^bool, flags: ImGuiSelectableFlags, size: ImVec2) -> bool ---
	ImGui_BeginMultiSelect :: proc(flags: ImGuiMultiSelectFlags) -> ^ImGuiMultiSelectIO ---
	ImGui_BeginMultiSelectEx :: proc(flags: ImGuiMultiSelectFlags, selection_size: c.int, items_count: c.int) -> ^ImGuiMultiSelectIO ---
	ImGui_EndMultiSelect :: proc() -> ^ImGuiMultiSelectIO ---
	ImGui_SetNextItemSelectionUserData :: proc(selection_user_data: ImGuiSelectionUserData) ---
	ImGui_IsItemToggledSelection :: proc() -> bool ---
	ImGui_BeginListBox :: proc(label: cstring, size: ImVec2) -> bool ---
	ImGui_EndListBox :: proc() ---
	ImGui_ListBox :: proc(label: cstring, current_item: ^c.int, items: [^]cstring, items_count: c.int, height_in_items: c.int) -> bool ---
	ImGui_ListBoxCallback :: proc(label: cstring, current_item: ^c.int, getter: proc "c" (user_data: rawptr, idx: c.int) -> cstring, user_data: rawptr, items_count: c.int) -> bool ---
	ImGui_ListBoxCallbackEx :: proc(label: cstring, current_item: ^c.int, getter: proc "c" (user_data: rawptr, idx: c.int) -> cstring, user_data: rawptr, items_count: c.int, height_in_items: c.int) -> bool ---
	ImGui_PlotLines :: proc(label: cstring, values: ^f32, values_count: c.int) ---
	ImGui_PlotLinesEx :: proc(label: cstring, values: ^f32, values_count: c.int, values_offset: c.int, overlay_text: cstring, scale_min: f32, scale_max: f32, graph_size: ImVec2, stride: c.int) ---
	ImGui_PlotLinesCallback :: proc(label: cstring, values_getter: proc "c" (data: rawptr, idx: c.int) -> f32, data: rawptr, values_count: c.int) ---
	ImGui_PlotLinesCallbackEx :: proc(label: cstring, values_getter: proc "c" (data: rawptr, idx: c.int) -> f32, data: rawptr, values_count: c.int, values_offset: c.int, overlay_text: cstring, scale_min: f32, scale_max: f32, graph_size: ImVec2) ---
	ImGui_PlotHistogram :: proc(label: cstring, values: ^f32, values_count: c.int) ---
	ImGui_PlotHistogramEx :: proc(label: cstring, values: ^f32, values_count: c.int, values_offset: c.int, overlay_text: cstring, scale_min: f32, scale_max: f32, graph_size: ImVec2, stride: c.int) ---
	ImGui_PlotHistogramCallback :: proc(label: cstring, values_getter: proc "c" (data: rawptr, idx: c.int) -> f32, data: rawptr, values_count: c.int) ---
	ImGui_PlotHistogramCallbackEx :: proc(label: cstring, values_getter: proc "c" (data: rawptr, idx: c.int) -> f32, data: rawptr, values_count: c.int, values_offset: c.int, overlay_text: cstring, scale_min: f32, scale_max: f32, graph_size: ImVec2) ---
	ImGui_BeginMenuBar :: proc() -> bool ---
	ImGui_EndMenuBar :: proc() ---
	ImGui_BeginMainMenuBar :: proc() -> bool ---
	ImGui_EndMainMenuBar :: proc() ---
	ImGui_BeginMenu :: proc(label: cstring) -> bool ---
	ImGui_BeginMenuEx :: proc(label: cstring, enabled: bool) -> bool ---
	ImGui_EndMenu :: proc() ---
	ImGui_MenuItem :: proc(label: cstring) -> bool ---
	ImGui_MenuItemEx :: proc(label: cstring, shortcut: cstring, selected: bool, enabled: bool) -> bool ---
	ImGui_MenuItemBoolPtr :: proc(label: cstring, shortcut: cstring, p_selected: ^bool, enabled: bool) -> bool ---
	ImGui_BeginTooltip :: proc() -> bool ---
	ImGui_EndTooltip :: proc() ---
	ImGui_SetTooltip :: proc(fmt: cstring, #c_vararg args: ..any) ---
	ImGui_SetTooltipV :: proc(fmt: cstring, args: c.va_list) ---
	ImGui_BeginItemTooltip :: proc() -> bool ---
	ImGui_SetItemTooltip :: proc(fmt: cstring, #c_vararg args: ..any) ---
	ImGui_SetItemTooltipV :: proc(fmt: cstring, args: c.va_list) ---
	ImGui_BeginPopup :: proc(str_id: cstring, flags: ImGuiWindowFlags) -> bool ---
	ImGui_BeginPopupModal :: proc(name: cstring, p_open: ^bool, flags: ImGuiWindowFlags) -> bool ---
	ImGui_EndPopup :: proc() ---
	ImGui_OpenPopup :: proc(str_id: cstring, popup_flags: ImGuiPopupFlags) ---
	ImGui_OpenPopupID :: proc(id: ImGuiID, popup_flags: ImGuiPopupFlags) ---
	ImGui_OpenPopupOnItemClick :: proc(str_id: cstring, popup_flags: ImGuiPopupFlags) ---
	ImGui_CloseCurrentPopup :: proc() ---
	ImGui_BeginPopupContextItem :: proc() -> bool ---
	ImGui_BeginPopupContextItemEx :: proc(str_id: cstring, popup_flags: ImGuiPopupFlags) -> bool ---
	ImGui_BeginPopupContextWindow :: proc() -> bool ---
	ImGui_BeginPopupContextWindowEx :: proc(str_id: cstring, popup_flags: ImGuiPopupFlags) -> bool ---
	ImGui_BeginPopupContextVoid :: proc() -> bool ---
	ImGui_BeginPopupContextVoidEx :: proc(str_id: cstring, popup_flags: ImGuiPopupFlags) -> bool ---
	ImGui_IsPopupOpen :: proc(str_id: cstring, flags: ImGuiPopupFlags) -> bool ---
	ImGui_BeginTable :: proc(str_id: cstring, columns: c.int, flags: ImGuiTableFlags) -> bool ---
	ImGui_BeginTableEx :: proc(str_id: cstring, columns: c.int, flags: ImGuiTableFlags, outer_size: ImVec2, inner_width: f32) -> bool ---
	ImGui_EndTable :: proc() ---
	ImGui_TableNextRow :: proc() ---
	ImGui_TableNextRowEx :: proc(row_flags: ImGuiTableRowFlags, min_row_height: f32) ---
	ImGui_TableNextColumn :: proc() -> bool ---
	ImGui_TableSetColumnIndex :: proc(column_n: c.int) -> bool ---
	ImGui_TableSetupColumn :: proc(label: cstring, flags: ImGuiTableColumnFlags) ---
	ImGui_TableSetupColumnEx :: proc(label: cstring, flags: ImGuiTableColumnFlags, init_width_or_weight: f32, user_id: ImGuiID) ---
	ImGui_TableSetupScrollFreeze :: proc(cols: c.int, rows: c.int) ---
	ImGui_TableHeader :: proc(label: cstring) ---
	ImGui_TableHeadersRow :: proc() ---
	ImGui_TableAngledHeadersRow :: proc() ---
	ImGui_TableGetSortSpecs :: proc() -> ^ImGuiTableSortSpecs ---
	ImGui_TableGetColumnCount :: proc() -> c.int ---
	ImGui_TableGetColumnIndex :: proc() -> c.int ---
	ImGui_TableGetRowIndex :: proc() -> c.int ---
	ImGui_TableGetColumnName :: proc(column_n: c.int) -> cstring ---
	ImGui_TableGetColumnFlags :: proc(column_n: c.int) -> ImGuiTableColumnFlags ---
	ImGui_TableSetColumnEnabled :: proc(column_n: c.int, v: bool) ---
	ImGui_TableGetHoveredColumn :: proc() -> c.int ---
	ImGui_TableSetBgColor :: proc(target: ImGuiTableBgTarget, color: ImU32, column_n: c.int) ---
	ImGui_Columns :: proc() ---
	ImGui_ColumnsEx :: proc(count: c.int, id: cstring, borders: bool) ---
	ImGui_NextColumn :: proc() ---
	ImGui_GetColumnIndex :: proc() -> c.int ---
	ImGui_GetColumnWidth :: proc(column_index: c.int) -> f32 ---
	ImGui_SetColumnWidth :: proc(column_index: c.int, width: f32) ---
	ImGui_GetColumnOffset :: proc(column_index: c.int) -> f32 ---
	ImGui_SetColumnOffset :: proc(column_index: c.int, offset_x: f32) ---
	ImGui_GetColumnsCount :: proc() -> c.int ---
	ImGui_BeginTabBar :: proc(str_id: cstring, flags: ImGuiTabBarFlags) -> bool ---
	ImGui_EndTabBar :: proc() ---
	ImGui_BeginTabItem :: proc(label: cstring, p_open: ^bool, flags: ImGuiTabItemFlags) -> bool ---
	ImGui_EndTabItem :: proc() ---
	ImGui_TabItemButton :: proc(label: cstring, flags: ImGuiTabItemFlags) -> bool ---
	ImGui_SetTabItemClosed :: proc(tab_or_docked_window_label: cstring) ---
	ImGui_DockSpace :: proc(dockspace_id: ImGuiID) -> ImGuiID ---
	ImGui_DockSpaceEx :: proc(dockspace_id: ImGuiID, size: ImVec2, flags: ImGuiDockNodeFlags, window_class: ^ImGuiWindowClass) -> ImGuiID ---
	ImGui_DockSpaceOverViewport :: proc() -> ImGuiID ---
	ImGui_DockSpaceOverViewportEx :: proc(dockspace_id: ImGuiID, viewport: ^ImGuiViewport, flags: ImGuiDockNodeFlags, window_class: ^ImGuiWindowClass) -> ImGuiID ---
	ImGui_SetNextWindowDockID :: proc(dock_id: ImGuiID, cond: ImGuiCond) ---
	ImGui_SetNextWindowClass :: proc(window_class: ^ImGuiWindowClass) ---
	ImGui_GetWindowDockID :: proc() -> ImGuiID ---
	ImGui_IsWindowDocked :: proc() -> bool ---
	ImGui_LogToTTY :: proc(auto_open_depth: c.int) ---
	ImGui_LogToFile :: proc(auto_open_depth: c.int, filename: cstring) ---
	ImGui_LogToClipboard :: proc(auto_open_depth: c.int) ---
	ImGui_LogFinish :: proc() ---
	ImGui_LogButtons :: proc() ---
	ImGui_LogText :: proc(fmt: cstring, #c_vararg args: ..any) ---
	ImGui_LogTextV :: proc(fmt: cstring, args: c.va_list) ---
	ImGui_BeginDragDropSource :: proc(flags: ImGuiDragDropFlags) -> bool ---
	ImGui_SetDragDropPayload :: proc(type: cstring, data: rawptr, sz: c.size_t, cond: ImGuiCond) -> bool ---
	ImGui_EndDragDropSource :: proc() ---
	ImGui_BeginDragDropTarget :: proc() -> bool ---
	ImGui_AcceptDragDropPayload :: proc(type: cstring, flags: ImGuiDragDropFlags) -> ^ImGuiPayload ---
	ImGui_EndDragDropTarget :: proc() ---
	ImGui_GetDragDropPayload :: proc() -> ^ImGuiPayload ---
	ImGui_BeginDisabled :: proc(disabled: bool) ---
	ImGui_EndDisabled :: proc() ---
	ImGui_PushClipRect :: proc(clip_rect_min: ImVec2, clip_rect_max: ImVec2, intersect_with_current_clip_rect: bool) ---
	ImGui_PopClipRect :: proc() ---
	ImGui_SetItemDefaultFocus :: proc() ---
	ImGui_SetKeyboardFocusHere :: proc() ---
	ImGui_SetKeyboardFocusHereEx :: proc(offset: c.int) ---
	ImGui_SetNavCursorVisible :: proc(visible: bool) ---
	ImGui_SetNextItemAllowOverlap :: proc() ---
	ImGui_IsItemHovered :: proc(flags: ImGuiHoveredFlags) -> bool ---
	ImGui_IsItemActive :: proc() -> bool ---
	ImGui_IsItemFocused :: proc() -> bool ---
	ImGui_IsItemClicked :: proc() -> bool ---
	ImGui_IsItemClickedEx :: proc(mouse_button: ImGuiMouseButton) -> bool ---
	ImGui_IsItemVisible :: proc() -> bool ---
	ImGui_IsItemEdited :: proc() -> bool ---
	ImGui_IsItemActivated :: proc() -> bool ---
	ImGui_IsItemDeactivated :: proc() -> bool ---
	ImGui_IsItemDeactivatedAfterEdit :: proc() -> bool ---
	ImGui_IsItemToggledOpen :: proc() -> bool ---
	ImGui_IsAnyItemHovered :: proc() -> bool ---
	ImGui_IsAnyItemActive :: proc() -> bool ---
	ImGui_IsAnyItemFocused :: proc() -> bool ---
	ImGui_GetItemID :: proc() -> ImGuiID ---
	ImGui_GetItemRectMin :: proc() -> ImVec2 ---
	ImGui_GetItemRectMax :: proc() -> ImVec2 ---
	ImGui_GetItemRectSize :: proc() -> ImVec2 ---
	ImGui_GetItemFlags :: proc() -> ImGuiItemFlags ---
	ImGui_GetMainViewport :: proc() -> ^ImGuiViewport ---
	ImGui_GetBackgroundDrawList :: proc() -> ^ImDrawList ---
	ImGui_GetBackgroundDrawListEx :: proc(viewport: ^ImGuiViewport) -> ^ImDrawList ---
	ImGui_GetForegroundDrawList :: proc() -> ^ImDrawList ---
	ImGui_GetForegroundDrawListEx :: proc(viewport: ^ImGuiViewport) -> ^ImDrawList ---
	ImGui_IsRectVisibleBySize :: proc(size: ImVec2) -> bool ---
	ImGui_IsRectVisible :: proc(rect_min: ImVec2, rect_max: ImVec2) -> bool ---
	ImGui_GetTime :: proc() -> f64 ---
	ImGui_GetFrameCount :: proc() -> c.int ---
	ImGui_GetDrawListSharedData :: proc() -> ^ImDrawListSharedData ---
	ImGui_GetStyleColorName :: proc(idx: ImGuiCol) -> cstring ---
	ImGui_SetStateStorage :: proc(storage: ^ImGuiStorage) ---
	ImGui_GetStateStorage :: proc() -> ^ImGuiStorage ---
	ImGui_CalcTextSize :: proc(text: cstring) -> ImVec2 ---
	ImGui_CalcTextSizeEx :: proc(text: cstring, text_end: cstring, hide_text_after_double_hash: bool, wrap_width: f32) -> ImVec2 ---
	ImGui_ColorConvertU32ToFloat4 :: proc(in_: ImU32) -> ImVec4 ---
	ImGui_ColorConvertFloat4ToU32 :: proc(in_: ImVec4) -> ImU32 ---
	ImGui_ColorConvertRGBtoHSV :: proc(r: f32, g: f32, b: f32, out_h: ^f32, out_s: ^f32, out_v: ^f32) ---
	ImGui_ColorConvertHSVtoRGB :: proc(h: f32, s: f32, v: f32, out_r: ^f32, out_g: ^f32, out_b: ^f32) ---
	ImGui_IsKeyDown :: proc(key: ImGuiKey) -> bool ---
	ImGui_IsKeyPressed :: proc(key: ImGuiKey) -> bool ---
	ImGui_IsKeyPressedEx :: proc(key: ImGuiKey, repeat: bool) -> bool ---
	ImGui_IsKeyReleased :: proc(key: ImGuiKey) -> bool ---
	ImGui_IsKeyChordPressed :: proc(key_chord: ImGuiKeyChord) -> bool ---
	ImGui_GetKeyPressedAmount :: proc(key: ImGuiKey, repeat_delay: f32, rate: f32) -> c.int ---
	ImGui_GetKeyName :: proc(key: ImGuiKey) -> cstring ---
	ImGui_SetNextFrameWantCaptureKeyboard :: proc(want_capture_keyboard: bool) ---
	ImGui_Shortcut :: proc(key_chord: ImGuiKeyChord, flags: ImGuiInputFlags) -> bool ---
	ImGui_SetNextItemShortcut :: proc(key_chord: ImGuiKeyChord, flags: ImGuiInputFlags) ---
	ImGui_SetItemKeyOwner :: proc(key: ImGuiKey) -> bool ---
	ImGui_IsMouseDown :: proc(button: ImGuiMouseButton) -> bool ---
	ImGui_IsMouseClicked :: proc(button: ImGuiMouseButton) -> bool ---
	ImGui_IsMouseClickedEx :: proc(button: ImGuiMouseButton, repeat: bool) -> bool ---
	ImGui_IsMouseReleased :: proc(button: ImGuiMouseButton) -> bool ---
	ImGui_IsMouseDoubleClicked :: proc(button: ImGuiMouseButton) -> bool ---
	ImGui_IsMouseReleasedWithDelay :: proc(button: ImGuiMouseButton, delay: f32) -> bool ---
	ImGui_GetMouseClickedCount :: proc(button: ImGuiMouseButton) -> c.int ---
	ImGui_IsMouseHoveringRect :: proc(r_min: ImVec2, r_max: ImVec2) -> bool ---
	ImGui_IsMouseHoveringRectEx :: proc(r_min: ImVec2, r_max: ImVec2, clip: bool) -> bool ---
	ImGui_IsMousePosValid :: proc(mouse_pos: ^ImVec2) -> bool ---
	ImGui_IsAnyMouseDown :: proc() -> bool ---
	ImGui_GetMousePos :: proc() -> ImVec2 ---
	ImGui_GetMousePosOnOpeningCurrentPopup :: proc() -> ImVec2 ---
	ImGui_IsMouseDragging :: proc(button: ImGuiMouseButton, lock_threshold: f32) -> bool ---
	ImGui_GetMouseDragDelta :: proc(button: ImGuiMouseButton, lock_threshold: f32) -> ImVec2 ---
	ImGui_ResetMouseDragDelta :: proc() ---
	ImGui_ResetMouseDragDeltaEx :: proc(button: ImGuiMouseButton) ---
	ImGui_GetMouseCursor :: proc() -> ImGuiMouseCursor ---
	ImGui_SetMouseCursor :: proc(cursor_type: ImGuiMouseCursor) ---
	ImGui_SetNextFrameWantCaptureMouse :: proc(want_capture_mouse: bool) ---
	ImGui_GetClipboardText :: proc() -> cstring ---
	ImGui_SetClipboardText :: proc(text: cstring) ---
	ImGui_LoadIniSettingsFromDisk :: proc(ini_filename: cstring) ---
	ImGui_LoadIniSettingsFromMemory :: proc(ini_data: cstring, ini_size: c.size_t) ---
	ImGui_SaveIniSettingsToDisk :: proc(ini_filename: cstring) ---
	ImGui_SaveIniSettingsToMemory :: proc(out_ini_size: ^c.size_t) -> cstring ---
	ImGui_DebugTextEncoding :: proc(text: cstring) ---
	ImGui_DebugFlashStyleColor :: proc(idx: ImGuiCol) ---
	ImGui_DebugStartItemPicker :: proc() ---
	ImGui_DebugCheckVersionAndDataLayout :: proc(version_str: cstring, sz_io: c.size_t, sz_style: c.size_t, sz_vec2: c.size_t, sz_vec4: c.size_t, sz_drawvert: c.size_t, sz_drawidx: c.size_t) -> bool ---
	ImGui_DebugLog :: proc(fmt: cstring, #c_vararg args: ..any) ---
	ImGui_DebugLogV :: proc(fmt: cstring, args: c.va_list) ---
	ImGui_SetAllocatorFunctions :: proc(alloc_func: ImGuiMemAllocFunc, free_func: ImGuiMemFreeFunc, user_data: rawptr) ---
	ImGui_GetAllocatorFunctions :: proc(p_alloc_func: ^ImGuiMemAllocFunc, p_free_func: ^ImGuiMemFreeFunc, p_user_data: ^rawptr) ---
	ImGui_MemAlloc :: proc(size: c.size_t) -> rawptr ---
	ImGui_MemFree :: proc(ptr: rawptr) ---
	ImGui_UpdatePlatformWindows :: proc() ---
	ImGui_RenderPlatformWindowsDefault :: proc() ---
	ImGui_RenderPlatformWindowsDefaultEx :: proc(platform_render_arg: rawptr, renderer_render_arg: rawptr) ---
	ImGui_DestroyPlatformWindows :: proc() ---
	ImGui_FindViewportByID :: proc(viewport_id: ImGuiID) -> ^ImGuiViewport ---
	ImGui_FindViewportByPlatformHandle :: proc(platform_handle: rawptr) -> ^ImGuiViewport ---
	ImVector_Construct :: proc(vector: rawptr) ---
	ImVector_Destruct :: proc(vector: rawptr) ---
	ImGuiPlatformIO_SetPlatform_GetWindowWorkAreaInsets :: proc(getWindowWorkAreaInsetsFunc: proc "c" (vp: ^ImGuiViewport, result: ^ImVec4)) ---
	ImGuiPlatformIO_SetPlatform_GetWindowFramebufferScale :: proc(getWindowFramebufferScaleFunc: proc "c" (vp: ^ImGuiViewport, result: ^ImVec2)) ---
	ImGuiPlatformIO_SetPlatform_GetWindowPos :: proc(getWindowPosFunc: proc "c" (vp: ^ImGuiViewport, result: ^ImVec2)) ---
	ImGuiPlatformIO_SetPlatform_GetWindowSize :: proc(getWindowSizeFunc: proc "c" (vp: ^ImGuiViewport, result: ^ImVec2)) ---
	ImGuiStyle_ScaleAllSizes :: proc(self: ^ImGuiStyle, scale_factor: f32) ---
	ImGuiIO_AddKeyEvent :: proc(self: ^ImGuiIO, key: ImGuiKey, down: bool) ---
	ImGuiIO_AddKeyAnalogEvent :: proc(self: ^ImGuiIO, key: ImGuiKey, down: bool, v: f32) ---
	ImGuiIO_AddMousePosEvent :: proc(self: ^ImGuiIO, x: f32, y: f32) ---
	ImGuiIO_AddMouseButtonEvent :: proc(self: ^ImGuiIO, button: c.int, down: bool) ---
	ImGuiIO_AddMouseWheelEvent :: proc(self: ^ImGuiIO, wheel_x: f32, wheel_y: f32) ---
	ImGuiIO_AddMouseSourceEvent :: proc(self: ^ImGuiIO, source: ImGuiMouseSource) ---
	ImGuiIO_AddMouseViewportEvent :: proc(self: ^ImGuiIO, id: ImGuiID) ---
	ImGuiIO_AddFocusEvent :: proc(self: ^ImGuiIO, focused: bool) ---
	ImGuiIO_AddInputCharacter :: proc(self: ^ImGuiIO, c_: c.uint) ---
	ImGuiIO_AddInputCharacterUTF16 :: proc(self: ^ImGuiIO, c_: ImWchar16) ---
	ImGuiIO_AddInputCharactersUTF8 :: proc(self: ^ImGuiIO, str: cstring) ---
	ImGuiIO_SetKeyEventNativeData :: proc(self: ^ImGuiIO, key: ImGuiKey, native_keycode: c.int, native_scancode: c.int) ---
	ImGuiIO_SetKeyEventNativeDataEx :: proc(self: ^ImGuiIO, key: ImGuiKey, native_keycode: c.int, native_scancode: c.int, native_legacy_index: c.int) ---
	ImGuiIO_SetAppAcceptingEvents :: proc(self: ^ImGuiIO, accepting_events: bool) ---
	ImGuiIO_ClearEventsQueue :: proc(self: ^ImGuiIO) ---
	ImGuiIO_ClearInputKeys :: proc(self: ^ImGuiIO) ---
	ImGuiIO_ClearInputMouse :: proc(self: ^ImGuiIO) ---
	ImGuiInputTextCallbackData_DeleteChars :: proc(self: ^ImGuiInputTextCallbackData, pos: c.int, bytes_count: c.int) ---
	ImGuiInputTextCallbackData_InsertChars :: proc(self: ^ImGuiInputTextCallbackData, pos: c.int, text: cstring, text_end: cstring) ---
	ImGuiInputTextCallbackData_SelectAll :: proc(self: ^ImGuiInputTextCallbackData) ---
	ImGuiInputTextCallbackData_SetSelection :: proc(self: ^ImGuiInputTextCallbackData, s: c.int, e: c.int) ---
	ImGuiInputTextCallbackData_ClearSelection :: proc(self: ^ImGuiInputTextCallbackData) ---
	ImGuiInputTextCallbackData_HasSelection :: proc(self: ^ImGuiInputTextCallbackData) -> bool ---
	ImGuiPayload_Clear :: proc(self: ^ImGuiPayload) ---
	ImGuiPayload_IsDataType :: proc(self: ^ImGuiPayload, type: cstring) -> bool ---
	ImGuiPayload_IsPreview :: proc(self: ^ImGuiPayload) -> bool ---
	ImGuiPayload_IsDelivery :: proc(self: ^ImGuiPayload) -> bool ---
	ImGuiTextFilter_ImGuiTextRange_empty :: proc(self: ^ImGuiTextFilter_ImGuiTextRange) -> bool ---
	ImGuiTextFilter_ImGuiTextRange_split :: proc(self: ^ImGuiTextFilter_ImGuiTextRange, separator: c.char, out: ^ImVector_ImGuiTextRange) ---
	ImGuiTextFilter_Draw :: proc(self: ^ImGuiTextFilter, label: cstring, width: f32) -> bool ---
	ImGuiTextFilter_PassFilter :: proc(self: ^ImGuiTextFilter, text: cstring, text_end: cstring) -> bool ---
	ImGuiTextFilter_Build :: proc(self: ^ImGuiTextFilter) ---
	ImGuiTextFilter_Clear :: proc(self: ^ImGuiTextFilter) ---
	ImGuiTextFilter_IsActive :: proc(self: ^ImGuiTextFilter) -> bool ---
	ImGuiTextBuffer_begin :: proc(self: ^ImGuiTextBuffer) -> cstring ---
	ImGuiTextBuffer_end :: proc(self: ^ImGuiTextBuffer) -> cstring ---
	ImGuiTextBuffer_size :: proc(self: ^ImGuiTextBuffer) -> c.int ---
	ImGuiTextBuffer_empty :: proc(self: ^ImGuiTextBuffer) -> bool ---
	ImGuiTextBuffer_clear :: proc(self: ^ImGuiTextBuffer) ---
	ImGuiTextBuffer_resize :: proc(self: ^ImGuiTextBuffer, size: c.int) ---
	ImGuiTextBuffer_reserve :: proc(self: ^ImGuiTextBuffer, capacity: c.int) ---
	ImGuiTextBuffer_c_str :: proc(self: ^ImGuiTextBuffer) -> cstring ---
	ImGuiTextBuffer_append :: proc(self: ^ImGuiTextBuffer, str: cstring, str_end: cstring) ---
	ImGuiTextBuffer_appendf :: proc(self: ^ImGuiTextBuffer, fmt: cstring, #c_vararg args: ..any) ---
	ImGuiTextBuffer_appendfv :: proc(self: ^ImGuiTextBuffer, fmt: cstring, args: c.va_list) ---
	ImGuiStorage_Clear :: proc(self: ^ImGuiStorage) ---
	ImGuiStorage_GetInt :: proc(self: ^ImGuiStorage, key: ImGuiID, default_val: c.int) -> c.int ---
	ImGuiStorage_SetInt :: proc(self: ^ImGuiStorage, key: ImGuiID, val: c.int) ---
	ImGuiStorage_GetBool :: proc(self: ^ImGuiStorage, key: ImGuiID, default_val: bool) -> bool ---
	ImGuiStorage_SetBool :: proc(self: ^ImGuiStorage, key: ImGuiID, val: bool) ---
	ImGuiStorage_GetFloat :: proc(self: ^ImGuiStorage, key: ImGuiID, default_val: f32) -> f32 ---
	ImGuiStorage_SetFloat :: proc(self: ^ImGuiStorage, key: ImGuiID, val: f32) ---
	ImGuiStorage_GetVoidPtr :: proc(self: ^ImGuiStorage, key: ImGuiID) -> rawptr ---
	ImGuiStorage_SetVoidPtr :: proc(self: ^ImGuiStorage, key: ImGuiID, val: rawptr) ---
	ImGuiStorage_GetIntRef :: proc(self: ^ImGuiStorage, key: ImGuiID, default_val: c.int) -> ^c.int ---
	ImGuiStorage_GetBoolRef :: proc(self: ^ImGuiStorage, key: ImGuiID, default_val: bool) -> ^bool ---
	ImGuiStorage_GetFloatRef :: proc(self: ^ImGuiStorage, key: ImGuiID, default_val: f32) -> ^f32 ---
	ImGuiStorage_GetVoidPtrRef :: proc(self: ^ImGuiStorage, key: ImGuiID, default_val: rawptr) -> ^rawptr ---
	ImGuiStorage_BuildSortByKey :: proc(self: ^ImGuiStorage) ---
	ImGuiStorage_SetAllInt :: proc(self: ^ImGuiStorage, val: c.int) ---
	ImGuiListClipper_Begin :: proc(self: ^ImGuiListClipper, items_count: c.int, items_height: f32) ---
	ImGuiListClipper_End :: proc(self: ^ImGuiListClipper) ---
	ImGuiListClipper_Step :: proc(self: ^ImGuiListClipper) -> bool ---
	ImGuiListClipper_IncludeItemByIndex :: proc(self: ^ImGuiListClipper, item_index: c.int) ---
	ImGuiListClipper_IncludeItemsByIndex :: proc(self: ^ImGuiListClipper, item_begin: c.int, item_end: c.int) ---
	ImGuiListClipper_SeekCursorForItem :: proc(self: ^ImGuiListClipper, item_index: c.int) ---
	ImColor_SetHSV :: proc(self: ^ImColor, h: f32, s: f32, v: f32, a: f32) ---
	ImColor_HSV :: proc(h: f32, s: f32, v: f32, a: f32) -> ImColor ---
	ImGuiSelectionBasicStorage_ApplyRequests :: proc(self: ^ImGuiSelectionBasicStorage, ms_io: ^ImGuiMultiSelectIO) ---
	ImGuiSelectionBasicStorage_Contains :: proc(self: ^ImGuiSelectionBasicStorage, id: ImGuiID) -> bool ---
	ImGuiSelectionBasicStorage_Clear :: proc(self: ^ImGuiSelectionBasicStorage) ---
	ImGuiSelectionBasicStorage_Swap :: proc(self: ^ImGuiSelectionBasicStorage, r: ^ImGuiSelectionBasicStorage) ---
	ImGuiSelectionBasicStorage_SetItemSelected :: proc(self: ^ImGuiSelectionBasicStorage, id: ImGuiID, selected: bool) ---
	ImGuiSelectionBasicStorage_GetNextSelectedItem :: proc(self: ^ImGuiSelectionBasicStorage, opaque_it: ^rawptr, out_id: ^ImGuiID) -> bool ---
	ImGuiSelectionBasicStorage_GetStorageIdFromIndex :: proc(self: ^ImGuiSelectionBasicStorage, idx: c.int) -> ImGuiID ---
	ImGuiSelectionExternalStorage_ApplyRequests :: proc(self: ^ImGuiSelectionExternalStorage, ms_io: ^ImGuiMultiSelectIO) ---
	ImDrawCmd_GetTexID :: proc(self: ^ImDrawCmd) -> ImTextureID ---
	ImDrawListSplitter_Clear :: proc(self: ^ImDrawListSplitter) ---
	ImDrawListSplitter_ClearFreeMemory :: proc(self: ^ImDrawListSplitter) ---
	ImDrawListSplitter_Split :: proc(self: ^ImDrawListSplitter, draw_list: ^ImDrawList, count: c.int) ---
	ImDrawListSplitter_Merge :: proc(self: ^ImDrawListSplitter, draw_list: ^ImDrawList) ---
	ImDrawListSplitter_SetCurrentChannel :: proc(self: ^ImDrawListSplitter, draw_list: ^ImDrawList, channel_idx: c.int) ---
	ImDrawList_PushClipRect :: proc(self: ^ImDrawList, clip_rect_min: ImVec2, clip_rect_max: ImVec2, intersect_with_current_clip_rect: bool) ---
	ImDrawList_PushClipRectFullScreen :: proc(self: ^ImDrawList) ---
	ImDrawList_PopClipRect :: proc(self: ^ImDrawList) ---
	ImDrawList_PushTexture :: proc(self: ^ImDrawList, tex_ref: ImTextureRef) ---
	ImDrawList_PopTexture :: proc(self: ^ImDrawList) ---
	ImDrawList_GetClipRectMin :: proc(self: ^ImDrawList) -> ImVec2 ---
	ImDrawList_GetClipRectMax :: proc(self: ^ImDrawList) -> ImVec2 ---
	ImDrawList_AddLine :: proc(self: ^ImDrawList, p1: ImVec2, p2: ImVec2, col: ImU32) ---
	ImDrawList_AddLineEx :: proc(self: ^ImDrawList, p1: ImVec2, p2: ImVec2, col: ImU32, thickness: f32) ---
	ImDrawList_AddLineH :: proc(self: ^ImDrawList, min_x: f32, max_x: f32, y: f32, col: ImU32) ---
	ImDrawList_AddLineHEx :: proc(self: ^ImDrawList, min_x: f32, max_x: f32, y: f32, col: ImU32, thickness: f32) ---
	ImDrawList_AddLineV :: proc(self: ^ImDrawList, x: f32, min_y: f32, max_y: f32, col: ImU32) ---
	ImDrawList_AddLineVEx :: proc(self: ^ImDrawList, x: f32, min_y: f32, max_y: f32, col: ImU32, thickness: f32) ---
	ImDrawList_AddRect :: proc(self: ^ImDrawList, p_min: ImVec2, p_max: ImVec2, col: ImU32) ---
	ImDrawList_AddRectEx :: proc(self: ^ImDrawList, p_min: ImVec2, p_max: ImVec2, col: ImU32, rounding: f32, thickness: f32, flags: ImDrawFlags) ---
	ImDrawList_AddRectFilled :: proc(self: ^ImDrawList, p_min: ImVec2, p_max: ImVec2, col: ImU32) ---
	ImDrawList_AddRectFilledEx :: proc(self: ^ImDrawList, p_min: ImVec2, p_max: ImVec2, col: ImU32, rounding: f32, flags: ImDrawFlags) ---
	ImDrawList_AddRectFilledMultiColor :: proc(self: ^ImDrawList, p_min: ImVec2, p_max: ImVec2, col_upr_left: ImU32, col_upr_right: ImU32, col_bot_right: ImU32, col_bot_left: ImU32) ---
	ImDrawList_AddQuad :: proc(self: ^ImDrawList, p1: ImVec2, p2: ImVec2, p3: ImVec2, p4: ImVec2, col: ImU32) ---
	ImDrawList_AddQuadEx :: proc(self: ^ImDrawList, p1: ImVec2, p2: ImVec2, p3: ImVec2, p4: ImVec2, col: ImU32, thickness: f32) ---
	ImDrawList_AddQuadFilled :: proc(self: ^ImDrawList, p1: ImVec2, p2: ImVec2, p3: ImVec2, p4: ImVec2, col: ImU32) ---
	ImDrawList_AddTriangle :: proc(self: ^ImDrawList, p1: ImVec2, p2: ImVec2, p3: ImVec2, col: ImU32) ---
	ImDrawList_AddTriangleEx :: proc(self: ^ImDrawList, p1: ImVec2, p2: ImVec2, p3: ImVec2, col: ImU32, thickness: f32) ---
	ImDrawList_AddTriangleFilled :: proc(self: ^ImDrawList, p1: ImVec2, p2: ImVec2, p3: ImVec2, col: ImU32) ---
	ImDrawList_AddCircle :: proc(self: ^ImDrawList, center: ImVec2, radius: f32, col: ImU32) ---
	ImDrawList_AddCircleEx :: proc(self: ^ImDrawList, center: ImVec2, radius: f32, col: ImU32, num_segments: c.int, thickness: f32) ---
	ImDrawList_AddCircleFilled :: proc(self: ^ImDrawList, center: ImVec2, radius: f32, col: ImU32, num_segments: c.int) ---
	ImDrawList_AddNgon :: proc(self: ^ImDrawList, center: ImVec2, radius: f32, col: ImU32, num_segments: c.int) ---
	ImDrawList_AddNgonEx :: proc(self: ^ImDrawList, center: ImVec2, radius: f32, col: ImU32, num_segments: c.int, thickness: f32) ---
	ImDrawList_AddNgonFilled :: proc(self: ^ImDrawList, center: ImVec2, radius: f32, col: ImU32, num_segments: c.int) ---
	ImDrawList_AddEllipse :: proc(self: ^ImDrawList, center: ImVec2, radius: ImVec2, col: ImU32) ---
	ImDrawList_AddEllipseEx :: proc(self: ^ImDrawList, center: ImVec2, radius: ImVec2, col: ImU32, rot: f32, num_segments: c.int, thickness: f32) ---
	ImDrawList_AddEllipseFilled :: proc(self: ^ImDrawList, center: ImVec2, radius: ImVec2, col: ImU32) ---
	ImDrawList_AddEllipseFilledEx :: proc(self: ^ImDrawList, center: ImVec2, radius: ImVec2, col: ImU32, rot: f32, num_segments: c.int) ---
	ImDrawList_AddText :: proc(self: ^ImDrawList, pos: ImVec2, col: ImU32, text_begin: cstring) ---
	ImDrawList_AddTextEx :: proc(self: ^ImDrawList, pos: ImVec2, col: ImU32, text_begin: cstring, text_end: cstring) ---
	ImDrawList_AddTextImFontPtr :: proc(self: ^ImDrawList, font: ^ImFont, font_size: f32, pos: ImVec2, col: ImU32, text_begin: cstring) ---
	ImDrawList_AddTextImFontPtrEx :: proc(self: ^ImDrawList, font: ^ImFont, font_size: f32, pos: ImVec2, col: ImU32, text_begin: cstring, text_end: cstring, wrap_width: f32, cpu_fine_clip_rect: ^ImVec4) ---
	ImDrawList_AddBezierCubic :: proc(self: ^ImDrawList, p1: ImVec2, p2: ImVec2, p3: ImVec2, p4: ImVec2, col: ImU32, thickness: f32, num_segments: c.int) ---
	ImDrawList_AddBezierQuadratic :: proc(self: ^ImDrawList, p1: ImVec2, p2: ImVec2, p3: ImVec2, col: ImU32, thickness: f32, num_segments: c.int) ---
	ImDrawList_AddPolyline :: proc(self: ^ImDrawList, points: ^ImVec2, num_points: c.int, col: ImU32, thickness: f32, flags: ImDrawFlags) ---
	ImDrawList_AddConvexPolyFilled :: proc(self: ^ImDrawList, points: ^ImVec2, num_points: c.int, col: ImU32) ---
	ImDrawList_AddConcavePolyFilled :: proc(self: ^ImDrawList, points: ^ImVec2, num_points: c.int, col: ImU32) ---
	ImDrawList_AddImage :: proc(self: ^ImDrawList, tex_ref: ImTextureRef, p_min: ImVec2, p_max: ImVec2) ---
	ImDrawList_AddImageEx :: proc(self: ^ImDrawList, tex_ref: ImTextureRef, p_min: ImVec2, p_max: ImVec2, uv_min: ImVec2, uv_max: ImVec2, col: ImU32) ---
	ImDrawList_AddImageQuad :: proc(self: ^ImDrawList, tex_ref: ImTextureRef, p1: ImVec2, p2: ImVec2, p3: ImVec2, p4: ImVec2) ---
	ImDrawList_AddImageQuadEx :: proc(self: ^ImDrawList, tex_ref: ImTextureRef, p1: ImVec2, p2: ImVec2, p3: ImVec2, p4: ImVec2, uv1: ImVec2, uv2: ImVec2, uv3: ImVec2, uv4: ImVec2, col: ImU32) ---
	ImDrawList_AddImageRounded :: proc(self: ^ImDrawList, tex_ref: ImTextureRef, p_min: ImVec2, p_max: ImVec2, uv_min: ImVec2, uv_max: ImVec2, col: ImU32, rounding: f32, flags: ImDrawFlags) ---
	ImDrawList_PathClear :: proc(self: ^ImDrawList) ---
	ImDrawList_PathLineTo :: proc(self: ^ImDrawList, pos: ImVec2) ---
	ImDrawList_PathLineToMergeDuplicate :: proc(self: ^ImDrawList, pos: ImVec2) ---
	ImDrawList_PathFillConvex :: proc(self: ^ImDrawList, col: ImU32) ---
	ImDrawList_PathFillConcave :: proc(self: ^ImDrawList, col: ImU32) ---
	ImDrawList_PathStroke :: proc(self: ^ImDrawList, col: ImU32, thickness: f32, flags: ImDrawFlags) ---
	ImDrawList_PathArcTo :: proc(self: ^ImDrawList, center: ImVec2, radius: f32, a_min: f32, a_max: f32, num_segments: c.int) ---
	ImDrawList_PathArcToFast :: proc(self: ^ImDrawList, center: ImVec2, radius: f32, a_min_of_12: c.int, a_max_of_12: c.int) ---
	ImDrawList_PathEllipticalArcTo :: proc(self: ^ImDrawList, center: ImVec2, radius: ImVec2, rot: f32, a_min: f32, a_max: f32) ---
	ImDrawList_PathEllipticalArcToEx :: proc(self: ^ImDrawList, center: ImVec2, radius: ImVec2, rot: f32, a_min: f32, a_max: f32, num_segments: c.int) ---
	ImDrawList_PathBezierCubicCurveTo :: proc(self: ^ImDrawList, p2: ImVec2, p3: ImVec2, p4: ImVec2, num_segments: c.int) ---
	ImDrawList_PathBezierQuadraticCurveTo :: proc(self: ^ImDrawList, p2: ImVec2, p3: ImVec2, num_segments: c.int) ---
	ImDrawList_PathRect :: proc(self: ^ImDrawList, rect_min: ImVec2, rect_max: ImVec2, rounding: f32, flags: ImDrawFlags) ---
	ImDrawList_AddCallback :: proc(self: ^ImDrawList, callback: ImDrawCallback) ---
	ImDrawList_AddCallbackEx :: proc(self: ^ImDrawList, callback: ImDrawCallback, userdata: rawptr, userdata_size: c.size_t) ---
	ImDrawList_AddDrawCmd :: proc(self: ^ImDrawList) ---
	ImDrawList_CloneOutput :: proc(self: ^ImDrawList) -> ^ImDrawList ---
	ImDrawList_ChannelsSplit :: proc(self: ^ImDrawList, count: c.int) ---
	ImDrawList_ChannelsMerge :: proc(self: ^ImDrawList) ---
	ImDrawList_ChannelsSetCurrent :: proc(self: ^ImDrawList, n: c.int) ---
	ImDrawList_PrimReserve :: proc(self: ^ImDrawList, idx_count: c.int, vtx_count: c.int) ---
	ImDrawList_PrimUnreserve :: proc(self: ^ImDrawList, idx_count: c.int, vtx_count: c.int) ---
	ImDrawList_PrimRect :: proc(self: ^ImDrawList, a: ImVec2, b: ImVec2, col: ImU32) ---
	ImDrawList_PrimRectUV :: proc(self: ^ImDrawList, a: ImVec2, b: ImVec2, uv_a: ImVec2, uv_b: ImVec2, col: ImU32) ---
	ImDrawList_PrimQuadUV :: proc(self: ^ImDrawList, a: ImVec2, b: ImVec2, c_: ImVec2, d: ImVec2, uv_a: ImVec2, uv_b: ImVec2, uv_c: ImVec2, uv_d: ImVec2, col: ImU32) ---
	ImDrawList_PrimWriteVtx :: proc(self: ^ImDrawList, pos: ImVec2, uv: ImVec2, col: ImU32) ---
	ImDrawList_PrimWriteIdx :: proc(self: ^ImDrawList, idx: ImDrawIdx) ---
	ImDrawList_PrimVtx :: proc(self: ^ImDrawList, pos: ImVec2, uv: ImVec2, col: ImU32) ---
	ImDrawList_AddRectImDrawFlags :: proc(self: ^ImDrawList, p_min: ImVec2, p_max: ImVec2, col: ImU32, rounding: f32, flags: ImDrawFlags, thickness: f32) ---
	ImDrawList_AddPolylineImDrawFlags :: proc(self: ^ImDrawList, points: ^ImVec2, num_points: c.int, col: ImU32, flags: ImDrawFlags, thickness: f32) ---
	ImDrawList_PathStrokeImDrawFlags :: proc(self: ^ImDrawList, col: ImU32, flags: ImDrawFlags, thickness: f32) ---
	ImDrawList_PushTextureID :: proc(self: ^ImDrawList, tex_ref: ImTextureRef) ---
	ImDrawList_PopTextureID :: proc(self: ^ImDrawList) ---
	ImDrawList__SetDrawListSharedData :: proc(self: ^ImDrawList, data: ^ImDrawListSharedData) ---
	ImDrawList__ResetForNewFrame :: proc(self: ^ImDrawList) ---
	ImDrawList__ClearFreeMemory :: proc(self: ^ImDrawList) ---
	ImDrawList__PopUnusedDrawCmd :: proc(self: ^ImDrawList) ---
	ImDrawList__TryMergeDrawCmds :: proc(self: ^ImDrawList) ---
	ImDrawList__OnChangedClipRect :: proc(self: ^ImDrawList) ---
	ImDrawList__OnChangedTexture :: proc(self: ^ImDrawList) ---
	ImDrawList__OnChangedVtxOffset :: proc(self: ^ImDrawList) ---
	ImDrawList__SetTexture :: proc(self: ^ImDrawList, tex_ref: ImTextureRef) ---
	ImDrawList__CalcCircleAutoSegmentCount :: proc(self: ^ImDrawList, radius: f32) -> c.int ---
	ImDrawList__PathArcToFastEx :: proc(self: ^ImDrawList, center: ImVec2, radius: f32, a_min_sample: c.int, a_max_sample: c.int, a_step: c.int) ---
	ImDrawList__PathArcToN :: proc(self: ^ImDrawList, center: ImVec2, radius: f32, a_min: f32, a_max: f32, num_segments: c.int) ---
	ImDrawData_Clear :: proc(self: ^ImDrawData) ---
	ImDrawData_AddDrawList :: proc(self: ^ImDrawData, draw_list: ^ImDrawList) ---
	ImDrawData_DeIndexAllBuffers :: proc(self: ^ImDrawData) ---
	ImDrawData_ScaleClipRects :: proc(self: ^ImDrawData, fb_scale: ImVec2) ---
	ImTextureData_Create :: proc(self: ^ImTextureData, format: ImTextureFormat, w: c.int, h: c.int) ---
	ImTextureData_DestroyPixels :: proc(self: ^ImTextureData) ---
	ImTextureData_GetPixels :: proc(self: ^ImTextureData) -> rawptr ---
	ImTextureData_GetPixelsAt :: proc(self: ^ImTextureData, x: c.int, y: c.int) -> rawptr ---
	ImTextureData_GetSizeInBytes :: proc(self: ^ImTextureData) -> c.int ---
	ImTextureData_GetPitch :: proc(self: ^ImTextureData) -> c.int ---
	ImTextureData_GetTexRef :: proc(self: ^ImTextureData) -> ImTextureRef ---
	ImTextureData_GetTexID :: proc(self: ^ImTextureData) -> ImTextureID ---
	ImTextureData_SetTexID :: proc(self: ^ImTextureData, tex_id: ImTextureID) ---
	ImTextureData_SetStatus :: proc(self: ^ImTextureData, status: ImTextureStatus) ---
	ImFontGlyphRangesBuilder_Clear :: proc(self: ^ImFontGlyphRangesBuilder) ---
	ImFontGlyphRangesBuilder_GetBit :: proc(self: ^ImFontGlyphRangesBuilder, n: c.size_t) -> bool ---
	ImFontGlyphRangesBuilder_SetBit :: proc(self: ^ImFontGlyphRangesBuilder, n: c.size_t) ---
	ImFontGlyphRangesBuilder_AddChar :: proc(self: ^ImFontGlyphRangesBuilder, c_: ImWchar) ---
	ImFontGlyphRangesBuilder_AddText :: proc(self: ^ImFontGlyphRangesBuilder, text: cstring, text_end: cstring) ---
	ImFontGlyphRangesBuilder_AddRanges :: proc(self: ^ImFontGlyphRangesBuilder, ranges: ^ImWchar) ---
	ImFontGlyphRangesBuilder_BuildRanges :: proc(self: ^ImFontGlyphRangesBuilder, out_ranges: ^ImVector_ImWchar) ---
	ImFontAtlas_AddFont :: proc(self: ^ImFontAtlas, font_cfg: ^ImFontConfig) -> ^ImFont ---
	ImFontAtlas_AddFontDefault :: proc(self: ^ImFontAtlas, font_cfg: ^ImFontConfig) -> ^ImFont ---
	ImFontAtlas_AddFontDefaultVector :: proc(self: ^ImFontAtlas, font_cfg: ^ImFontConfig) -> ^ImFont ---
	ImFontAtlas_AddFontDefaultBitmap :: proc(self: ^ImFontAtlas, font_cfg: ^ImFontConfig) -> ^ImFont ---
	ImFontAtlas_AddFontFromFileTTF :: proc(self: ^ImFontAtlas, filename: cstring, size_pixels: f32, font_cfg: ^ImFontConfig, glyph_ranges: ^ImWchar) -> ^ImFont ---
	ImFontAtlas_AddFontFromMemoryTTF :: proc(self: ^ImFontAtlas, font_data: rawptr, font_data_size: c.int, size_pixels: f32, font_cfg: ^ImFontConfig, glyph_ranges: ^ImWchar) -> ^ImFont ---
	ImFontAtlas_AddFontFromMemoryCompressedTTF :: proc(self: ^ImFontAtlas, compressed_font_data: rawptr, compressed_font_data_size: c.int, size_pixels: f32, font_cfg: ^ImFontConfig, glyph_ranges: ^ImWchar) -> ^ImFont ---
	ImFontAtlas_AddFontFromMemoryCompressedBase85TTF :: proc(self: ^ImFontAtlas, compressed_font_data_base85: cstring, size_pixels: f32, font_cfg: ^ImFontConfig, glyph_ranges: ^ImWchar) -> ^ImFont ---
	ImFontAtlas_RemoveFont :: proc(self: ^ImFontAtlas, font: ^ImFont) ---
	ImFontAtlas_Clear :: proc(self: ^ImFontAtlas) ---
	ImFontAtlas_ClearFonts :: proc(self: ^ImFontAtlas) ---
	ImFontAtlas_CompactCache :: proc(self: ^ImFontAtlas) ---
	ImFontAtlas_SetFontLoader :: proc(self: ^ImFontAtlas, font_loader: ^ImFontLoader) ---
	ImFontAtlas_ClearInputData :: proc(self: ^ImFontAtlas) ---
	ImFontAtlas_ClearTexData :: proc(self: ^ImFontAtlas) ---
	ImFontAtlas_Build :: proc(self: ^ImFontAtlas) -> bool ---
	ImFontAtlas_GetTexDataAsAlpha8 :: proc(self: ^ImFontAtlas, out_pixels: ^^u8, out_width: ^c.int, out_height: ^c.int, out_bytes_per_pixel: ^c.int) ---
	ImFontAtlas_GetTexDataAsRGBA32 :: proc(self: ^ImFontAtlas, out_pixels: ^^u8, out_width: ^c.int, out_height: ^c.int, out_bytes_per_pixel: ^c.int) ---
	ImFontAtlas_SetTexID :: proc(self: ^ImFontAtlas, id: ImTextureID) ---
	ImFontAtlas_SetTexIDImTextureRef :: proc(self: ^ImFontAtlas, id: ImTextureRef) ---
	ImFontAtlas_IsBuilt :: proc(self: ^ImFontAtlas) -> bool ---
	ImFontAtlas_GetGlyphRangesDefault :: proc(self: ^ImFontAtlas) -> ^ImWchar ---
	ImFontAtlas_GetGlyphRangesGreek :: proc(self: ^ImFontAtlas) -> ^ImWchar ---
	ImFontAtlas_GetGlyphRangesKorean :: proc(self: ^ImFontAtlas) -> ^ImWchar ---
	ImFontAtlas_GetGlyphRangesJapanese :: proc(self: ^ImFontAtlas) -> ^ImWchar ---
	ImFontAtlas_GetGlyphRangesChineseFull :: proc(self: ^ImFontAtlas) -> ^ImWchar ---
	ImFontAtlas_GetGlyphRangesChineseSimplifiedCommon :: proc(self: ^ImFontAtlas) -> ^ImWchar ---
	ImFontAtlas_GetGlyphRangesCyrillic :: proc(self: ^ImFontAtlas) -> ^ImWchar ---
	ImFontAtlas_GetGlyphRangesThai :: proc(self: ^ImFontAtlas) -> ^ImWchar ---
	ImFontAtlas_GetGlyphRangesVietnamese :: proc(self: ^ImFontAtlas) -> ^ImWchar ---
	ImFontAtlas_AddCustomRect :: proc(self: ^ImFontAtlas, width: c.int, height: c.int, out_r: ^ImFontAtlasRect) -> ImFontAtlasRectId ---
	ImFontAtlas_RemoveCustomRect :: proc(self: ^ImFontAtlas, id: ImFontAtlasRectId) ---
	ImFontAtlas_GetCustomRect :: proc(self: ^ImFontAtlas, id: ImFontAtlasRectId, out_r: ^ImFontAtlasRect) -> bool ---
	ImFontAtlas_AddCustomRectRegular :: proc(self: ^ImFontAtlas, w: c.int, h: c.int) -> ImFontAtlasRectId ---
	ImFontAtlas_GetCustomRectByIndex :: proc(self: ^ImFontAtlas, id: ImFontAtlasRectId) -> ^ImFontAtlasRect ---
	ImFontAtlas_CalcCustomRectUV :: proc(self: ^ImFontAtlas, r: ^ImFontAtlasRect, out_uv_min: ^ImVec2, out_uv_max: ^ImVec2) ---
	ImFontAtlas_AddCustomRectFontGlyph :: proc(self: ^ImFontAtlas, font: ^ImFont, codepoint: ImWchar, w: c.int, h: c.int, advance_x: f32, offset: ImVec2) -> ImFontAtlasRectId ---
	ImFontAtlas_AddCustomRectFontGlyphForSize :: proc(self: ^ImFontAtlas, font: ^ImFont, font_size: f32, codepoint: ImWchar, w: c.int, h: c.int, advance_x: f32, offset: ImVec2) -> ImFontAtlasRectId ---
	ImFontBaked_ClearOutputData :: proc(self: ^ImFontBaked) ---
	ImFontBaked_FindGlyph :: proc(self: ^ImFontBaked, c_: ImWchar) -> ^ImFontGlyph ---
	ImFontBaked_FindGlyphNoFallback :: proc(self: ^ImFontBaked, c_: ImWchar) -> ^ImFontGlyph ---
	ImFontBaked_GetCharAdvance :: proc(self: ^ImFontBaked, c_: ImWchar) -> f32 ---
	ImFontBaked_IsGlyphLoaded :: proc(self: ^ImFontBaked, c_: ImWchar) -> bool ---
	ImFont_IsGlyphInFont :: proc(self: ^ImFont, c_: ImWchar) -> bool ---
	ImFont_IsLoaded :: proc(self: ^ImFont) -> bool ---
	ImFont_GetDebugName :: proc(self: ^ImFont) -> cstring ---
	ImFont_GetFontBaked :: proc(self: ^ImFont, font_size: f32) -> ^ImFontBaked ---
	ImFont_GetFontBakedEx :: proc(self: ^ImFont, font_size: f32, density: f32) -> ^ImFontBaked ---
	ImFont_CalcTextSizeA :: proc(self: ^ImFont, size: f32, max_width: f32, wrap_width: f32, text_begin: cstring) -> ImVec2 ---
	ImFont_CalcTextSizeAEx :: proc(self: ^ImFont, size: f32, max_width: f32, wrap_width: f32, text_begin: cstring, text_end: cstring, out_remaining: ^cstring) -> ImVec2 ---
	ImFont_CalcWordWrapPosition :: proc(self: ^ImFont, size: f32, text: cstring, text_end: cstring, wrap_width: f32) -> cstring ---
	ImFont_RenderChar :: proc(self: ^ImFont, draw_list: ^ImDrawList, size: f32, pos: ImVec2, col: ImU32, c_: ImWchar) ---
	ImFont_RenderCharEx :: proc(self: ^ImFont, draw_list: ^ImDrawList, size: f32, pos: ImVec2, col: ImU32, c_: ImWchar, cpu_fine_clip: ^ImVec4) ---
	ImFont_RenderText :: proc(self: ^ImFont, draw_list: ^ImDrawList, size: f32, pos: ImVec2, col: ImU32, clip_rect: ImVec4, text_begin: cstring, text_end: cstring, wrap_width: f32, flags: ImDrawTextFlags) ---
	ImFont_CalcWordWrapPositionA :: proc(self: ^ImFont, scale: f32, text: cstring, text_end: cstring, wrap_width: f32) -> cstring ---
	ImFont_ClearOutputData :: proc(self: ^ImFont) ---
	ImFont_AddRemapChar :: proc(self: ^ImFont, from_codepoint: ImWchar, to_codepoint: ImWchar) ---
	ImFont_IsGlyphRangeUnused :: proc(self: ^ImFont, c_begin: c.uint, c_last: c.uint) -> bool ---
	ImGuiViewport_GetCenter :: proc(self: ^ImGuiViewport) -> ImVec2 ---
	ImGuiViewport_GetWorkCenter :: proc(self: ^ImGuiViewport) -> ImVec2 ---
	ImGuiViewport_GetDebugName :: proc(self: ^ImGuiViewport) -> cstring ---
	ImGuiPlatformIO_ClearPlatformHandlers :: proc(self: ^ImGuiPlatformIO) ---
	ImGuiPlatformIO_ClearRendererHandlers :: proc(self: ^ImGuiPlatformIO) ---
	ImGui_PushFont :: proc(font: ^ImFont) ---
	ImGui_SetWindowFontScale :: proc(scale: f32) ---
	ImGui_ImageImVec4 :: proc(tex_ref: ImTextureRef, image_size: ImVec2, uv0: ImVec2, uv1: ImVec2, tint_col: ImVec4, border_col: ImVec4) ---
	ImGui_PushButtonRepeat :: proc(repeat: bool) ---
	ImGui_PopButtonRepeat :: proc() ---
	ImGui_PushTabStop :: proc(tab_stop: bool) ---
	ImGui_PopTabStop :: proc() ---
	ImGui_GetContentRegionMax :: proc() -> ImVec2 ---
	ImGui_GetWindowContentRegionMin :: proc() -> ImVec2 ---
	ImGui_GetWindowContentRegionMax :: proc() -> ImVec2 ---
}
