// Auto-generated public wrappers. Do not edit by hand.
package imgui

import "core:c"

import "core:fmt"

im_texture_ref_get_tex_id :: proc(self: ^ImTextureRef) -> ImTextureID {
	return ImTextureRef_GetTexID(self)
}

create_context :: proc(shared_font_atlas: ^ImFontAtlas = nil) -> ^ImGuiContext {
	return ImGui_CreateContext(shared_font_atlas)
}

destroy_context :: proc(ctx: ^ImGuiContext = nil) {
	ImGui_DestroyContext(ctx)
}

get_current_context :: proc() -> ^ImGuiContext {
	return ImGui_GetCurrentContext()
}

set_current_context :: proc(ctx: ^ImGuiContext) {
	ImGui_SetCurrentContext(ctx)
}

get_io :: proc() -> ^ImGuiIO {
	return ImGui_GetIO()
}

get_platform_io :: proc() -> ^ImGuiPlatformIO {
	return ImGui_GetPlatformIO()
}

get_style :: proc() -> ^ImGuiStyle {
	return ImGui_GetStyle()
}

new_frame :: proc() {
	ImGui_NewFrame()
}

end_frame :: proc() {
	ImGui_EndFrame()
}

render :: proc() {
	ImGui_Render()
}

get_draw_data :: proc() -> ^ImDrawData {
	return ImGui_GetDrawData()
}

show_demo_window :: proc(p_open: ^bool = nil) {
	ImGui_ShowDemoWindow(p_open)
}

show_metrics_window :: proc(p_open: ^bool = nil) {
	ImGui_ShowMetricsWindow(p_open)
}

show_debug_log_window :: proc(p_open: ^bool = nil) {
	ImGui_ShowDebugLogWindow(p_open)
}

show_id_stack_tool_window :: proc(p_open: ^bool = nil) {
	ImGui_ShowIDStackToolWindowEx(p_open)
}

show_about_window :: proc(p_open: ^bool = nil) {
	ImGui_ShowAboutWindow(p_open)
}

show_style_editor :: proc(ref: ^ImGuiStyle = nil) {
	ImGui_ShowStyleEditor(ref)
}

show_style_selector :: proc(label: cstring) -> bool {
	return ImGui_ShowStyleSelector(label)
}

show_font_selector :: proc(label: cstring) {
	ImGui_ShowFontSelector(label)
}

show_user_guide :: proc() {
	ImGui_ShowUserGuide()
}

get_version :: proc() -> cstring {
	return ImGui_GetVersion()
}

style_colors_dark :: proc(dst: ^ImGuiStyle = nil) {
	ImGui_StyleColorsDark(dst)
}

style_colors_light :: proc(dst: ^ImGuiStyle = nil) {
	ImGui_StyleColorsLight(dst)
}

style_colors_classic :: proc(dst: ^ImGuiStyle = nil) {
	ImGui_StyleColorsClassic(dst)
}

begin :: proc(name: cstring, p_open: ^bool = nil, flags: ImGuiWindowFlags = 0) -> bool {
	return ImGui_Begin(name, p_open, flags)
}

end :: proc() {
	ImGui_End()
}

begin_child :: proc(str_id: cstring, size: ImVec2 = ImVec2{0, 0}, child_flags: ImGuiChildFlags = 0, window_flags: ImGuiWindowFlags = 0) -> bool {
	return ImGui_BeginChild(str_id, size, child_flags, window_flags)
}

end_child :: proc() {
	ImGui_EndChild()
}

is_window_appearing :: proc() -> bool {
	return ImGui_IsWindowAppearing()
}

is_window_collapsed :: proc() -> bool {
	return ImGui_IsWindowCollapsed()
}

is_window_focused :: proc(flags: ImGuiFocusedFlags = 0) -> bool {
	return ImGui_IsWindowFocused(flags)
}

is_window_hovered :: proc(flags: ImGuiHoveredFlags = 0) -> bool {
	return ImGui_IsWindowHovered(flags)
}

get_window_draw_list :: proc() -> ^ImDrawList {
	return ImGui_GetWindowDrawList()
}

get_window_dpi_scale :: proc() -> f32 {
	return ImGui_GetWindowDpiScale()
}

get_window_pos :: proc() -> ImVec2 {
	return ImGui_GetWindowPos()
}

get_window_size :: proc() -> ImVec2 {
	return ImGui_GetWindowSize()
}

get_window_width :: proc() -> f32 {
	return ImGui_GetWindowWidth()
}

get_window_height :: proc() -> f32 {
	return ImGui_GetWindowHeight()
}

get_window_viewport :: proc() -> ^ImGuiViewport {
	return ImGui_GetWindowViewport()
}

set_next_window_pos :: proc(pos: ImVec2, cond: ImGuiCond = 0, pivot: ImVec2 = ImVec2{0, 0}) {
	ImGui_SetNextWindowPosEx(pos, cond, pivot)
}

set_next_window_size :: proc(size: ImVec2, cond: ImGuiCond = 0) {
	ImGui_SetNextWindowSize(size, cond)
}

set_next_window_size_constraints :: proc(size_min: ImVec2, size_max: ImVec2, custom_callback: ImGuiSizeCallback = nil, custom_callback_data: rawptr = nil) {
	ImGui_SetNextWindowSizeConstraints(size_min, size_max, custom_callback, custom_callback_data)
}

set_next_window_content_size :: proc(size: ImVec2) {
	ImGui_SetNextWindowContentSize(size)
}

set_next_window_collapsed :: proc(collapsed: bool, cond: ImGuiCond = 0) {
	ImGui_SetNextWindowCollapsed(collapsed, cond)
}

set_next_window_focus :: proc() {
	ImGui_SetNextWindowFocus()
}

set_next_window_scroll :: proc(scroll: ImVec2) {
	ImGui_SetNextWindowScroll(scroll)
}

set_next_window_bg_alpha :: proc(alpha: f32) {
	ImGui_SetNextWindowBgAlpha(alpha)
}

set_next_window_viewport :: proc(viewport_id: ImGuiID) {
	ImGui_SetNextWindowViewport(viewport_id)
}

set_window_pos_str :: proc(name: cstring, pos: ImVec2, cond: ImGuiCond = 0) {
	ImGui_SetWindowPosStr(name, pos, cond)
}

set_window_size_str :: proc(name: cstring, size: ImVec2, cond: ImGuiCond = 0) {
	ImGui_SetWindowSizeStr(name, size, cond)
}

set_window_collapsed_str :: proc(name: cstring, collapsed: bool, cond: ImGuiCond = 0) {
	ImGui_SetWindowCollapsedStr(name, collapsed, cond)
}

set_window_focus_str :: proc(name: cstring) {
	ImGui_SetWindowFocusStr(name)
}

get_scroll_x :: proc() -> f32 {
	return ImGui_GetScrollX()
}

get_scroll_y :: proc() -> f32 {
	return ImGui_GetScrollY()
}

set_scroll_x :: proc(scroll_x: f32) {
	ImGui_SetScrollX(scroll_x)
}

set_scroll_y :: proc(scroll_y: f32) {
	ImGui_SetScrollY(scroll_y)
}

get_scroll_max_x :: proc() -> f32 {
	return ImGui_GetScrollMaxX()
}

get_scroll_max_y :: proc() -> f32 {
	return ImGui_GetScrollMaxY()
}

set_scroll_here_x :: proc(center_x_ratio: f32 = 0.5) {
	ImGui_SetScrollHereX(center_x_ratio)
}

set_scroll_here_y :: proc(center_y_ratio: f32 = 0.5) {
	ImGui_SetScrollHereY(center_y_ratio)
}

set_scroll_from_pos_x :: proc(local_x: f32, center_x_ratio: f32 = 0.5) {
	ImGui_SetScrollFromPosX(local_x, center_x_ratio)
}

set_scroll_from_pos_y :: proc(local_y: f32, center_y_ratio: f32 = 0.5) {
	ImGui_SetScrollFromPosY(local_y, center_y_ratio)
}

push_font_float :: proc(font: ^ImFont, font_size_base_unscaled: f32) {
	ImGui_PushFontFloat(font, font_size_base_unscaled)
}

pop_font :: proc() {
	ImGui_PopFont()
}

get_font :: proc() -> ^ImFont {
	return ImGui_GetFont()
}

get_font_size :: proc() -> f32 {
	return ImGui_GetFontSize()
}

get_font_baked :: proc() -> ^ImFontBaked {
	return ImGui_GetFontBaked()
}

push_style_color :: proc(idx: ImGuiCol, col: ImU32) {
	ImGui_PushStyleColor(idx, col)
}

pop_style_color :: proc(count: c.int = 1) {
	ImGui_PopStyleColorEx(count)
}

push_style_var :: proc(idx: ImGuiStyleVar, val: f32) {
	ImGui_PushStyleVar(idx, val)
}

push_style_var_x :: proc(idx: ImGuiStyleVar, val_x: f32) {
	ImGui_PushStyleVarX(idx, val_x)
}

push_style_var_y :: proc(idx: ImGuiStyleVar, val_y: f32) {
	ImGui_PushStyleVarY(idx, val_y)
}

pop_style_var :: proc(count: c.int = 1) {
	ImGui_PopStyleVarEx(count)
}

push_item_flag :: proc(option: ImGuiItemFlags, enabled: bool) {
	ImGui_PushItemFlag(option, enabled)
}

pop_item_flag :: proc() {
	ImGui_PopItemFlag()
}

push_item_width :: proc(item_width: f32) {
	ImGui_PushItemWidth(item_width)
}

pop_item_width :: proc() {
	ImGui_PopItemWidth()
}

set_next_item_width :: proc(item_width: f32) {
	ImGui_SetNextItemWidth(item_width)
}

calc_item_width :: proc() -> f32 {
	return ImGui_CalcItemWidth()
}

push_text_wrap_pos :: proc(wrap_local_pos_x: f32 = 0.0) {
	ImGui_PushTextWrapPos(wrap_local_pos_x)
}

pop_text_wrap_pos :: proc() {
	ImGui_PopTextWrapPos()
}

get_font_tex_uv_white_pixel :: proc() -> ImVec2 {
	return ImGui_GetFontTexUvWhitePixel()
}

get_color_u32 :: proc(idx: ImGuiCol, alpha_mul: f32 = 1.0) -> ImU32 {
	return ImGui_GetColorU32Ex(idx, alpha_mul)
}

get_style_color_vec4 :: proc(idx: ImGuiCol) -> ^ImVec4 {
	return ImGui_GetStyleColorVec4(idx)
}

get_cursor_screen_pos :: proc() -> ImVec2 {
	return ImGui_GetCursorScreenPos()
}

set_cursor_screen_pos :: proc(pos: ImVec2) {
	ImGui_SetCursorScreenPos(pos)
}

get_content_region_avail :: proc() -> ImVec2 {
	return ImGui_GetContentRegionAvail()
}

get_cursor_pos :: proc() -> ImVec2 {
	return ImGui_GetCursorPos()
}

get_cursor_pos_x :: proc() -> f32 {
	return ImGui_GetCursorPosX()
}

get_cursor_pos_y :: proc() -> f32 {
	return ImGui_GetCursorPosY()
}

set_cursor_pos :: proc(local_pos: ImVec2) {
	ImGui_SetCursorPos(local_pos)
}

set_cursor_pos_x :: proc(local_x: f32) {
	ImGui_SetCursorPosX(local_x)
}

set_cursor_pos_y :: proc(local_y: f32) {
	ImGui_SetCursorPosY(local_y)
}

get_cursor_start_pos :: proc() -> ImVec2 {
	return ImGui_GetCursorStartPos()
}

separator :: proc() {
	ImGui_Separator()
}

same_line :: proc(offset_from_start_x: f32 = 0.0, spacing: f32 = -1.0) {
	ImGui_SameLineEx(offset_from_start_x, spacing)
}

new_line :: proc() {
	ImGui_NewLine()
}

spacing :: proc() {
	ImGui_Spacing()
}

dummy :: proc(size: ImVec2) {
	ImGui_Dummy(size)
}

indent :: proc(indent_w: f32 = 0.0) {
	ImGui_IndentEx(indent_w)
}

unindent :: proc(indent_w: f32 = 0.0) {
	ImGui_UnindentEx(indent_w)
}

begin_group :: proc() {
	ImGui_BeginGroup()
}

end_group :: proc() {
	ImGui_EndGroup()
}

align_text_to_frame_padding :: proc() {
	ImGui_AlignTextToFramePadding()
}

get_text_line_height :: proc() -> f32 {
	return ImGui_GetTextLineHeight()
}

get_text_line_height_with_spacing :: proc() -> f32 {
	return ImGui_GetTextLineHeightWithSpacing()
}

get_frame_height :: proc() -> f32 {
	return ImGui_GetFrameHeight()
}

get_frame_height_with_spacing :: proc() -> f32 {
	return ImGui_GetFrameHeightWithSpacing()
}

push_id_str :: proc(str_id_begin: cstring, str_id_end: cstring) {
	ImGui_PushIDStr(str_id_begin, str_id_end)
}

pop_id :: proc() {
	ImGui_PopID()
}

get_id_str :: proc(str_id_begin: cstring, str_id_end: cstring) -> ImGuiID {
	return ImGui_GetIDStr(str_id_begin, str_id_end)
}

text_unformatted :: proc(text: cstring, text_end: cstring = nil) {
	ImGui_TextUnformattedEx(text, text_end)
}

