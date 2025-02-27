Sử dụng để play audio, và quản lý nó trong ứng dụng.

**appPlaySoundViewmodelProvider**
- Tại một thời điểm, nếu sử dụng viewmodel này chỉ một audio được play, và cập nhất với view được gắn ID tương ứng.

## Cách sử dụng
### Gọi play audio bất cứ đâu qua riverpod

```
final audio = vocabulary.audio;
    if (audio!=null) {
      final uri = await PathUtils.getUriOnlineOrCached(audio);
      ref.read(appPlaySoundViewmodelProvider.notifier).playAudio(uri: uri, pathId: audio.hashCode);
    }

```

### Bước 2:
Tạo UI cập nhật trạng thái play audio.

```
 VAudioIconWithModel(audioId: vocabulary.audio?.hashCode, size: 18,),

```