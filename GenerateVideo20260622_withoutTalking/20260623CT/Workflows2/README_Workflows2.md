# Workflows2 - CT 长镜头一致性版本

## 包含文件
- `02b_hospital_ct_flux_actionchain_keyframes_workflow.json`
- `03c_hospital_ct_wan22_actionchain_longshot_workflow.json`
- `copy_02b_actionchain_keyframes_to_comfy_input.ps1`

## 使用顺序
1. 保留并复用原来的 `01_hospital_ct_reference_generate_workflow.json`。
2. 确认 5 张参考图已经在 ComfyUI/input：
   - `CHAR-NURSE_reference.png`
   - `CHAR-PATIENT_reference.png`
   - `SCN-RAD-DEPT_reference.png`
   - `SCN-CT-ROOM_reference.png`
   - `PROP-CT_reference.png`
3. 运行 `02b_hospital_ct_flux_actionchain_keyframes_workflow.json`，生成 26 张动作链关键帧。
4. 运行 `copy_02b_actionchain_keyframes_to_comfy_input.ps1`，把关键帧复制到 ComfyUI/input。
5. 运行 `03c_hospital_ct_wan22_actionchain_longshot_workflow.json`，生成 21 个小步动作视频段。

## 为什么更稳
- 旧版 02 只有 12 张大跨度关键帧，人物、景别、场景变化太大。
- 新版 02b 生成更细的动作链，例如“站立 -> 坐下 -> 躺下 -> 摆位 -> 进机”。
- 新版 03c 只连接差异较小的相邻动作帧，不再强行让走廊、特写、CT 室之间互相融图。

## 输出目录
- 02b 关键帧：`ComfyUI/output/story_pipeline_ct_actionchain_keyframes`
- 03c 视频段：`ComfyUI/output/story_pipeline_ct_actionchain_videos`

## 备注
- 这不是云服务，仍然全部使用本地 FLUX.1-dev + IPAdapter Flux + Wan2.2。
- 如果某段仍然变脸，优先重跑对应的 02b 两张关键帧，让首尾图更接近，再跑 03c。