text_v :: proc(fmt: cstring, args: c.va_list) {
	ImGui_TextV(fmt, args)
}

text_colored_v :: proc(col: ImVec4, fmt: cstring, args: c.va_list) {
	ImGui_TextColoredV(col, fmt, args)
}

text_disabled_v :: proc(fmt: cstring, args: c.va_list) {
	ImGui_TextDisabledV(fmt, args)
}

text_wrapped_v :: proc(fmt: cstring, args: c.va_list) {
	ImGui_TextWrappedV(fmt, args)
}

label_text_v :: proc(label: cstring, fmt: cstring, args: c.va_list) {
	ImGui_LabelTextV(label, fmt, args)
}

bullet_text_v :: proc(fmt: cstring, args: c.va_list) {
	ImGui_BulletTextV(fmt, args)
}

separator_text :: proc(label: cstring) {
	ImGui_SeparatorText(label)
}

button :: proc(label: cstring, size: ImVec2 = ImVec2{0, 0}) -> bool {
	return ImGui_ButtonEx(label, size)
}

small_button :: proc(label: cstring) -> bool {
	return ImGui_SmallButton(label)
}

invisible_button :: proc(str_id: cstring, size: ImVec2, flags: ImGuiButtonFlags = 0) -> bool {
	return ImGui_InvisibleButton(str_id, size, flags)
}

arrow_button :: proc(str_id: cstring, dir: ImGuiDir) -> bool {
	return ImGui_ArrowButton(str_id, dir)
}

checkbox :: proc(label: cstring, v: ^bool) -> bool {
	return ImGui_Checkbox(label, v)
}

checkbox_flags_int_ptr :: proc(label: cstring, flags: ^c.int, flags_value: c.int) -> bool {
	return ImGui_CheckboxFlagsIntPtr(label, flags, flags_value)
}

radio_button_int_ptr :: proc(label: cstring, v: ^c.int, v_button: c.int) -> bool {
	return ImGui_RadioButtonIntPtr(label, v, v_button)
}

progress_bar :: proc(fraction: f32, size_arg: ImVec2 = ImVec2{-FLT_MIN, 0}, overlay: cstring = nil) {
	ImGui_ProgressBar(fraction, size_arg, overlay)
}

bullet :: proc() {
	ImGui_Bullet()
}

text_link :: proc(label: cstring) -> bool {
	return ImGui_TextLink(label)
}

text_link_open_url :: proc(label: cstring, url: cstring = nil) -> bool {
	return ImGui_TextLinkOpenURLEx(label, url)
}

image_im_vec4 :: proc(tex_ref: ImTextureRef, image_size: ImVec2, uv0: ImVec2, uv1: ImVec2, tint_col: ImVec4, border_col: ImVec4) {
	ImGui_ImageImVec4(tex_ref, image_size, uv0, uv1, tint_col, border_col)
}

image_with_bg :: proc(tex_ref: ImTextureRef, image_size: ImVec2, uv0: ImVec2 = ImVec2{0, 0}, uv1: ImVec2 = ImVec2{1, 1}, bg_col: ImVec4 = ImVec4{0, 0, 0, 0}, tint_col: ImVec4 = ImVec4{1, 1, 1, 1}) {
	ImGui_ImageWithBgEx(tex_ref, image_size, uv0, uv1, bg_col, tint_col)
}

image_button :: proc(str_id: cstring, tex_ref: ImTextureRef, image_size: ImVec2, uv0: ImVec2 = ImVec2{0, 0}, uv1: ImVec2 = ImVec2{1, 1}, bg_col: ImVec4 = ImVec4{0, 0, 0, 0}, tint_col: ImVec4 = ImVec4{1, 1, 1, 1}) -> bool {
	return ImGui_ImageButtonEx(str_id, tex_ref, image_size, uv0, uv1, bg_col, tint_col)
}

begin_combo :: proc(label: cstring, preview_value: cstring, flags: ImGuiComboFlags = 0) -> bool {
	return ImGui_BeginCombo(label, preview_value, flags)
}

end_combo :: proc() {
	ImGui_EndCombo()
}

combo_callback :: proc(label: cstring, current_item: ^c.int, getter: proc "c" (user_data: rawptr, idx: c.int) -> cstring, user_data: rawptr, items_count: c.int, popup_max_height_in_items: c.int = -1) -> bool {
	return ImGui_ComboCallbackEx(label, current_item, getter, user_data, items_count, popup_max_height_in_items)
}

drag_float :: proc(label: cstring, v: ^f32, v_speed: f32 = 1.0, v_min: f32 = 0.0, v_max: f32 = 0.0, format: cstring = "%.3", flags: ImGuiSliderFlags = 0) -> bool {
	return ImGui_DragFloatEx(label, v, v_speed, v_min, v_max, format, flags)
}

drag_float2 :: proc(label: cstring, v: ^[2]f32, v_speed: f32 = 1.0, v_min: f32 = 0.0, v_max: f32 = 0.0, format: cstring = "%.3", flags: ImGuiSliderFlags = 0) -> bool {
	return ImGui_DragFloat2Ex(label, &v^[0], v_speed, v_min, v_max, format, flags)
}

drag_float3 :: proc(label: cstring, v: ^[3]f32, v_speed: f32 = 1.0, v_min: f32 = 0.0, v_max: f32 = 0.0, format: cstring = "%.3", flags: ImGuiSliderFlags = 0) -> bool {
	return ImGui_DragFloat3Ex(label, &v^[0], v_speed, v_min, v_max, format, flags)
}

drag_float4 :: proc(label: cstring, v: ^[4]f32, v_speed: f32 = 1.0, v_min: f32 = 0.0, v_max: f32 = 0.0, format: cstring = "%.3", flags: ImGuiSliderFlags = 0) -> bool {
	return ImGui_DragFloat4Ex(label, &v^[0], v_speed, v_min, v_max, format, flags)
}

drag_float_range2 :: proc(label: cstring, v_current_min: ^f32, v_current_max: ^f32, v_speed: f32 = 1.0, v_min: f32 = 0.0, v_max: f32 = 0.0, format: cstring = "%.3", format_max: cstring = nil, flags: ImGuiSliderFlags = 0) -> bool {
	return ImGui_DragFloatRange2Ex(label, v_current_min, v_current_max, v_speed, v_min, v_max, format, format_max, flags)
}

drag_int :: proc(label: cstring, v: ^c.int, v_speed: f32 = 1.0, v_min: c.int = 0, v_max: c.int = 0, format: cstring = "%d", flags: ImGuiSliderFlags = 0) -> bool {
	return ImGui_DragIntEx(label, v, v_speed, v_min, v_max, format, flags)
}

drag_int2 :: proc(label: cstring, v: ^[2]c.int, v_speed: f32 = 1.0, v_min: c.int = 0, v_max: c.int = 0, format: cstring = "%d", flags: ImGuiSliderFlags = 0) -> bool {
	return ImGui_DragInt2Ex(label, &v^[0], v_speed, v_min, v_max, format, flags)
}

drag_int3 :: proc(label: cstring, v: ^[3]c.int, v_speed: f32 = 1.0, v_min: c.int = 0, v_max: c.int = 0, format: cstring = "%d", flags: ImGuiSliderFlags = 0) -> bool {
	return ImGui_DragInt3Ex(label, &v^[0], v_speed, v_min, v_max, format, flags)
}

drag_int4 :: proc(label: cstring, v: ^[4]c.int, v_speed: f32 = 1.0, v_min: c.int = 0, v_max: c.int = 0, format: cstring = "%d", flags: ImGuiSliderFlags = 0) -> bool {
	return ImGui_DragInt4Ex(label, &v^[0], v_speed, v_min, v_max, format, flags)
}

drag_int_range2 :: proc(label: cstring, v_current_min: ^c.int, v_current_max: ^c.int, v_speed: f32 = 1.0, v_min: c.int = 0, v_max: c.int = 0, format: cstring = "%d", format_max: cstring = nil, flags: ImGuiSliderFlags = 0) -> bool {
	return ImGui_DragIntRange2Ex(label, v_current_min, v_current_max, v_speed, v_min, v_max, format, format_max, flags)
}

drag_scalar :: proc(label: cstring, data_type: ImGuiDataType, p_data: rawptr, v_speed: f32 = 1.0, p_min: rawptr = nil, p_max: rawptr = nil, format: cstring = nil, flags: ImGuiSliderFlags = 0) -> bool {
	return ImGui_DragScalarEx(label, data_type, p_data, v_speed, p_min, p_max, format, flags)
}

drag_scalar_n :: proc(label: cstring, data_type: ImGuiDataType, p_data: rawptr, components: c.int, v_speed: f32 = 1.0, p_min: rawptr = nil, p_max: rawptr = nil, format: cstring = nil, flags: ImGuiSliderFlags = 0) -> bool {
	return ImGui_DragScalarNEx(label, data_type, p_data, components, v_speed, p_min, p_max, format, flags)
}

slider_float :: proc(label: cstring, v: ^f32, v_min: f32, v_max: f32, format: cstring = "%.3", flags: ImGuiSliderFlags = 0) -> bool {
	return ImGui_SliderFloatEx(label, v, v_min, v_max, format, flags)
}

slider_float2 :: proc(label: cstring, v: ^[2]f32, v_min: f32, v_max: f32, format: cstring = "%.3", flags: ImGuiSliderFlags = 0) -> bool {
	return ImGui_SliderFloat2Ex(label, &v^[0], v_min, v_max, format, flags)
}

slider_float3 :: proc(label: cstring, v: ^[3]f32, v_min: f32, v_max: f32, format: cstring = "%.3", flags: ImGuiSliderFlags = 0) -> bool {
	return ImGui_SliderFloat3Ex(label, &v^[0], v_min, v_max, format, flags)
}

slider_float4 :: proc(label: cstring, v: ^[4]f32, v_min: f32, v_max: f32, format: cstring = "%.3", flags: ImGuiSliderFlags = 0) -> bool {
	return ImGui_SliderFloat4Ex(label, &v^[0], v_min, v_max, format, flags)
}

slider_angle :: proc(label: cstring, v_rad: ^f32, v_degrees_min: f32 = -360.0, v_degrees_max: f32 = +360.0, format: cstring = "%.0 deg", flags: ImGuiSliderFlags = 0) -> bool {
	return ImGui_SliderAngleEx(label, v_rad, v_degrees_min, v_degrees_max, format, flags)
}

slider_int :: proc(label: cstring, v: ^c.int, v_min: c.int, v_max: c.int, format: cstring = "%d", flags: ImGuiSliderFlags = 0) -> bool {
	return ImGui_SliderIntEx(label, v, v_min, v_max, format, flags)
}

slider_int2 :: proc(label: cstring, v: ^[2]c.int, v_min: c.int, v_max: c.int, format: cstring = "%d", flags: ImGuiSliderFlags = 0) -> bool {
	return ImGui_SliderInt2Ex(label, &v^[0], v_min, v_max, format, flags)
}

slider_int3 :: proc(label: cstring, v: ^[3]c.int, v_min: c.int, v_max: c.int, format: cstring = "%d", flags: ImGuiSliderFlags = 0) -> bool {
	return ImGui_SliderInt3Ex(label, &v^[0], v_min, v_max, format, flags)
}

slider_int4 :: proc(label: cstring, v: ^[4]c.int, v_min: c.int, v_max: c.int, format: cstring = "%d", flags: ImGuiSliderFlags = 0) -> bool {
	return ImGui_SliderInt4Ex(label, &v^[0], v_min, v_max, format, flags)
}

slider_scalar :: proc(label: cstring, data_type: ImGuiDataType, p_data: rawptr, p_min: rawptr, p_max: rawptr, format: cstring = nil, flags: ImGuiSliderFlags = 0) -> bool {
	return ImGui_SliderScalarEx(label, data_type, p_data, p_min, p_max, format, flags)
}

slider_scalar_n :: proc(label: cstring, data_type: ImGuiDataType, p_data: rawptr, components: c.int, p_min: rawptr, p_max: rawptr, format: cstring = nil, flags: ImGuiSliderFlags = 0) -> bool {
	return ImGui_SliderScalarNEx(label, data_type, p_data, components, p_min, p_max, format, flags)
}

v_slider_float :: proc(label: cstring, size: ImVec2, v: ^f32, v_min: f32, v_max: f32, format: cstring = "%.3", flags: ImGuiSliderFlags = 0) -> bool {
	return ImGui_VSliderFloatEx(label, size, v, v_min, v_max, format, flags)
}

v_slider_int :: proc(label: cstring, size: ImVec2, v: ^c.int, v_min: c.int, v_max: c.int, format: cstring = "%d", flags: ImGuiSliderFlags = 0) -> bool {
	return ImGui_VSliderIntEx(label, size, v, v_min, v_max, format, flags)
}

v_slider_scalar :: proc(label: cstring, size: ImVec2, data_type: ImGuiDataType, p_data: rawptr, p_min: rawptr, p_max: rawptr, format: cstring = nil, flags: ImGuiSliderFlags = 0) -> bool {
	return ImGui_VSliderScalarEx(label, size, data_type, p_data, p_min, p_max, format, flags)
}

input_text :: proc(label: cstring, buf: [^]c.char, buf_size: c.size_t, flags: ImGuiInputTextFlags = 0, callback: ImGuiInputTextCallback = nil, user_data: rawptr = nil) -> bool {
	return ImGui_InputTextEx(label, buf, buf_size, flags, callback, user_data)
}

