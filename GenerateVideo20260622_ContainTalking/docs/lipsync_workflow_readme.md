# 人物说话对口型流程

## 当前状态

- 已生成工作流：`workflows/story_pipeline_04_wan_infinite_talk_lipsync_workflow.json`。
- 默认起始图：`ST-03_keyframe_00001_.png`，人物近景、嘴部可见，适合测试说话。
- 默认音频路径：`ComfyUI/input/story_pipeline_dialogue/lc_line_01.wav`。
- 已改用 ComfyUI 原生 `LoadAudio` 节点，避免 VHS `Load Audio (Path)` 在前端恢复失败。
- 当前本机缺少 InfiniteTalk 必需的 `audio_encoder` 和 `model_patch` 模型；放入模型并重启 ComfyUI 后才能正式运行。

## 运行顺序

1. 把台词音频保存为 WAV：`lc_line_01.wav`。
2. 在 ComfyUI 根目录创建 `input/story_pipeline_dialogue/`，把音频放进去。工作流里的 `LoadAudio` 节点读取相对路径 `story_pipeline_dialogue/lc_line_01.wav`。
3. 把 InfiniteTalk 的音频编码器模型放入 `ComfyUI/models/audio_encoders/`。
4. 把 InfiniteTalk 的模型补丁放入 `ComfyUI/models/model_patches/`。
5. 重启 ComfyUI。
6. 导入 `story_pipeline_04_wan_infinite_talk_lipsync_workflow.json`。
7. 在 `AudioEncoderLoader` 和 `ModelPatchLoader` 节点里选择刚放入的模型。
8. 运行工作流，输出目录为 `ComfyUI/output/story_pipeline_lipsync/`。

## 参数建议

- 分辨率先用 `640x640` 测试，稳定后再提高。
- 帧数 `81`，16 fps，大约 5 秒。
- `audio_scale` 默认 `1.0`；嘴型过弱可调到 `1.2`，脸漂移明显可降到 `0.8`。
- 起始图要优先选择正脸或 3/4 侧脸、嘴部无遮挡的画面。

## 注意

- 这是本地 WanInfiniteTalk 路线，不调用 Gemini，也不调用在线 Kling/Runway。
- 如果模型下拉为空，不是工作流坏了，而是对应模型目录还没有放模型或 ComfyUI 没重启。
- 如果只想快速测试，可以先用 3 到 5 秒短音频；长句建议拆成多个短片段。