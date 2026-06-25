# 20260623CT 医院 CT 流程视频项目

## 执行顺序
1. 在 ComfyUI 导入并运行 `workflows/01_hospital_ct_reference_generate_workflow.json`，生成 5 张参考图。
2. 运行 `scripts/copy_ct_references_to_comfy_input.ps1`，把参考图复制到 ComfyUI/input，供关键帧工作流读取。
3. 运行 `scripts/sync_ct_outputs_to_project.ps1`，此时会把参考图归档到本项目 `outputs/references`。
4. 导入并运行 `workflows/02_hospital_ct_flux_keyframes_workflow.json`，生成 12 张关键帧：`CT001` 到 `CT012`。
5. 运行 `scripts/copy_ct_keyframes_to_comfy_input.ps1`，把关键帧复制到 ComfyUI/input，供视频工作流读取。
6. 再运行 `scripts/sync_ct_outputs_to_project.ps1`，此时会把关键帧归档到本项目 `outputs/keyframes`。
7. 推荐导入并运行 `workflows/03b_hospital_ct_wan22_stable_singleframe_video_workflow.json`，生成 12 个更稳定的无口型视频片段。
8. 最后再运行 `scripts/sync_ct_outputs_to_project.ps1`，此时会把稳版视频归档到本项目 `outputs/videos_stable`。

## 第三个工作流怎么选
- 推荐：`03b_hospital_ct_wan22_stable_singleframe_video_workflow.json`
  - 每个视频片段使用同一张关键帧作为首尾帧，只生成轻微运动。
  - 镜头之间后期硬切，人物一致性更稳，更适合医院宣传片。
- 旧版：`03_hospital_ct_wan22_flf2v_video_workflow.json`
  - 使用相邻两张关键帧做首尾帧过渡。
  - 如果两张图的人物、景别、姿态差异大，容易变脸、漂移，像幻灯片。

## ComfyUI 原始输出目录
- 参考图：`E:\ComfiUI\ComfyUI_windows_portable_nvidia_cu126\ComfyUI_windows_portable\ComfyUI\output\story_pipeline_ct_references`
- 关键帧：`E:\ComfiUI\ComfyUI_windows_portable_nvidia_cu126\ComfyUI_windows_portable\ComfyUI\output\story_pipeline_ct_keyframes`
- 视频片段：`E:\ComfiUI\ComfyUI_windows_portable_nvidia_cu126\ComfyUI_windows_portable\ComfyUI\output\story_pipeline_ct_wan22_videos`
- 稳版视频片段：`E:\ComfiUI\ComfyUI_windows_portable_nvidia_cu126\ComfyUI_windows_portable\ComfyUI\output\story_pipeline_ct_wan22_stable_videos`

## 项目归档目录
- 参考图：`E:\ComfiUI\GLH_WorkFlow\GenerateVideo20260622_withoutTalking\20260623CT\outputs\references`
- 关键帧：`E:\ComfiUI\GLH_WorkFlow\GenerateVideo20260622_withoutTalking\20260623CT\outputs\keyframes`
- 视频片段：`E:\ComfiUI\GLH_WorkFlow\GenerateVideo20260622_withoutTalking\20260623CT\outputs\videos`
- 稳版视频片段：`E:\ComfiUI\GLH_WorkFlow\GenerateVideo20260622_withoutTalking\20260623CT\outputs\videos_stable`
- 同步记录：`E:\ComfiUI\GLH_WorkFlow\GenerateVideo20260622_withoutTalking\20260623CT\outputs\manifest_outputs.json`

## 注意
- 同步脚本只复制，不移动、不删除 ComfyUI 原始输出。
- 同步脚本会为每个预期产物取最新一份，并保存为稳定文件名，方便后期剪辑和复查。
- 如果某一阶段还没有跑，同步脚本不会报错退出，只会在 `manifest_outputs.json` 里记录缺失项。
- 这是正常医院宣传/医疗流程视频，不做悬疑、惊悚、急救、血腥画面。
- 第 03 个工作流继续使用之前跑通的 Wan2.2 FLF2V clean 模板和 `wan_2.1_vae.safetensors`。