input_text_multiline :: proc(label: cstring, buf: [^]c.char, buf_size: c.size_t, size: ImVec2 = ImVec2{0, 0}, flags: ImGuiInputTextFlags = 0, callback: ImGuiInputTextCallback = nil, user_data: rawptr = nil) -> bool {
	return ImGui_InputTextMultilineEx(label, buf, buf_size, size, flags, callback, user_data)
}

input_text_with_hint :: proc(label: cstring, hint: cstring, buf: [^]c.char, buf_size: c.size_t, flags: ImGuiInputTextFlags = 0, callback: ImGuiInputTextCallback = nil, user_data: rawptr = nil) -> bool {
	return ImGui_InputTextWithHintEx(label, hint, buf, buf_size, flags, callback, user_data)
}

input_float :: proc(label: cstring, v: ^f32, step: f32 = 0.0, step_fast: f32 = 0.0, format: cstring = "%.3", flags: ImGuiInputTextFlags = 0) -> bool {
	return ImGui_InputFloatEx(label, v, step, step_fast, format, flags)
}

input_float2 :: proc(label: cstring, v: ^[2]f32, format: cstring = "%.3", flags: ImGuiInputTextFlags = 0) -> bool {
	return ImGui_InputFloat2Ex(label, &v^[0], format, flags)
}

input_float3 :: proc(label: cstring, v: ^[3]f32, format: cstring = "%.3", flags: ImGuiInputTextFlags = 0) -> bool {
	return ImGui_InputFloat3Ex(label, &v^[0], format, flags)
}

input_float4 :: proc(label: cstring, v: ^[4]f32, format: cstring = "%.3", flags: ImGuiInputTextFlags = 0) -> bool {
	return ImGui_InputFloat4Ex(label, &v^[0], format, flags)
}

input_int :: proc(label: cstring, v: ^c.int, step: c.int = 1, step_fast: c.int = 100, flags: ImGuiInputTextFlags = 0) -> bool {
	return ImGui_InputIntEx(label, v, step, step_fast, flags)
}

input_int2 :: proc(label: cstring, v: ^[2]c.int, flags: ImGuiInputTextFlags = 0) -> bool {
	return ImGui_InputInt2(label, &v^[0], flags)
}

input_int3 :: proc(label: cstring, v: ^[3]c.int, flags: ImGuiInputTextFlags = 0) -> bool {
	return ImGui_InputInt3(label, &v^[0], flags)
}

input_int4 :: proc(label: cstring, v: ^[4]c.int, flags: ImGuiInputTextFlags = 0) -> bool {
	return ImGui_InputInt4(label, &v^[0], flags)
}

input_double :: proc(label: cstring, v: ^f64, step: f64 = 0.0, step_fast: f64 = 0.0, format: cstring = "%.6", flags: ImGuiInputTextFlags = 0) -> bool {
	return ImGui_InputDoubleEx(label, v, step, step_fast, format, flags)
}

input_scalar :: proc(label: cstring, data_type: ImGuiDataType, p_data: rawptr, p_step: rawptr = nil, p_step_fast: rawptr = nil, format: cstring = nil, flags: ImGuiInputTextFlags = 0) -> bool {
	return ImGui_InputScalarEx(label, data_type, p_data, p_step, p_step_fast, format, flags)
}

input_scalar_n :: proc(label: cstring, data_type: ImGuiDataType, p_data: rawptr, components: c.int, p_step: rawptr = nil, p_step_fast: rawptr = nil, format: cstring = nil, flags: ImGuiInputTextFlags = 0) -> bool {
	return ImGui_InputScalarNEx(label, data_type, p_data, components, p_step, p_step_fast, format, flags)
}

color_edit3 :: proc(label: cstring, col: ^[3]f32, flags: ImGuiColorEditFlags = 0) -> bool {
	return ImGui_ColorEdit3(label, &col^[0], flags)
}

color_edit4 :: proc(label: cstring, col: ^[4]f32, flags: ImGuiColorEditFlags = 0) -> bool {
	return ImGui_ColorEdit4(label, &col^[0], flags)
}

color_picker3 :: proc(label: cstring, col: ^[3]f32, flags: ImGuiColorEditFlags = 0) -> bool {
	return ImGui_ColorPicker3(label, &col^[0], flags)
}

color_picker4 :: proc(label: cstring, col: ^[4]f32, flags: ImGuiColorEditFlags = 0, ref_col: ^f32 = nil) -> bool {
	return ImGui_ColorPicker4(label, &col^[0], flags, ref_col)
}

color_button :: proc(desc_id: cstring, col: ImVec4, flags: ImGuiColorEditFlags = 0, size: ImVec2 = ImVec2{0, 0}) -> bool {
	return ImGui_ColorButtonEx(desc_id, col, flags, size)
}

set_color_edit_options :: proc(flags: ImGuiColorEditFlags) {
	ImGui_SetColorEditOptions(flags)
}

tree_node :: proc(label: cstring) -> bool {
	return ImGui_TreeNode(label)
}

tree_node_v :: proc(str_id: cstring, fmt: cstring, args: c.va_list) -> bool {
	return ImGui_TreeNodeV(str_id, fmt, args)
}

im_gui_tree_node_ex :: proc(label: cstring, flags: ImGuiTreeNodeFlags = 0) -> bool {
	return ImGui_TreeNodeEx(label, flags)
}

tree_node_ex_v :: proc(str_id: cstring, flags: ImGuiTreeNodeFlags, fmt: cstring, args: c.va_list) -> bool {
	return ImGui_TreeNodeExV(str_id, flags, fmt, args)
}

tree_push :: proc(str_id: cstring) {
	ImGui_TreePush(str_id)
}

tree_pop :: proc() {
	ImGui_TreePop()
}

get_tree_node_to_label_spacing :: proc() -> f32 {
	return ImGui_GetTreeNodeToLabelSpacing()
}

collapsing_header_bool_ptr :: proc(label: cstring, p_visible: ^bool, flags: ImGuiTreeNodeFlags = 0) -> bool {
	return ImGui_CollapsingHeaderBoolPtr(label, p_visible, flags)
}

set_next_item_open :: proc(is_open: bool, cond: ImGuiCond = 0) {
	ImGui_SetNextItemOpen(is_open, cond)
}

set_next_item_storage_id :: proc(storage_id: ImGuiID) {
	ImGui_SetNextItemStorageID(storage_id)
}

tree_node_get_open :: proc(storage_id: ImGuiID) -> bool {
	return ImGui_TreeNodeGetOpen(storage_id)
}

selectable :: proc(label: cstring, selected: bool = false, flags: ImGuiSelectableFlags = 0, size: ImVec2 = ImVec2{0, 0}) -> bool {
	return ImGui_SelectableEx(label, selected, flags, size)
}

begin_multi_select :: proc(flags: ImGuiMultiSelectFlags, selection_size: c.int = -1, items_count: c.int = -1) -> ^ImGuiMultiSelectIO {
	return ImGui_BeginMultiSelectEx(flags, selection_size, items_count)
}

end_multi_select :: proc() -> ^ImGuiMultiSelectIO {
	return ImGui_EndMultiSelect()
}

set_next_item_selection_user_data :: proc(selection_user_data: ImGuiSelectionUserData) {
	ImGui_SetNextItemSelectionUserData(selection_user_data)
}

is_item_toggled_selection :: proc() -> bool {
	return ImGui_IsItemToggledSelection()
}

begin_list_box :: proc(label: cstring, size: ImVec2 = ImVec2{0, 0}) -> bool {
	return ImGui_BeginListBox(label, size)
}

end_list_box :: proc() {
	ImGui_EndListBox()
}

list_box_callback :: proc(label: cstring, current_item: ^c.int, getter: proc "c" (user_data: rawptr, idx: c.int) -> cstring, user_data: rawptr, items_count: c.int, height_in_items: c.int = -1) -> bool {
	return ImGui_ListBoxCallbackEx(label, current_item, getter, user_data, items_count, height_in_items)
}

plot_lines :: proc(label: cstring, values: ^f32, values_count: c.int, values_offset: c.int = 0, overlay_text: cstring = nil, scale_min: f32 = FLT_MAX, scale_max: f32 = FLT_MAX, graph_size: ImVec2 = ImVec2{0, 0}, stride: c.int = size_of(f32)) {
	ImGui_PlotLinesEx(label, values, values_count, values_offset, overlay_text, scale_min, scale_max, graph_size, stride)
}

plot_histogram :: proc(label: cstring, values: ^f32, values_count: c.int, values_offset: c.int = 0, overlay_text: cstring = nil, scale_min: f32 = FLT_MAX, scale_max: f32 = FLT_MAX, graph_size: ImVec2 = ImVec2{0, 0}, stride: c.int = size_of(f32)) {
	ImGui_PlotHistogramEx(label, values, values_count, values_offset, overlay_text, scale_min, scale_max, graph_size, stride)
}

begin_menu_bar :: proc() -> bool {
	return ImGui_BeginMenuBar()
}

end_menu_bar :: proc() {
	ImGui_EndMenuBar()
}

begin_main_menu_bar :: proc() -> bool {
	return ImGui_BeginMainMenuBar()
}

end_main_menu_bar :: proc() {
	ImGui_EndMainMenuBar()
}

begin_menu :: proc(label: cstring, enabled: bool = true) -> bool {
	return ImGui_BeginMenuEx(label, enabled)
}

end_menu :: proc() {
	ImGui_EndMenu()
}

menu_item :: proc(label: cstring, shortcut: cstring = nil, selected: bool = false, enabled: bool = true) -> bool {
	return ImGui_MenuItemEx(label, shortcut, selected, enabled)
}

begin_tooltip :: proc() -> bool {
	return ImGui_BeginTooltip()
}

end_tooltip :: proc() {
	ImGui_EndTooltip()
}

set_tooltip_v :: proc(fmt: cstring, args: c.va_list) {
	ImGui_SetTooltipV(fmt, args)
}

begin_item_tooltip :: proc() -> bool {
	return ImGui_BeginItemTooltip()
}

set_item_tooltip_v :: proc(fmt: cstring, args: c.va_list) {
	ImGui_SetItemTooltipV(fmt, args)
}

begin_popup :: proc(str_id: cstring, flags: ImGuiWindowFlags = 0) -> bool {
	return ImGui_BeginPopup(str_id, flags)
}

begin_popup_modal :: proc(name: cstring, p_open: ^bool = nil, flags: ImGuiWindowFlags = 0) -> bool {
	return ImGui_BeginPopupModal(name, p_open, flags)
}

end_popup :: proc() {
	ImGui_EndPopup()
}

open_popup :: proc(str_id: cstring, popup_flags: ImGuiPopupFlags = 0) {
	ImGui_OpenPopup(str_id, popup_flags)
}

open_popup_on_item_click :: proc(str_id: cstring = nil, popup_flags: ImGuiPopupFlags = 0) {
	ImGui_OpenPopupOnItemClick(str_id, popup_flags)
}

close_current_popup :: proc() {
	ImGui_CloseCurrentPopup()
}

begin_popup_context_item :: proc(str_id: cstring = nil, popup_flags: ImGuiPopupFlags = 0) -> bool {
	return ImGui_BeginPopupContextItemEx(str_id, popup_flags)
}

begin_popup_context_window :: proc(str_id: cstring = nil, popup_flags: ImGuiPopupFlags = 0) -> bool {
	return ImGui_BeginPopupContextWindowEx(str_id, popup_flags)
}

begin_popup_context_void :: proc(str_id: cstring = nil, popup_flags: ImGuiPopupFlags = 0) -> bool {
	return ImGui_BeginPopupContextVoidEx(str_id, popup_flags)
}

is_popup_open :: proc(str_id: cstring, flags: ImGuiPopupFlags = 0) -> bool {
	return ImGui_IsPopupOpen(str_id, flags)
}

begin_table :: proc(str_id: cstring, columns: c.int, flags: ImGuiTableFlags = 0, outer_size: ImVec2 = ImVec2{0.0, 0.0}, inner_width: f32 = 0.0) -> bool {
	return ImGui_BeginTableEx(str_id, columns, flags, outer_size, inner_width)
}

end_table :: proc() {
	ImGui_EndTable()
}

table_next_row :: proc(row_flags: ImGuiTableRowFlags = 0, min_row_height: f32 = 0.0) {
	ImGui_TableNextRowEx(row_flags, min_row_height)
}

table_next_column :: proc() -> bool {
	return ImGui_TableNextColumn()
}

table_set_column_index :: proc(column_n: c.int) -> bool {
	return ImGui_TableSetColumnIndex(column_n)
}

table_setup_column :: proc(label: cstring, flags: ImGuiTableColumnFlags = 0, init_width_or_weight: f32 = 0.0, user_id: ImGuiID = 0) {
	ImGui_TableSetupColumnEx(label, flags, init_width_or_weight, user_id)
}

table_setup_scroll_freeze :: proc(cols: c.int, rows: c.int) {
	ImGui_TableSetupScrollFreeze(cols, rows)
}

table_header :: proc(label: cstring) {
	ImGui_TableHeader(label)
}

table_headers_row :: proc() {
	ImGui_TableHeadersRow()
}

table_angled_headers_row :: proc() {
	ImGui_TableAngledHeadersRow()
}

table_get_sort_specs :: proc() -> ^ImGuiTableSortSpecs {
	return ImGui_TableGetSortSpecs()
}

table_get_column_count :: proc() -> c.int {
	return ImGui_TableGetColumnCount()
}

table_get_column_index :: proc() -> c.int {
	return ImGui_TableGetColumnIndex()
}

