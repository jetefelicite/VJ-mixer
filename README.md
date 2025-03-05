# Custom Music-Reactive Video Mixer (TouchDesigner)

##  Overview
This is a **customized video mixer built in TouchDesigner**, designed for **real-time VJing** with **music-reactive visuals**. I modified an existing open-source project from Richard-Burns to integrate my own **assets, effects, and workflows**, allowing for **structured, audio-reactive visuals** and enhanced performance in a live setting.

##  Features  
 **Music Reactivity** – Assets respond dynamically to audio input  
 **Custom Parameter System** – Organized controls for real-time VJing  
 **NDI Output** – Enables live streaming and external routing  
 **Live Camera Integration** – Mix real-world footage with generative visuals  

## Technologies Used  
- **TouchDesigner** (Base framework)  
- **Python** (Custom scripting for interactivity & automation)  
- **GLSL** (Shader modifications for visual effects)  

## Download & Access  
 **Full Project**: [Google Drive Link](https://drive.google.com/file/d/1IZFNW9_LoYhfV4_w-USia7tNcZZi2fd7/view?usp=sharing))  

##  Key Modifications  
| Feature        | Original Version | My Modifications |
|---------------|-----------------|------------------|
| **NDI Output** | Not included | Added NDI output for live streaming |
| **Live Camera Support** | No support | Integrated real-time camera input |
| **Audio Reactivity** | Basic | Developed a structured parameter system |
| **Custom Assets** | Default visuals | Created & optimized my own assets |
| **GLSL Shader Effects** | Default settings | Adjusted effects for unique motion & blending |

##  Code & Patch Breakdown  
Since TouchDesigner doesn’t store all code in a single file, here’s how to navigate my modifications:

1. **Python Scripts**  
   - Found in the **`/scripts`** folder  
   - Handles **audio-reactive logic & automation**  
   - Example: Adjusting parameters dynamically based on volume levels  

2. **GLSL Shaders**  
   - Located in the **`/shaders`** folder  
   - Used for **visual effects, color blending, and motion transformations**  

3. **TouchDesigner Node Setup**  
   - Screenshots & explanations available in the **documentation folder**  
   - Shows how I organized nodes for **structured, real-time performance**  

##  Visual Documentation  
*(Attach screenshots of the node setup, UI, and final output here.)*  

##  Future Improvements  
- Add **MIDI mapping** for external control  
- Further optimize shaders for **better performance**  

---

