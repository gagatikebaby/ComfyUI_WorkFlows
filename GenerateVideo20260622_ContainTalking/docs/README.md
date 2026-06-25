# GenerateVideo20260622_ContainTalking

这个目录用于第二阶段：对已经生成的视频做后处理，加语音、补口型或制作说话插入镜头。

## 输入来源

- `source_videos/`：从 withoutTalking 复制过来的无语音视频片段。
- `keyframes/`：可用于重新生成说话镜头的关键帧。
- `references/`：角色、物品、场景参考图。
- `dialogue/`：台词文本或后续音频占位。

## 对口型工作流

- `workflows/story_pipeline_04_wan_infinite_talk_lipsync_workflow.json`

当前这个工作流更适合“图片 + 音频生成说话镜头”，不是直接把原 MP4 的嘴部改掉。如果要严格对已有 MP4 补口型，需要再单独做 video-to-video lipsync 工作流。

## 输出位置

- 建议把后处理成品放到 `talking_outputs/`。

## 注意

运行前确保 ComfyUI 里存在：

- `models/audio_encoders/chinese-wav2vec2-base.safetensors`
- `models/model_patches/infinitetalk_single.safetensors`
- `input/story_pipeline_dialogue/lc_line_01.wav`