table_get_row_index :: proc() -> c.int {
	return ImGui_TableGetRowIndex()
}

table_get_column_name :: proc(column_n: c.int = -1) -> cstring {
	return ImGui_TableGetColumnName(column_n)
}

table_get_column_flags :: proc(column_n: c.int = -1) -> ImGuiTableColumnFlags {
	return ImGui_TableGetColumnFlags(column_n)
}

table_set_column_enabled :: proc(column_n: c.int, v: bool) {
	ImGui_TableSetColumnEnabled(column_n, v)
}

table_get_hovered_column :: proc() -> c.int {
	return ImGui_TableGetHoveredColumn()
}

table_set_bg_color :: proc(target: ImGuiTableBgTarget, color: ImU32, column_n: c.int = -1) {
	ImGui_TableSetBgColor(target, color, column_n)
}

columns :: proc(count: c.int = 1, id: cstring = nil, borders: bool = true) {
	ImGui_ColumnsEx(count, id, borders)
}

next_column :: proc() {
	ImGui_NextColumn()
}

get_column_index :: proc() -> c.int {
	return ImGui_GetColumnIndex()
}

get_column_width :: proc(column_index: c.int = -1) -> f32 {
	return ImGui_GetColumnWidth(column_index)
}

set_column_width :: proc(column_index: c.int, width: f32) {
	ImGui_SetColumnWidth(column_index, width)
}

get_column_offset :: proc(column_index: c.int = -1) -> f32 {
	return ImGui_GetColumnOffset(column_index)
}

set_column_offset :: proc(column_index: c.int, offset_x: f32) {
	ImGui_SetColumnOffset(column_index, offset_x)
}

get_columns_count :: proc() -> c.int {
	return ImGui_GetColumnsCount()
}

begin_tab_bar :: proc(str_id: cstring, flags: ImGuiTabBarFlags = 0) -> bool {
	return ImGui_BeginTabBar(str_id, flags)
}

end_tab_bar :: proc() {
	ImGui_EndTabBar()
}

begin_tab_item :: proc(label: cstring, p_open: ^bool = nil, flags: ImGuiTabItemFlags = 0) -> bool {
	return ImGui_BeginTabItem(label, p_open, flags)
}

end_tab_item :: proc() {
	ImGui_EndTabItem()
}

tab_item_button :: proc(label: cstring, flags: ImGuiTabItemFlags = 0) -> bool {
	return ImGui_TabItemButton(label, flags)
}

set_tab_item_closed :: proc(tab_or_docked_window_label: cstring) {
	ImGui_SetTabItemClosed(tab_or_docked_window_label)
}

dock_space :: proc(dockspace_id: ImGuiID, size: ImVec2 = ImVec2{0, 0}, flags: ImGuiDockNodeFlags = 0, window_class: ^ImGuiWindowClass = nil) -> ImGuiID {
	return ImGui_DockSpaceEx(dockspace_id, size, flags, window_class)
}

dock_space_over_viewport :: proc(dockspace_id: ImGuiID = 0, viewport: ^ImGuiViewport = nil, flags: ImGuiDockNodeFlags = 0, window_class: ^ImGuiWindowClass = nil) -> ImGuiID {
	return ImGui_DockSpaceOverViewportEx(dockspace_id, viewport, flags, window_class)
}

set_next_window_dock_id :: proc(dock_id: ImGuiID, cond: ImGuiCond = 0) {
	ImGui_SetNextWindowDockID(dock_id, cond)
}

set_next_window_class :: proc(window_class: ^ImGuiWindowClass) {
	ImGui_SetNextWindowClass(window_class)
}

get_window_dock_id :: proc() -> ImGuiID {
	return ImGui_GetWindowDockID()
}

is_window_docked :: proc() -> bool {
	return ImGui_IsWindowDocked()
}

log_to_tty :: proc(auto_open_depth: c.int = -1) {
	ImGui_LogToTTY(auto_open_depth)
}

log_to_file :: proc(auto_open_depth: c.int = -1, filename: cstring = nil) {
	ImGui_LogToFile(auto_open_depth, filename)
}

log_to_clipboard :: proc(auto_open_depth: c.int = -1) {
	ImGui_LogToClipboard(auto_open_depth)
}

log_finish :: proc() {
	ImGui_LogFinish()
}

log_buttons :: proc() {
	ImGui_LogButtons()
}

log_text_v :: proc(fmt: cstring, args: c.va_list) {
	ImGui_LogTextV(fmt, args)
}

begin_drag_drop_source :: proc(flags: ImGuiDragDropFlags = 0) -> bool {
	return ImGui_BeginDragDropSource(flags)
}

set_drag_drop_payload :: proc(type: cstring, data: rawptr, sz: c.size_t, cond: ImGuiCond = 0) -> bool {
	return ImGui_SetDragDropPayload(type, data, sz, cond)
}

end_drag_drop_source :: proc() {
	ImGui_EndDragDropSource()
}

begin_drag_drop_target :: proc() -> bool {
	return ImGui_BeginDragDropTarget()
}

accept_drag_drop_payload :: proc(type: cstring, flags: ImGuiDragDropFlags = 0) -> ^ImGuiPayload {
	return ImGui_AcceptDragDropPayload(type, flags)
}

end_drag_drop_target :: proc() {
	ImGui_EndDragDropTarget()
}

get_drag_drop_payload :: proc() -> ^ImGuiPayload {
	return ImGui_GetDragDropPayload()
}

begin_disabled :: proc(disabled: bool = true) {
	ImGui_BeginDisabled(disabled)
}

end_disabled :: proc() {
	ImGui_EndDisabled()
}

push_clip_rect :: proc(clip_rect_min: ImVec2, clip_rect_max: ImVec2, intersect_with_current_clip_rect: bool) {
	ImGui_PushClipRect(clip_rect_min, clip_rect_max, intersect_with_current_clip_rect)
}

pop_clip_rect :: proc() {
	ImGui_PopClipRect()
}

set_item_default_focus :: proc() {
	ImGui_SetItemDefaultFocus()
}

set_keyboard_focus_here :: proc(offset: c.int = 0) {
	ImGui_SetKeyboardFocusHereEx(offset)
}

set_nav_cursor_visible :: proc(visible: bool) {
	ImGui_SetNavCursorVisible(visible)
}

set_next_item_allow_overlap :: proc() {
	ImGui_SetNextItemAllowOverlap()
}

is_item_hovered :: proc(flags: ImGuiHoveredFlags = 0) -> bool {
	return ImGui_IsItemHovered(flags)
}

is_item_active :: proc() -> bool {
	return ImGui_IsItemActive()
}

is_item_focused :: proc() -> bool {
	return ImGui_IsItemFocused()
}

is_item_clicked :: proc(mouse_button: ImGuiMouseButton = 0) -> bool {
	return ImGui_IsItemClickedEx(mouse_button)
}

is_item_visible :: proc() -> bool {
	return ImGui_IsItemVisible()
}

is_item_edited :: proc() -> bool {
	return ImGui_IsItemEdited()
}

is_item_activated :: proc() -> bool {
	return ImGui_IsItemActivated()
}

is_item_deactivated :: proc() -> bool {
	return ImGui_IsItemDeactivated()
}

is_item_deactivated_after_edit :: proc() -> bool {
	return ImGui_IsItemDeactivatedAfterEdit()
}

is_item_toggled_open :: proc() -> bool {
	return ImGui_IsItemToggledOpen()
}

is_any_item_hovered :: proc() -> bool {
	return ImGui_IsAnyItemHovered()
}

is_any_item_active :: proc() -> bool {
	return ImGui_IsAnyItemActive()
}

is_any_item_focused :: proc() -> bool {
	return ImGui_IsAnyItemFocused()
}

get_item_id :: proc() -> ImGuiID {
	return ImGui_GetItemID()
}

get_item_rect_min :: proc() -> ImVec2 {
	return ImGui_GetItemRectMin()
}

get_item_rect_max :: proc() -> ImVec2 {
	return ImGui_GetItemRectMax()
}

get_item_rect_size :: proc() -> ImVec2 {
	return ImGui_GetItemRectSize()
}

get_item_flags :: proc() -> ImGuiItemFlags {
	return ImGui_GetItemFlags()
}

get_main_viewport :: proc() -> ^ImGuiViewport {
	return ImGui_GetMainViewport()
}

get_background_draw_list :: proc(viewport: ^ImGuiViewport = nil) -> ^ImDrawList {
	return ImGui_GetBackgroundDrawListEx(viewport)
}

get_foreground_draw_list :: proc(viewport: ^ImGuiViewport = nil) -> ^ImDrawList {
	return ImGui_GetForegroundDrawListEx(viewport)
}

is_rect_visible :: proc(rect_min: ImVec2, rect_max: ImVec2) -> bool {
	return ImGui_IsRectVisible(rect_min, rect_max)
}

get_time :: proc() -> f64 {
	return ImGui_GetTime()
}

get_frame_count :: proc() -> c.int {
	return ImGui_GetFrameCount()
}

get_draw_list_shared_data :: proc() -> ^ImDrawListSharedData {
	return ImGui_GetDrawListSharedData()
}

get_style_color_name :: proc(idx: ImGuiCol) -> cstring {
	return ImGui_GetStyleColorName(idx)
}

set_state_storage :: proc(storage: ^ImGuiStorage) {
	ImGui_SetStateStorage(storage)
}

get_state_storage :: proc() -> ^ImGuiStorage {
	return ImGui_GetStateStorage()
}

calc_text_size :: proc(text: cstring, text_end: cstring = nil, hide_text_after_double_hash: bool = false, wrap_width: f32 = -1.0) -> ImVec2 {
	return ImGui_CalcTextSizeEx(text, text_end, hide_text_after_double_hash, wrap_width)
}

color_convert_u32_to_float4 :: proc(in_: ImU32) -> ImVec4 {
	return ImGui_ColorConvertU32ToFloat4(in_)
}

color_convert_float4_to_u32 :: proc(in_: ImVec4) -> ImU32 {
	return ImGui_ColorConvertFloat4ToU32(in_)
}

color_convert_rg_bto_hsv :: proc(r: f32, g: f32, b: f32, out_h: ^f32, out_s: ^f32, out_v: ^f32) {
	ImGui_ColorConvertRGBtoHSV(r, g, b, out_h, out_s, out_v)
}

color_convert_hs_vto_rgb :: proc(h: f32, s: f32, v: f32, out_r: ^f32, out_g: ^f32, out_b: ^f32) {
	ImGui_ColorConvertHSVtoRGB(h, s, v, out_r, out_g, out_b)
}

is_key_down :: proc(key: ImGuiKey) -> bool {
	return ImGui_IsKeyDown(key)
}

is_key_pressed :: proc(key: ImGuiKey, repeat: bool = true) -> bool {
	return ImGui_IsKeyPressedEx(key, repeat)
}

is_key_released :: proc(key: ImGuiKey) -> bool {
	return ImGui_IsKeyReleased(key)
}

is_key_chord_pressed :: proc(key_chord: ImGuiKeyChord) -> bool {
	return ImGui_IsKeyChordPressed(key_chord)
}

get_key_pressed_amount :: proc(key: ImGuiKey, repeat_delay: f32, rate: f32) -> c.int {
	return ImGui_GetKeyPressedAmount(key, repeat_delay, rate)
}

get_key_name :: proc(key: ImGuiKey) -> cstring {
	return ImGui_GetKeyName(key)
}

set_next_frame_want_capture_keyboard :: proc(want_capture_keyboard: bool) {
	ImGui_SetNextFrameWantCaptureKeyboard(want_capture_keyboard)
}

shortcut :: proc(key_chord: ImGuiKeyChord, flags: ImGuiInputFlags = 0) -> bool {
	return ImGui_Shortcut(key_chord, flags)
}

set_next_item_shortcut :: proc(key_chord: ImGuiKeyChord, flags: ImGuiInputFlags = 0) {
	ImGui_SetNextItemShortcut(key_chord, flags)
}

set_item_key_owner :: proc(key: ImGuiKey) -> bool {
	return ImGui_SetItemKeyOwner(key)
}

is_mouse_down :: proc(button: ImGuiMouseButton) -> bool {
	return ImGui_IsMouseDown(button)
}

is_mouse_clicked :: proc(button: ImGuiMouseButton, repeat: bool = false) -> bool {
	return ImGui_IsMouseClickedEx(button, repeat)
}

is_mouse_released :: proc(button: ImGuiMouseButton) -> bool {
	return ImGui_IsMouseReleased(button)
}

is_mouse_double_clicked :: proc(button: ImGuiMouseButton) -> bool {
	return ImGui_IsMouseDoubleClicked(button)
}

is_mouse_released_with_delay :: proc(button: ImGuiMouseButton, delay: f32) -> bool {
	return ImGui_IsMouseReleasedWithDelay(button, delay)
}

get_mouse_clicked_count :: proc(button: ImGuiMouseButton) -> c.int {
	return ImGui_GetMouseClickedCount(button)
}

is_mouse_hovering_rect :: proc(r_min: ImVec2, r_max: ImVec2, clip: bool = true) -> bool {
	return ImGui_IsMouseHoveringRectEx(r_min, r_max, clip)
}

is_mouse_pos_valid :: proc(mouse_pos: ^ImVec2 = nil) -> bool {
	return ImGui_IsMousePosValid(mouse_pos)
}

is_any_mouse_down :: proc() -> bool {
	return ImGui_IsAnyMouseDown()
}

