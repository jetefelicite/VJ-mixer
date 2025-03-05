# VJ-mixer
# Custom Music-Reactive Video Mixer (TouchDesigner)

##  Overview
This is a customized **TouchDesigner-based video mixer** from @Richard-Burns that I modified to create a **music-reactive VJing system**. It allows for **NDI output, live camera integration, and parameterized assets** that dynamically respond to music.  

##  Features  
 **Music Reactivity** – Visuals change based on live audio input  
 **Custom Parameters** – Fine-tune animations, colors, and effects  
 **NDI Output** – Seamless integration into live VJing setups  
 **Live Camera Support** – Mix real-time footage with generative visuals  

## Technologies Used  
- **TouchDesigner** (Base framework)  
- **Python** (Custom scripting for automation & interactivity)  
- **GLSL** (Customized shaders for visuals)  

## How It Works  
1. **Load the project in TouchDesigner**  
2. **Connect an audio source** (e.g., microphone, DJ setup)  
3. **Control parameters in real time** (e.g., brightness, movement, colors)  
4. **Output visuals via NDI or screen projection**  

##  Download  
 **Google Drive Link**: [Download the project here](https://drive.google.com/file/d/1IZFNW9_LoYhfV4_w-USia7tNcZZi2fd7/view?usp=sharing)  

## Key Modifications  
Here’s what I changed from the original project:  

| Feature        | Original Version | My Modifications |
|---------------|-----------------|------------------|
| **NDI Output** | Not included | Added NDI output for live streaming |
| **Live Camera** | No support | Integrated camera input |
| **Audio Reactivity** | Basic | Created a structured parameter system |
| **Custom GLSL Shaders** | Default effects | Modified for unique visual effects |

## 🔍 Code Highlights  
### **Python Script Example: Audio-Reactive Parameter Control**  
```python
# Adjusting a TouchDesigner parameter based on audio input
def onAudioLevelChange(level):
    op('video_effect').par.brightness = level * 2
