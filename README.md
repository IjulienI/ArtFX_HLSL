# HLSL Shader Collection

This repository contains a collection of shaders written entirely in **HLSL**, intended for use in **Unity** without Shader Graph.

[Preview Video](https://drive.google.com/file/d/1NlYqFvPB_Hz9UeEn_SAWOpOOStGyNhG3/view?usp=sharing)

## Shaders

### Gradient Shader  
Procedural gradient based on UVs or world-space coordinates. Can be used for background fades, color overlays, or minimalist lighting.

|  Simple Gradient | DoubleGradient |
|----------|----------|
|![Screenshot 2025-04-21 230504](https://github.com/user-attachments/assets/2b8aab17-621d-4fb2-aa6f-634a80a7d915)|![Screenshot 2025-04-21 230512](https://github.com/user-attachments/assets/17cd45d3-8ce9-49eb-810d-d52d159ae700)

### Line Shader  
Renders parametric lines.

![Screenshot 2025-04-21 230518](https://github.com/user-attachments/assets/381da45b-0656-4e9b-8a98-182205f2bc36)

### Flag Shader  
A vertex-displaced shader that simulates waving fabric using sine functions. Good for simple flag animations or banners.

![ScreenRecording2025-04-21230603-ezgif com-video-to-gif-converter](https://github.com/user-attachments/assets/16556671-e525-4344-a0a3-a24e3f5fe852)

### Outline Shader  
Generates mesh outlines. Flexible approach that doesn’t rely on post-processing.

![Screenshot 2025-04-21 230541](https://github.com/user-attachments/assets/84e158e2-82a1-4bd2-9a92-c7d87433f93c)

### Wave Shader (with displacement)  
A static vertex displacement shader that sculpts a wavy surface using noise. The mesh is displaced vertically (along Y) based on a noise function
Color is blended between two user-defined tones: one for the high points, one for the low areas.

|  Wireframe View | Textured View |
|----------|----------|
![Screenshot 2025-04-21 232411](https://github.com/user-attachments/assets/638d89cf-cc35-46e5-bef8-d3de54ba54ab)|![Screenshot 2025-04-21 230621](https://github.com/user-attachments/assets/e47397b4-0ead-4fc8-b251-f7d54da89880)

### Water Shader  
A lightweight stylized water surface with animated normals.

|  Wireframe View | Textured View |
|----------|----------|
![ezgif com-video-to-gif-converter(5)](https://github.com/user-attachments/assets/1e16b8b0-aae7-4664-b023-7531b978176e)|![ezgif com-video-to-gif-converter(3)](https://github.com/user-attachments/assets/53844cd3-015f-405c-9db2-86afd4c14c7b)

### Ground Shader (normal-based blending)  
Blends textures dynamically based on surface normal orientation — flat areas get one texture (e.g., grass), slopes another (e.g., rock).

|  Normal View | Textured View |
|----------|----------|
![Screenshot 2025-04-21 231816](https://github.com/user-attachments/assets/371aecc9-9bb9-4a49-8bb2-7c1656864c57)|![Screenshot 2025-04-21 231716](https://github.com/user-attachments/assets/56ada4f9-8c28-4186-b3ca-b299449cf81d)



### Wind VFX (Wind Waker-style)  
A stylized wind effect inspired by *Wind Waker*, built using trail meshes.
The result is a lightweight, dynamic ambient effect that works well in stylized or low-poly environments. Can be used for atmosphere, directional wind hints, or magic/energy visuals.

![ezgif com-video-to-gif-converter(7)](https://github.com/user-attachments/assets/2d0dfaf5-e080-4e3c-87ad-6e18bdea40e6)