get_mouse_pos :: proc() -> ImVec2 {
	return ImGui_GetMousePos()
}

get_mouse_pos_on_opening_current_popup :: proc() -> ImVec2 {
	return ImGui_GetMousePosOnOpeningCurrentPopup()
}

is_mouse_dragging :: proc(button: ImGuiMouseButton, lock_threshold: f32 = -1.0) -> bool {
	return ImGui_IsMouseDragging(button, lock_threshold)
}

get_mouse_drag_delta :: proc(button: ImGuiMouseButton = 0, lock_threshold: f32 = -1.0) -> ImVec2 {
	return ImGui_GetMouseDragDelta(button, lock_threshold)
}

reset_mouse_drag_delta :: proc(button: ImGuiMouseButton = 0) {
	ImGui_ResetMouseDragDeltaEx(button)
}

get_mouse_cursor :: proc() -> ImGuiMouseCursor {
	return ImGui_GetMouseCursor()
}

set_mouse_cursor :: proc(cursor_type: ImGuiMouseCursor) {
	ImGui_SetMouseCursor(cursor_type)
}

set_next_frame_want_capture_mouse :: proc(want_capture_mouse: bool) {
	ImGui_SetNextFrameWantCaptureMouse(want_capture_mouse)
}

get_clipboard_text :: proc() -> cstring {
	return ImGui_GetClipboardText()
}

set_clipboard_text :: proc(text: cstring) {
	ImGui_SetClipboardText(text)
}

load_ini_settings_from_disk :: proc(ini_filename: cstring) {
	ImGui_LoadIniSettingsFromDisk(ini_filename)
}

load_ini_settings_from_memory :: proc(ini_data: cstring, ini_size: c.size_t = 0) {
	ImGui_LoadIniSettingsFromMemory(ini_data, ini_size)
}

save_ini_settings_to_disk :: proc(ini_filename: cstring) {
	ImGui_SaveIniSettingsToDisk(ini_filename)
}

save_ini_settings_to_memory :: proc(out_ini_size: ^c.size_t = nil) -> cstring {
	return ImGui_SaveIniSettingsToMemory(out_ini_size)
}

debug_text_encoding :: proc(text: cstring) {
	ImGui_DebugTextEncoding(text)
}

debug_flash_style_color :: proc(idx: ImGuiCol) {
	ImGui_DebugFlashStyleColor(idx)
}

debug_start_item_picker :: proc() {
	ImGui_DebugStartItemPicker()
}

debug_check_version_and_data_layout :: proc(version_str: cstring, sz_io: c.size_t, sz_style: c.size_t, sz_vec2: c.size_t, sz_vec4: c.size_t, sz_drawvert: c.size_t, sz_drawidx: c.size_t) -> bool {
	return ImGui_DebugCheckVersionAndDataLayout(version_str, sz_io, sz_style, sz_vec2, sz_vec4, sz_drawvert, sz_drawidx)
}

debug_log_v :: proc(fmt: cstring, args: c.va_list) {
	ImGui_DebugLogV(fmt, args)
}

set_allocator_functions :: proc(alloc_func: ImGuiMemAllocFunc, free_func: ImGuiMemFreeFunc, user_data: rawptr = nil) {
	ImGui_SetAllocatorFunctions(alloc_func, free_func, user_data)
}

get_allocator_functions :: proc(p_alloc_func: ^ImGuiMemAllocFunc, p_free_func: ^ImGuiMemFreeFunc, p_user_data: ^rawptr) {
	ImGui_GetAllocatorFunctions(p_alloc_func, p_free_func, p_user_data)
}

mem_alloc :: proc(size: c.size_t) -> rawptr {
	return ImGui_MemAlloc(size)
}

mem_free :: proc(ptr: rawptr) {
	ImGui_MemFree(ptr)
}

update_platform_windows :: proc() {
	ImGui_UpdatePlatformWindows()
}

render_platform_windows_default :: proc(platform_render_arg: rawptr = nil, renderer_render_arg: rawptr = nil) {
	ImGui_RenderPlatformWindowsDefaultEx(platform_render_arg, renderer_render_arg)
}

destroy_platform_windows :: proc() {
	ImGui_DestroyPlatformWindows()
}

find_viewport_by_id :: proc(viewport_id: ImGuiID) -> ^ImGuiViewport {
	return ImGui_FindViewportByID(viewport_id)
}

find_viewport_by_platform_handle :: proc(platform_handle: rawptr) -> ^ImGuiViewport {
	return ImGui_FindViewportByPlatformHandle(platform_handle)
}

im_vector_construct :: proc(vector: rawptr) {
	ImVector_Construct(vector)
}

im_vector_destruct :: proc(vector: rawptr) {
	ImVector_Destruct(vector)
}

im_gui_platform_io_set_platform_get_window_work_area_insets :: proc(getWindowWorkAreaInsetsFunc: proc "c" (vp: ^ImGuiViewport, result: ^ImVec4)) {
	ImGuiPlatformIO_SetPlatform_GetWindowWorkAreaInsets(getWindowWorkAreaInsetsFunc)
}

im_gui_platform_io_set_platform_get_window_framebuffer_scale :: proc(getWindowFramebufferScaleFunc: proc "c" (vp: ^ImGuiViewport, result: ^ImVec2)) {
	ImGuiPlatformIO_SetPlatform_GetWindowFramebufferScale(getWindowFramebufferScaleFunc)
}

im_gui_platform_io_set_platform_get_window_pos :: proc(getWindowPosFunc: proc "c" (vp: ^ImGuiViewport, result: ^ImVec2)) {
	ImGuiPlatformIO_SetPlatform_GetWindowPos(getWindowPosFunc)
}

im_gui_platform_io_set_platform_get_window_size :: proc(getWindowSizeFunc: proc "c" (vp: ^ImGuiViewport, result: ^ImVec2)) {
	ImGuiPlatformIO_SetPlatform_GetWindowSize(getWindowSizeFunc)
}

scale_all_sizes :: proc(self: ^ImGuiStyle, scale_factor: f32) {
	ImGuiStyle_ScaleAllSizes(self, scale_factor)
}

add_key_event :: proc(self: ^ImGuiIO, key: ImGuiKey, down: bool) {
	ImGuiIO_AddKeyEvent(self, key, down)
}

add_key_analog_event :: proc(self: ^ImGuiIO, key: ImGuiKey, down: bool, v: f32) {
	ImGuiIO_AddKeyAnalogEvent(self, key, down, v)
}

add_mouse_pos_event :: proc(self: ^ImGuiIO, x: f32, y: f32) {
	ImGuiIO_AddMousePosEvent(self, x, y)
}

add_mouse_button_event :: proc(self: ^ImGuiIO, button: c.int, down: bool) {
	ImGuiIO_AddMouseButtonEvent(self, button, down)
}

add_mouse_wheel_event :: proc(self: ^ImGuiIO, wheel_x: f32, wheel_y: f32) {
	ImGuiIO_AddMouseWheelEvent(self, wheel_x, wheel_y)
}

add_mouse_source_event :: proc(self: ^ImGuiIO, source: ImGuiMouseSource) {
	ImGuiIO_AddMouseSourceEvent(self, source)
}

add_mouse_viewport_event :: proc(self: ^ImGuiIO, id: ImGuiID) {
	ImGuiIO_AddMouseViewportEvent(self, id)
}

add_focus_event :: proc(self: ^ImGuiIO, focused: bool) {
	ImGuiIO_AddFocusEvent(self, focused)
}

add_input_character :: proc(self: ^ImGuiIO, c_: c.uint) {
	ImGuiIO_AddInputCharacter(self, c_)
}

add_input_character_utf16 :: proc(self: ^ImGuiIO, c_: ImWchar16) {
	ImGuiIO_AddInputCharacterUTF16(self, c_)
}

add_input_characters_utf8 :: proc(self: ^ImGuiIO, str: cstring) {
	ImGuiIO_AddInputCharactersUTF8(self, str)
}

set_key_event_native_data :: proc(self: ^ImGuiIO, key: ImGuiKey, native_keycode: c.int, native_scancode: c.int, native_legacy_index: c.int = -1) {
	ImGuiIO_SetKeyEventNativeDataEx(self, key, native_keycode, native_scancode, native_legacy_index)
}

set_app_accepting_events :: proc(self: ^ImGuiIO, accepting_events: bool) {
	ImGuiIO_SetAppAcceptingEvents(self, accepting_events)
}

clear_events_queue :: proc(self: ^ImGuiIO) {
	ImGuiIO_ClearEventsQueue(self)
}

clear_input_keys :: proc(self: ^ImGuiIO) {
	ImGuiIO_ClearInputKeys(self)
}

clear_input_mouse :: proc(self: ^ImGuiIO) {
	ImGuiIO_ClearInputMouse(self)
}

im_gui_input_text_callback_data_delete_chars :: proc(self: ^ImGuiInputTextCallbackData, pos: c.int, bytes_count: c.int) {
	ImGuiInputTextCallbackData_DeleteChars(self, pos, bytes_count)
}

im_gui_input_text_callback_data_insert_chars :: proc(self: ^ImGuiInputTextCallbackData, pos: c.int, text: cstring, text_end: cstring = nil) {
	ImGuiInputTextCallbackData_InsertChars(self, pos, text, text_end)
}

im_gui_input_text_callback_data_select_all :: proc(self: ^ImGuiInputTextCallbackData) {
	ImGuiInputTextCallbackData_SelectAll(self)
}

im_gui_input_text_callback_data_set_selection :: proc(self: ^ImGuiInputTextCallbackData, s: c.int, e: c.int) {
	ImGuiInputTextCallbackData_SetSelection(self, s, e)
}

im_gui_input_text_callback_data_clear_selection :: proc(self: ^ImGuiInputTextCallbackData) {
	ImGuiInputTextCallbackData_ClearSelection(self)
}

im_gui_input_text_callback_data_has_selection :: proc(self: ^ImGuiInputTextCallbackData) -> bool {
	return ImGuiInputTextCallbackData_HasSelection(self)
}

im_gui_payload_clear :: proc(self: ^ImGuiPayload) {
	ImGuiPayload_Clear(self)
}

im_gui_payload_is_data_type :: proc(self: ^ImGuiPayload, type: cstring) -> bool {
	return ImGuiPayload_IsDataType(self, type)
}

im_gui_payload_is_preview :: proc(self: ^ImGuiPayload) -> bool {
	return ImGuiPayload_IsPreview(self)
}

im_gui_payload_is_delivery :: proc(self: ^ImGuiPayload) -> bool {
	return ImGuiPayload_IsDelivery(self)
}

im_gui_text_filter_im_gui_text_range_empty :: proc(self: ^ImGuiTextFilter_ImGuiTextRange) -> bool {
	return ImGuiTextFilter_ImGuiTextRange_empty(self)
}

im_gui_text_filter_im_gui_text_range_split :: proc(self: ^ImGuiTextFilter_ImGuiTextRange, separator: c.char, out: ^ImVector_ImGuiTextRange) {
	ImGuiTextFilter_ImGuiTextRange_split(self, separator, out)
}

im_gui_text_filter_draw :: proc(self: ^ImGuiTextFilter, label: cstring = "Filter (inc,-exc)", width: f32 = 0.0) -> bool {
	return ImGuiTextFilter_Draw(self, label, width)
}

im_gui_text_filter_pass_filter :: proc(self: ^ImGuiTextFilter, text: cstring, text_end: cstring = nil) -> bool {
	return ImGuiTextFilter_PassFilter(self, text, text_end)
}

im_gui_text_filter_build :: proc(self: ^ImGuiTextFilter) {
	ImGuiTextFilter_Build(self)
}

im_gui_text_filter_is_active :: proc(self: ^ImGuiTextFilter) -> bool {
	return ImGuiTextFilter_IsActive(self)
}

im_gui_text_buffer_begin :: proc(self: ^ImGuiTextBuffer) -> cstring {
	return ImGuiTextBuffer_begin(self)
}

im_gui_text_buffer_end :: proc(self: ^ImGuiTextBuffer) -> cstring {
	return ImGuiTextBuffer_end(self)
}

im_gui_text_buffer_size :: proc(self: ^ImGuiTextBuffer) -> c.int {
	return ImGuiTextBuffer_size(self)
}

im_gui_text_buffer_clear :: proc(self: ^ImGuiTextBuffer) {
	ImGuiTextBuffer_clear(self)
}

im_gui_text_buffer_resize :: proc(self: ^ImGuiTextBuffer, size: c.int) {
	ImGuiTextBuffer_resize(self, size)
}

im_gui_text_buffer_reserve :: proc(self: ^ImGuiTextBuffer, capacity: c.int) {
	ImGuiTextBuffer_reserve(self, capacity)
}

im_gui_text_buffer_c_str :: proc(self: ^ImGuiTextBuffer) -> cstring {
	return ImGuiTextBuffer_c_str(self)
}

im_gui_text_buffer_append :: proc(self: ^ImGuiTextBuffer, str: cstring, str_end: cstring = nil) {
	ImGuiTextBuffer_append(self, str, str_end)
}

im_gui_text_buffer_appendfv :: proc(self: ^ImGuiTextBuffer, fmt: cstring, args: c.va_list) {
	ImGuiTextBuffer_appendfv(self, fmt, args)
}

im_gui_storage_get_int :: proc(self: ^ImGuiStorage, key: ImGuiID, default_val: c.int = 0) -> c.int {
	return ImGuiStorage_GetInt(self, key, default_val)
}

im_gui_storage_set_int :: proc(self: ^ImGuiStorage, key: ImGuiID, val: c.int) {
	ImGuiStorage_SetInt(self, key, val)
}

im_gui_storage_get_bool :: proc(self: ^ImGuiStorage, key: ImGuiID, default_val: bool = false) -> bool {
	return ImGuiStorage_GetBool(self, key, default_val)
}

im_gui_storage_set_bool :: proc(self: ^ImGuiStorage, key: ImGuiID, val: bool) {
	ImGuiStorage_SetBool(self, key, val)
}

im_gui_storage_get_float :: proc(self: ^ImGuiStorage, key: ImGuiID, default_val: f32 = 0.0) -> f32 {
	return ImGuiStorage_GetFloat(self, key, default_val)
}

im_gui_storage_set_float :: proc(self: ^ImGuiStorage, key: ImGuiID, val: f32) {
	ImGuiStorage_SetFloat(self, key, val)
}

im_gui_storage_get_void_ptr :: proc(self: ^ImGuiStorage, key: ImGuiID) -> rawptr {
	return ImGuiStorage_GetVoidPtr(self, key)
}

im_gui_storage_set_void_ptr :: proc(self: ^ImGuiStorage, key: ImGuiID, val: rawptr) {
	ImGuiStorage_SetVoidPtr(self, key, val)
}

im_gui_storage_get_int_ref :: proc(self: ^ImGuiStorage, key: ImGuiID, default_val: c.int = 0) -> ^c.int {
	return ImGuiStorage_GetIntRef(self, key, default_val)
}

im_gui_storage_get_bool_ref :: proc(self: ^ImGuiStorage, key: ImGuiID, default_val: bool = false) -> ^bool {
	return ImGuiStorage_GetBoolRef(self, key, default_val)
}

im_gui_storage_get_float_ref :: proc(self: ^ImGuiStorage, key: ImGuiID, default_val: f32 = 0.0) -> ^f32 {
	return ImGuiStorage_GetFloatRef(self, key, default_val)
}

im_gui_storage_get_void_ptr_ref :: proc(self: ^ImGuiStorage, key: ImGuiID, default_val: rawptr = nil) -> ^rawptr {
	return ImGuiStorage_GetVoidPtrRef(self, key, default_val)
}

im_gui_storage_build_sort_by_key :: proc(self: ^ImGuiStorage) {
	ImGuiStorage_BuildSortByKey(self)
}

im_gui_storage_set_all_int :: proc(self: ^ImGuiStorage, val: c.int) {
	ImGuiStorage_SetAllInt(self, val)
}

im_gui_list_clipper_begin :: proc(self: ^ImGuiListClipper, items_count: c.int, items_height: f32 = -1.0) {
	ImGuiListClipper_Begin(self, items_count, items_height)
}

im_gui_list_clipper_end :: proc(self: ^ImGuiListClipper) {
	ImGuiListClipper_End(self)
}

im_gui_list_clipper_step :: proc(self: ^ImGuiListClipper) -> bool {
	return ImGuiListClipper_Step(self)
}

im_gui_list_clipper_include_item_by_index :: proc(self: ^ImGuiListClipper, item_index: c.int) {
	ImGuiListClipper_IncludeItemByIndex(self, item_index)
}

im_gui_list_clipper_include_items_by_index :: proc(self: ^ImGuiListClipper, item_begin: c.int, item_end: c.int) {
	ImGuiListClipper_IncludeItemsByIndex(self, item_begin, item_end)
}

im_gui_list_clipper_seek_cursor_for_item :: proc(self: ^ImGuiListClipper, item_index: c.int) {
	ImGuiListClipper_SeekCursorForItem(self, item_index)
}

im_color_set_hsv :: proc(self: ^ImColor, h: f32, s: f32, v: f32, a: f32 = 1.0) {
	ImColor_SetHSV(self, h, s, v, a)
}

im_color_hsv :: proc(h: f32, s: f32, v: f32, a: f32 = 1.0) -> ImColor {
	return ImColor_HSV(h, s, v, a)
}

im_gui_selection_basic_storage_apply_requests :: proc(self: ^ImGuiSelectionBasicStorage, ms_io: ^ImGuiMultiSelectIO) {
	ImGuiSelectionBasicStorage_ApplyRequests(self, ms_io)
}

im_gui_selection_basic_storage_contains :: proc(self: ^ImGuiSelectionBasicStorage, id: ImGuiID) -> bool {
	return ImGuiSelectionBasicStorage_Contains(self, id)
}

im_gui_selection_basic_storage_swap :: proc(self: ^ImGuiSelectionBasicStorage, r: ^ImGuiSelectionBasicStorage) {
	ImGuiSelectionBasicStorage_Swap(self, r)
}

im_gui_selection_basic_storage_set_item_selected :: proc(self: ^ImGuiSelectionBasicStorage, id: ImGuiID, selected: bool) {
	ImGuiSelectionBasicStorage_SetItemSelected(self, id, selected)
}

im_gui_selection_basic_storage_get_next_selected_item :: proc(self: ^ImGuiSelectionBasicStorage, opaque_it: ^rawptr, out_id: ^ImGuiID) -> bool {
	return ImGuiSelectionBasicStorage_GetNextSelectedItem(self, opaque_it, out_id)
}

im_gui_selection_basic_storage_get_storage_id_from_index :: proc(self: ^ImGuiSelectionBasicStorage, idx: c.int) -> ImGuiID {
	return ImGuiSelectionBasicStorage_GetStorageIdFromIndex(self, idx)
}

im_draw_list_splitter_clear_free_memory :: proc(self: ^ImDrawListSplitter) {
	ImDrawListSplitter_ClearFreeMemory(self)
}

im_draw_list_splitter_split :: proc(self: ^ImDrawListSplitter, draw_list: ^ImDrawList, count: c.int) {
	ImDrawListSplitter_Split(self, draw_list, count)
}

im_draw_list_splitter_merge :: proc(self: ^ImDrawListSplitter, draw_list: ^ImDrawList) {
	ImDrawListSplitter_Merge(self, draw_list)
}

im_draw_list_splitter_set_current_channel :: proc(self: ^ImDrawListSplitter, draw_list: ^ImDrawList, channel_idx: c.int) {
	ImDrawListSplitter_SetCurrentChannel(self, draw_list, channel_idx)
}

im_draw_list_push_clip_rect :: proc(self: ^ImDrawList, clip_rect_min: ImVec2, clip_rect_max: ImVec2, intersect_with_current_clip_rect: bool = false) {
	ImDrawList_PushClipRect(self, clip_rect_min, clip_rect_max, intersect_with_current_clip_rect)
}

push_clip_rect_full_screen :: proc(self: ^ImDrawList) {
	ImDrawList_PushClipRectFullScreen(self)
}

im_draw_list_pop_clip_rect :: proc(self: ^ImDrawList) {
	ImDrawList_PopClipRect(self)
}

push_texture :: proc(self: ^ImDrawList, tex_ref: ImTextureRef) {
	ImDrawList_PushTexture(self, tex_ref)
}

pop_texture :: proc(self: ^ImDrawList) {
	ImDrawList_PopTexture(self)
}

get_clip_rect_min :: proc(self: ^ImDrawList) -> ImVec2 {
	return ImDrawList_GetClipRectMin(self)
}

get_clip_rect_max :: proc(self: ^ImDrawList) -> ImVec2 {
	return ImDrawList_GetClipRectMax(self)
}

add_line :: proc(self: ^ImDrawList, p1: ImVec2, p2: ImVec2, col: ImU32, thickness: f32 = 1.0) {
	ImDrawList_AddLineEx(self, p1, p2, col, thickness)
}

add_line_h :: proc(self: ^ImDrawList, min_x: f32, max_x: f32, y: f32, col: ImU32, thickness: f32 = 1.0) {
	ImDrawList_AddLineHEx(self, min_x, max_x, y, col, thickness)
}

add_line_v :: proc(self: ^ImDrawList, x: f32, min_y: f32, max_y: f32, col: ImU32, thickness: f32 = 1.0) {
	ImDrawList_AddLineVEx(self, x, min_y, max_y, col, thickness)
}

add_rect :: proc(self: ^ImDrawList, p_min: ImVec2, p_max: ImVec2, col: ImU32, rounding: f32 = 0.0, thickness: f32 = 1.0, flags: ImDrawFlags = 0) {
	ImDrawList_AddRectEx(self, p_min, p_max, col, rounding, thickness, flags)
}

add_rect_filled :: proc(self: ^ImDrawList, p_min: ImVec2, p_max: ImVec2, col: ImU32, rounding: f32 = 0.0, flags: ImDrawFlags = 0) {
	ImDrawList_AddRectFilledEx(self, p_min, p_max, col, rounding, flags)
}

add_rect_filled_multi_color :: proc(self: ^ImDrawList, p_min: ImVec2, p_max: ImVec2, col_upr_left: ImU32, col_upr_right: ImU32, col_bot_right: ImU32, col_bot_left: ImU32) {
	ImDrawList_AddRectFilledMultiColor(self, p_min, p_max, col_upr_left, col_upr_right, col_bot_right, col_bot_left)
}

add_quad :: proc(self: ^ImDrawList, p1: ImVec2, p2: ImVec2, p3: ImVec2, p4: ImVec2, col: ImU32, thickness: f32 = 1.0) {
	ImDrawList_AddQuadEx(self, p1, p2, p3, p4, col, thickness)
}

add_quad_filled :: proc(self: ^ImDrawList, p1: ImVec2, p2: ImVec2, p3: ImVec2, p4: ImVec2, col: ImU32) {
	ImDrawList_AddQuadFilled(self, p1, p2, p3, p4, col)
}

add_triangle :: proc(self: ^ImDrawList, p1: ImVec2, p2: ImVec2, p3: ImVec2, col: ImU32, thickness: f32 = 1.0) {
	ImDrawList_AddTriangleEx(self, p1, p2, p3, col, thickness)
}

add_triangle_filled :: proc(self: ^ImDrawList, p1: ImVec2, p2: ImVec2, p3: ImVec2, col: ImU32) {
	ImDrawList_AddTriangleFilled(self, p1, p2, p3, col)
}

add_circle :: proc(self: ^ImDrawList, center: ImVec2, radius: f32, col: ImU32, num_segments: c.int = 0, thickness: f32 = 1.0) {
	ImDrawList_AddCircleEx(self, center, radius, col, num_segments, thickness)
}

add_circle_filled :: proc(self: ^ImDrawList, center: ImVec2, radius: f32, col: ImU32, num_segments: c.int = 0) {
	ImDrawList_AddCircleFilled(self, center, radius, col, num_segments)
}

add_ngon :: proc(self: ^ImDrawList, center: ImVec2, radius: f32, col: ImU32, num_segments: c.int, thickness: f32 = 1.0) {
	ImDrawList_AddNgonEx(self, center, radius, col, num_segments, thickness)
}

add_ngon_filled :: proc(self: ^ImDrawList, center: ImVec2, radius: f32, col: ImU32, num_segments: c.int) {
	ImDrawList_AddNgonFilled(self, center, radius, col, num_segments)
}

add_ellipse :: proc(self: ^ImDrawList, center: ImVec2, radius: ImVec2, col: ImU32, rot: f32 = 0.0, num_segments: c.int = 0, thickness: f32 = 1.0) {
	ImDrawList_AddEllipseEx(self, center, radius, col, rot, num_segments, thickness)
}

add_ellipse_filled :: proc(self: ^ImDrawList, center: ImVec2, radius: ImVec2, col: ImU32, rot: f32 = 0.0, num_segments: c.int = 0) {
	ImDrawList_AddEllipseFilledEx(self, center, radius, col, rot, num_segments)
}

add_text_im_font_ptr :: proc(self: ^ImDrawList, font: ^ImFont, font_size: f32, pos: ImVec2, col: ImU32, text_begin: cstring, text_end: cstring = nil, wrap_width: f32 = 0.0, cpu_fine_clip_rect: ^ImVec4 = nil) {
	ImDrawList_AddTextImFontPtrEx(self, font, font_size, pos, col, text_begin, text_end, wrap_width, cpu_fine_clip_rect)
}

add_bezier_cubic :: proc(self: ^ImDrawList, p1: ImVec2, p2: ImVec2, p3: ImVec2, p4: ImVec2, col: ImU32, thickness: f32, num_segments: c.int = 0) {
	ImDrawList_AddBezierCubic(self, p1, p2, p3, p4, col, thickness, num_segments)
}

add_bezier_quadratic :: proc(self: ^ImDrawList, p1: ImVec2, p2: ImVec2, p3: ImVec2, col: ImU32, thickness: f32, num_segments: c.int = 0) {
	ImDrawList_AddBezierQuadratic(self, p1, p2, p3, col, thickness, num_segments)
}

add_polyline :: proc(self: ^ImDrawList, points: ^ImVec2, num_points: c.int, col: ImU32, thickness: f32, flags: ImDrawFlags = 0) {
	ImDrawList_AddPolyline(self, points, num_points, col, thickness, flags)
}

add_convex_poly_filled :: proc(self: ^ImDrawList, points: ^ImVec2, num_points: c.int, col: ImU32) {
	ImDrawList_AddConvexPolyFilled(self, points, num_points, col)
}

add_concave_poly_filled :: proc(self: ^ImDrawList, points: ^ImVec2, num_points: c.int, col: ImU32) {
	ImDrawList_AddConcavePolyFilled(self, points, num_points, col)
}

add_image :: proc(self: ^ImDrawList, tex_ref: ImTextureRef, p_min: ImVec2, p_max: ImVec2, uv_min: ImVec2 = ImVec2{0, 0}, uv_max: ImVec2 = ImVec2{1, 1}, col: ImU32 = IM_COL32_WHITE) {
	ImDrawList_AddImageEx(self, tex_ref, p_min, p_max, uv_min, uv_max, col)
}

add_image_quad :: proc(self: ^ImDrawList, tex_ref: ImTextureRef, p1: ImVec2, p2: ImVec2, p3: ImVec2, p4: ImVec2, uv1: ImVec2 = ImVec2{0, 0}, uv2: ImVec2 = ImVec2{1, 0}, uv3: ImVec2 = ImVec2{1, 1}, uv4: ImVec2 = ImVec2{0, 1}, col: ImU32 = IM_COL32_WHITE) {
	ImDrawList_AddImageQuadEx(self, tex_ref, p1, p2, p3, p4, uv1, uv2, uv3, uv4, col)
}

add_image_rounded :: proc(self: ^ImDrawList, tex_ref: ImTextureRef, p_min: ImVec2, p_max: ImVec2, uv_min: ImVec2, uv_max: ImVec2, col: ImU32, rounding: f32, flags: ImDrawFlags = 0) {
	ImDrawList_AddImageRounded(self, tex_ref, p_min, p_max, uv_min, uv_max, col, rounding, flags)
}

path_clear :: proc(self: ^ImDrawList) {
	ImDrawList_PathClear(self)
}

path_line_to :: proc(self: ^ImDrawList, pos: ImVec2) {
	ImDrawList_PathLineTo(self, pos)
}

path_line_to_merge_duplicate :: proc(self: ^ImDrawList, pos: ImVec2) {
	ImDrawList_PathLineToMergeDuplicate(self, pos)
}

path_fill_convex :: proc(self: ^ImDrawList, col: ImU32) {
	ImDrawList_PathFillConvex(self, col)
}

path_fill_concave :: proc(self: ^ImDrawList, col: ImU32) {
	ImDrawList_PathFillConcave(self, col)
}

path_stroke :: proc(self: ^ImDrawList, col: ImU32, thickness: f32 = 1.0, flags: ImDrawFlags = 0) {
	ImDrawList_PathStroke(self, col, thickness, flags)
}

path_arc_to :: proc(self: ^ImDrawList, center: ImVec2, radius: f32, a_min: f32, a_max: f32, num_segments: c.int = 0) {
	ImDrawList_PathArcTo(self, center, radius, a_min, a_max, num_segments)
}

path_arc_to_fast :: proc(self: ^ImDrawList, center: ImVec2, radius: f32, a_min_of_12: c.int, a_max_of_12: c.int) {
	ImDrawList_PathArcToFast(self, center, radius, a_min_of_12, a_max_of_12)
}

path_elliptical_arc_to :: proc(self: ^ImDrawList, center: ImVec2, radius: ImVec2, rot: f32, a_min: f32, a_max: f32, num_segments: c.int = 0) {
	ImDrawList_PathEllipticalArcToEx(self, center, radius, rot, a_min, a_max, num_segments)
}

path_bezier_cubic_curve_to :: proc(self: ^ImDrawList, p2: ImVec2, p3: ImVec2, p4: ImVec2, num_segments: c.int = 0) {
	ImDrawList_PathBezierCubicCurveTo(self, p2, p3, p4, num_segments)
}

path_bezier_quadratic_curve_to :: proc(self: ^ImDrawList, p2: ImVec2, p3: ImVec2, num_segments: c.int = 0) {
	ImDrawList_PathBezierQuadraticCurveTo(self, p2, p3, num_segments)
}

path_rect :: proc(self: ^ImDrawList, rect_min: ImVec2, rect_max: ImVec2, rounding: f32 = 0.0, flags: ImDrawFlags = 0) {
	ImDrawList_PathRect(self, rect_min, rect_max, rounding, flags)
}

add_callback :: proc(self: ^ImDrawList, callback: ImDrawCallback, userdata: rawptr = nil, userdata_size: c.size_t = 0) {
	ImDrawList_AddCallbackEx(self, callback, userdata, userdata_size)
}

add_draw_cmd :: proc(self: ^ImDrawList) {
	ImDrawList_AddDrawCmd(self)
}

clone_output :: proc(self: ^ImDrawList) -> ^ImDrawList {
	return ImDrawList_CloneOutput(self)
}

channels_split :: proc(self: ^ImDrawList, count: c.int) {
	ImDrawList_ChannelsSplit(self, count)
}

channels_merge :: proc(self: ^ImDrawList) {
	ImDrawList_ChannelsMerge(self)
}

channels_set_current :: proc(self: ^ImDrawList, n: c.int) {
	ImDrawList_ChannelsSetCurrent(self, n)
}

prim_reserve :: proc(self: ^ImDrawList, idx_count: c.int, vtx_count: c.int) {
	ImDrawList_PrimReserve(self, idx_count, vtx_count)
}

prim_unreserve :: proc(self: ^ImDrawList, idx_count: c.int, vtx_count: c.int) {
	ImDrawList_PrimUnreserve(self, idx_count, vtx_count)
}

prim_rect :: proc(self: ^ImDrawList, a: ImVec2, b: ImVec2, col: ImU32) {
	ImDrawList_PrimRect(self, a, b, col)
}

prim_rect_uv :: proc(self: ^ImDrawList, a: ImVec2, b: ImVec2, uv_a: ImVec2, uv_b: ImVec2, col: ImU32) {
	ImDrawList_PrimRectUV(self, a, b, uv_a, uv_b, col)
}

prim_quad_uv :: proc(self: ^ImDrawList, a: ImVec2, b: ImVec2, c_: ImVec2, d: ImVec2, uv_a: ImVec2, uv_b: ImVec2, uv_c: ImVec2, uv_d: ImVec2, col: ImU32) {
	ImDrawList_PrimQuadUV(self, a, b, c_, d, uv_a, uv_b, uv_c, uv_d, col)
}

prim_write_vtx :: proc(self: ^ImDrawList, pos: ImVec2, uv: ImVec2, col: ImU32) {
	ImDrawList_PrimWriteVtx(self, pos, uv, col)
}

prim_write_idx :: proc(self: ^ImDrawList, idx: ImDrawIdx) {
	ImDrawList_PrimWriteIdx(self, idx)
}

prim_vtx :: proc(self: ^ImDrawList, pos: ImVec2, uv: ImVec2, col: ImU32) {
	ImDrawList_PrimVtx(self, pos, uv, col)
}

push_texture_id :: proc(self: ^ImDrawList, tex_ref: ImTextureRef) {
	ImDrawList_PushTextureID(self, tex_ref)
}

pop_texture_id :: proc(self: ^ImDrawList) {
	ImDrawList_PopTextureID(self)
}

set_draw_list_shared_data :: proc(self: ^ImDrawList, data: ^ImDrawListSharedData) {
	ImDrawList__SetDrawListSharedData(self, data)
}

reset_for_new_frame :: proc(self: ^ImDrawList) {
	ImDrawList__ResetForNewFrame(self)
}

clear_free_memory :: proc(self: ^ImDrawList) {
	ImDrawList__ClearFreeMemory(self)
}

pop_unused_draw_cmd :: proc(self: ^ImDrawList) {
	ImDrawList__PopUnusedDrawCmd(self)
}

try_merge_draw_cmds :: proc(self: ^ImDrawList) {
	ImDrawList__TryMergeDrawCmds(self)
}

on_changed_clip_rect :: proc(self: ^ImDrawList) {
	ImDrawList__OnChangedClipRect(self)
}

on_changed_texture :: proc(self: ^ImDrawList) {
	ImDrawList__OnChangedTexture(self)
}

on_changed_vtx_offset :: proc(self: ^ImDrawList) {
	ImDrawList__OnChangedVtxOffset(self)
}

set_texture :: proc(self: ^ImDrawList, tex_ref: ImTextureRef) {
	ImDrawList__SetTexture(self, tex_ref)
}

calc_circle_auto_segment_count :: proc(self: ^ImDrawList, radius: f32) -> c.int {
	return ImDrawList__CalcCircleAutoSegmentCount(self, radius)
}

im_draw_list_path_arc_to_fast_ex :: proc(self: ^ImDrawList, center: ImVec2, radius: f32, a_min_sample: c.int, a_max_sample: c.int, a_step: c.int) {
	ImDrawList__PathArcToFastEx(self, center, radius, a_min_sample, a_max_sample, a_step)
}

path_arc_to_n :: proc(self: ^ImDrawList, center: ImVec2, radius: f32, a_min: f32, a_max: f32, num_segments: c.int) {
	ImDrawList__PathArcToN(self, center, radius, a_min, a_max, num_segments)
}

add_draw_list :: proc(self: ^ImDrawData, draw_list: ^ImDrawList) {
	ImDrawData_AddDrawList(self, draw_list)
}

de_index_all_buffers :: proc(self: ^ImDrawData) {
	ImDrawData_DeIndexAllBuffers(self)
}

scale_clip_rects :: proc(self: ^ImDrawData, fb_scale: ImVec2) {
	ImDrawData_ScaleClipRects(self, fb_scale)
}

im_texture_data_create :: proc(self: ^ImTextureData, format: ImTextureFormat, w: c.int, h: c.int) {
	ImTextureData_Create(self, format, w, h)
}

im_texture_data_destroy_pixels :: proc(self: ^ImTextureData) {
	ImTextureData_DestroyPixels(self)
}

im_texture_data_get_pixels :: proc(self: ^ImTextureData) -> rawptr {
	return ImTextureData_GetPixels(self)
}

im_texture_data_get_pixels_at :: proc(self: ^ImTextureData, x: c.int, y: c.int) -> rawptr {
	return ImTextureData_GetPixelsAt(self, x, y)
}

im_texture_data_get_size_in_bytes :: proc(self: ^ImTextureData) -> c.int {
	return ImTextureData_GetSizeInBytes(self)
}

im_texture_data_get_pitch :: proc(self: ^ImTextureData) -> c.int {
	return ImTextureData_GetPitch(self)
}

im_texture_data_get_tex_ref :: proc(self: ^ImTextureData) -> ImTextureRef {
	return ImTextureData_GetTexRef(self)
}

im_texture_data_set_tex_id :: proc(self: ^ImTextureData, tex_id: ImTextureID) {
	ImTextureData_SetTexID(self, tex_id)
}

im_texture_data_set_status :: proc(self: ^ImTextureData, status: ImTextureStatus) {
	ImTextureData_SetStatus(self, status)
}

im_font_glyph_ranges_builder_get_bit :: proc(self: ^ImFontGlyphRangesBuilder, n: c.size_t) -> bool {
	return ImFontGlyphRangesBuilder_GetBit(self, n)
}

im_font_glyph_ranges_builder_set_bit :: proc(self: ^ImFontGlyphRangesBuilder, n: c.size_t) {
	ImFontGlyphRangesBuilder_SetBit(self, n)
}

im_font_glyph_ranges_builder_add_char :: proc(self: ^ImFontGlyphRangesBuilder, c_: ImWchar) {
	ImFontGlyphRangesBuilder_AddChar(self, c_)
}

im_font_glyph_ranges_builder_add_ranges :: proc(self: ^ImFontGlyphRangesBuilder, ranges: ^ImWchar) {
	ImFontGlyphRangesBuilder_AddRanges(self, ranges)
}

im_font_glyph_ranges_builder_build_ranges :: proc(self: ^ImFontGlyphRangesBuilder, out_ranges: ^ImVector_ImWchar) {
	ImFontGlyphRangesBuilder_BuildRanges(self, out_ranges)
}

add_font :: proc(self: ^ImFontAtlas, font_cfg: ^ImFontConfig) -> ^ImFont {
	return ImFontAtlas_AddFont(self, font_cfg)
}

add_font_default :: proc(self: ^ImFontAtlas, font_cfg: ^ImFontConfig = nil) -> ^ImFont {
	return ImFontAtlas_AddFontDefault(self, font_cfg)
}

add_font_default_vector :: proc(self: ^ImFontAtlas, font_cfg: ^ImFontConfig = nil) -> ^ImFont {
	return ImFontAtlas_AddFontDefaultVector(self, font_cfg)
}

add_font_default_bitmap :: proc(self: ^ImFontAtlas, font_cfg: ^ImFontConfig = nil) -> ^ImFont {
	return ImFontAtlas_AddFontDefaultBitmap(self, font_cfg)
}

add_font_from_file_ttf :: proc(self: ^ImFontAtlas, filename: cstring, size_pixels: f32 = 0.0, font_cfg: ^ImFontConfig = nil, glyph_ranges: ^ImWchar = nil) -> ^ImFont {
	return ImFontAtlas_AddFontFromFileTTF(self, filename, size_pixels, font_cfg, glyph_ranges)
}

add_font_from_memory_ttf :: proc(self: ^ImFontAtlas, font_data: rawptr, font_data_size: c.int, size_pixels: f32 = 0.0, font_cfg: ^ImFontConfig = nil, glyph_ranges: ^ImWchar = nil) -> ^ImFont {
	return ImFontAtlas_AddFontFromMemoryTTF(self, font_data, font_data_size, size_pixels, font_cfg, glyph_ranges)
}

add_font_from_memory_compressed_ttf :: proc(self: ^ImFontAtlas, compressed_font_data: rawptr, compressed_font_data_size: c.int, size_pixels: f32 = 0.0, font_cfg: ^ImFontConfig = nil, glyph_ranges: ^ImWchar = nil) -> ^ImFont {
	return ImFontAtlas_AddFontFromMemoryCompressedTTF(self, compressed_font_data, compressed_font_data_size, size_pixels, font_cfg, glyph_ranges)
}

add_font_from_memory_compressed_base85_ttf :: proc(self: ^ImFontAtlas, compressed_font_data_base85: cstring, size_pixels: f32 = 0.0, font_cfg: ^ImFontConfig = nil, glyph_ranges: ^ImWchar = nil) -> ^ImFont {
	return ImFontAtlas_AddFontFromMemoryCompressedBase85TTF(self, compressed_font_data_base85, size_pixels, font_cfg, glyph_ranges)
}

remove_font :: proc(self: ^ImFontAtlas, font: ^ImFont) {
	ImFontAtlas_RemoveFont(self, font)
}

clear_fonts :: proc(self: ^ImFontAtlas) {
	ImFontAtlas_ClearFonts(self)
}

compact_cache :: proc(self: ^ImFontAtlas) {
	ImFontAtlas_CompactCache(self)
}

set_font_loader :: proc(self: ^ImFontAtlas, font_loader: ^ImFontLoader) {
	ImFontAtlas_SetFontLoader(self, font_loader)
}

clear_input_data :: proc(self: ^ImFontAtlas) {
	ImFontAtlas_ClearInputData(self)
}

clear_tex_data :: proc(self: ^ImFontAtlas) {
	ImFontAtlas_ClearTexData(self)
}

get_tex_data_as_alpha8 :: proc(self: ^ImFontAtlas, out_pixels: ^^u8, out_width: ^c.int, out_height: ^c.int, out_bytes_per_pixel: ^c.int = nil) {
	ImFontAtlas_GetTexDataAsAlpha8(self, out_pixels, out_width, out_height, out_bytes_per_pixel)
}

get_tex_data_as_rgba32 :: proc(self: ^ImFontAtlas, out_pixels: ^^u8, out_width: ^c.int, out_height: ^c.int, out_bytes_per_pixel: ^c.int = nil) {
	ImFontAtlas_GetTexDataAsRGBA32(self, out_pixels, out_width, out_height, out_bytes_per_pixel)
}

is_built :: proc(self: ^ImFontAtlas) -> bool {
	return ImFontAtlas_IsBuilt(self)
}

get_glyph_ranges_default :: proc(self: ^ImFontAtlas) -> ^ImWchar {
	return ImFontAtlas_GetGlyphRangesDefault(self)
}

get_glyph_ranges_greek :: proc(self: ^ImFontAtlas) -> ^ImWchar {
	return ImFontAtlas_GetGlyphRangesGreek(self)
}

get_glyph_ranges_korean :: proc(self: ^ImFontAtlas) -> ^ImWchar {
	return ImFontAtlas_GetGlyphRangesKorean(self)
}

get_glyph_ranges_japanese :: proc(self: ^ImFontAtlas) -> ^ImWchar {
	return ImFontAtlas_GetGlyphRangesJapanese(self)
}

get_glyph_ranges_chinese_full :: proc(self: ^ImFontAtlas) -> ^ImWchar {
	return ImFontAtlas_GetGlyphRangesChineseFull(self)
}

get_glyph_ranges_chinese_simplified_common :: proc(self: ^ImFontAtlas) -> ^ImWchar {
	return ImFontAtlas_GetGlyphRangesChineseSimplifiedCommon(self)
}

get_glyph_ranges_cyrillic :: proc(self: ^ImFontAtlas) -> ^ImWchar {
	return ImFontAtlas_GetGlyphRangesCyrillic(self)
}

get_glyph_ranges_thai :: proc(self: ^ImFontAtlas) -> ^ImWchar {
	return ImFontAtlas_GetGlyphRangesThai(self)
}

get_glyph_ranges_vietnamese :: proc(self: ^ImFontAtlas) -> ^ImWchar {
	return ImFontAtlas_GetGlyphRangesVietnamese(self)
}

add_custom_rect :: proc(self: ^ImFontAtlas, width: c.int, height: c.int, out_r: ^ImFontAtlasRect = nil) -> ImFontAtlasRectId {
	return ImFontAtlas_AddCustomRect(self, width, height, out_r)
}

remove_custom_rect :: proc(self: ^ImFontAtlas, id: ImFontAtlasRectId) {
	ImFontAtlas_RemoveCustomRect(self, id)
}

get_custom_rect :: proc(self: ^ImFontAtlas, id: ImFontAtlasRectId, out_r: ^ImFontAtlasRect) -> bool {
	return ImFontAtlas_GetCustomRect(self, id, out_r)
}

add_custom_rect_regular :: proc(self: ^ImFontAtlas, w: c.int, h: c.int) -> ImFontAtlasRectId {
	return ImFontAtlas_AddCustomRectRegular(self, w, h)
}

get_custom_rect_by_index :: proc(self: ^ImFontAtlas, id: ImFontAtlasRectId) -> ^ImFontAtlasRect {
	return ImFontAtlas_GetCustomRectByIndex(self, id)
}

calc_custom_rect_uv :: proc(self: ^ImFontAtlas, r: ^ImFontAtlasRect, out_uv_min: ^ImVec2, out_uv_max: ^ImVec2) {
	ImFontAtlas_CalcCustomRectUV(self, r, out_uv_min, out_uv_max)
}

add_custom_rect_font_glyph :: proc(self: ^ImFontAtlas, font: ^ImFont, codepoint: ImWchar, w: c.int, h: c.int, advance_x: f32, offset: ImVec2 = ImVec2{0, 0}) -> ImFontAtlasRectId {
	return ImFontAtlas_AddCustomRectFontGlyph(self, font, codepoint, w, h, advance_x, offset)
}

add_custom_rect_font_glyph_for_size :: proc(self: ^ImFontAtlas, font: ^ImFont, font_size: f32, codepoint: ImWchar, w: c.int, h: c.int, advance_x: f32, offset: ImVec2 = ImVec2{0, 0}) -> ImFontAtlasRectId {
	return ImFontAtlas_AddCustomRectFontGlyphForSize(self, font, font_size, codepoint, w, h, advance_x, offset)
}

im_font_baked_clear_output_data :: proc(self: ^ImFontBaked) {
	ImFontBaked_ClearOutputData(self)
}

im_font_baked_find_glyph :: proc(self: ^ImFontBaked, c_: ImWchar) -> ^ImFontGlyph {
	return ImFontBaked_FindGlyph(self, c_)
}

im_font_baked_find_glyph_no_fallback :: proc(self: ^ImFontBaked, c_: ImWchar) -> ^ImFontGlyph {
	return ImFontBaked_FindGlyphNoFallback(self, c_)
}

im_font_baked_get_char_advance :: proc(self: ^ImFontBaked, c_: ImWchar) -> f32 {
	return ImFontBaked_GetCharAdvance(self, c_)
}

im_font_baked_is_glyph_loaded :: proc(self: ^ImFontBaked, c_: ImWchar) -> bool {
	return ImFontBaked_IsGlyphLoaded(self, c_)
}

is_glyph_in_font :: proc(self: ^ImFont, c_: ImWchar) -> bool {
	return ImFont_IsGlyphInFont(self, c_)
}

is_loaded :: proc(self: ^ImFont) -> bool {
	return ImFont_IsLoaded(self)
}

get_debug_name :: proc(self: ^ImFont) -> cstring {
	return ImFont_GetDebugName(self)
}

im_font_get_font_baked_ex :: proc(self: ^ImFont, font_size: f32, density: f32 = -1.0) -> ^ImFontBaked {
	return ImFont_GetFontBakedEx(self, font_size, density)
}

calc_text_size_a :: proc(self: ^ImFont, size: f32, max_width: f32, wrap_width: f32, text_begin: cstring, text_end: cstring = nil, out_remaining: ^cstring = nil) -> ImVec2 {
	return ImFont_CalcTextSizeAEx(self, size, max_width, wrap_width, text_begin, text_end, out_remaining)
}

calc_word_wrap_position :: proc(self: ^ImFont, size: f32, text: cstring, text_end: cstring, wrap_width: f32) -> cstring {
	return ImFont_CalcWordWrapPosition(self, size, text, text_end, wrap_width)
}

render_char :: proc(self: ^ImFont, draw_list: ^ImDrawList, size: f32, pos: ImVec2, col: ImU32, c_: ImWchar, cpu_fine_clip: ^ImVec4 = nil) {
	ImFont_RenderCharEx(self, draw_list, size, pos, col, c_, cpu_fine_clip)
}

render_text :: proc(self: ^ImFont, draw_list: ^ImDrawList, size: f32, pos: ImVec2, col: ImU32, clip_rect: ImVec4, text_begin: cstring, text_end: cstring, wrap_width: f32 = 0.0, flags: ImDrawTextFlags = 0) {
	ImFont_RenderText(self, draw_list, size, pos, col, clip_rect, text_begin, text_end, wrap_width, flags)
}

calc_word_wrap_position_a :: proc(self: ^ImFont, scale: f32, text: cstring, text_end: cstring, wrap_width: f32) -> cstring {
	return ImFont_CalcWordWrapPositionA(self, scale, text, text_end, wrap_width)
}

add_remap_char :: proc(self: ^ImFont, from_codepoint: ImWchar, to_codepoint: ImWchar) {
	ImFont_AddRemapChar(self, from_codepoint, to_codepoint)
}

is_glyph_range_unused :: proc(self: ^ImFont, c_begin: c.uint, c_last: c.uint) -> bool {
	return ImFont_IsGlyphRangeUnused(self, c_begin, c_last)
}

im_gui_viewport_get_center :: proc(self: ^ImGuiViewport) -> ImVec2 {
	return ImGuiViewport_GetCenter(self)
}

im_gui_viewport_get_work_center :: proc(self: ^ImGuiViewport) -> ImVec2 {
	return ImGuiViewport_GetWorkCenter(self)
}

im_gui_platform_io_clear_platform_handlers :: proc(self: ^ImGuiPlatformIO) {
	ImGuiPlatformIO_ClearPlatformHandlers(self)
}

im_gui_platform_io_clear_renderer_handlers :: proc(self: ^ImGuiPlatformIO) {
	ImGuiPlatformIO_ClearRendererHandlers(self)
}

set_window_font_scale :: proc(scale: f32) {
	ImGui_SetWindowFontScale(scale)
}

push_button_repeat :: proc(repeat: bool) {
	ImGui_PushButtonRepeat(repeat)
}

pop_button_repeat :: proc() {
	ImGui_PopButtonRepeat()
}

push_tab_stop :: proc(tab_stop: bool) {
	ImGui_PushTabStop(tab_stop)
}

pop_tab_stop :: proc() {
	ImGui_PopTabStop()
}

get_content_region_max :: proc() -> ImVec2 {
	return ImGui_GetContentRegionMax()
}

get_window_content_region_min :: proc() -> ImVec2 {
	return ImGui_GetWindowContentRegionMin()
}

get_window_content_region_max :: proc() -> ImVec2 {
	return ImGui_GetWindowContentRegionMax()
}

text :: proc(format: string, args: ..any) {
	ImGui_Text("%s", fmt.ctprintf(format, ..args))
}

text_colored :: proc(col: ImVec4, format: string, args: ..any) {
	ImGui_TextColored(col, "%s", fmt.ctprintf(format, ..args))
}

text_disabled :: proc(format: string, args: ..any) {
	ImGui_TextDisabled("%s", fmt.ctprintf(format, ..args))
}

text_wrapped :: proc(format: string, args: ..any) {
	ImGui_TextWrapped("%s", fmt.ctprintf(format, ..args))
}

label_text :: proc(label: cstring, format: string, args: ..any) {
	ImGui_LabelText(label, "%s", fmt.ctprintf(format, ..args))
}

bullet_text :: proc(format: string, args: ..any) {
	ImGui_BulletText("%s", fmt.ctprintf(format, ..args))
}

tree_node_str :: proc(str_id: cstring, format: string, args: ..any) -> bool {
	return ImGui_TreeNodeStr(str_id, "%s", fmt.ctprintf(format, ..args))
}

tree_node_ptr :: proc(ptr_id: rawptr, format: string, args: ..any) -> bool {
	return ImGui_TreeNodePtr(ptr_id, "%s", fmt.ctprintf(format, ..args))
}

tree_node_ex_str :: proc(str_id: cstring, flags: ImGuiTreeNodeFlags, format: string, args: ..any) -> bool {
	return ImGui_TreeNodeExStr(str_id, flags, "%s", fmt.ctprintf(format, ..args))
}

tree_node_ex_ptr :: proc(ptr_id: rawptr, flags: ImGuiTreeNodeFlags, format: string, args: ..any) -> bool {
	return ImGui_TreeNodeExPtr(ptr_id, flags, "%s", fmt.ctprintf(format, ..args))
}

set_tooltip :: proc(format: string, args: ..any) {
	ImGui_SetTooltip("%s", fmt.ctprintf(format, ..args))
}

set_item_tooltip :: proc(format: string, args: ..any) {
	ImGui_SetItemTooltip("%s", fmt.ctprintf(format, ..args))
}

log_text :: proc(format: string, args: ..any) {
	ImGui_LogText("%s", fmt.ctprintf(format, ..args))
}

debug_log :: proc(format: string, args: ..any) {
	ImGui_DebugLog("%s", fmt.ctprintf(format, ..args))
}
