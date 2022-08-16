# Shadertoy-to-Godot-forked-changed-
Buffers of Shadertoy changed to Viewports of Godot (original forked from https://github.com/danilw and converted into GLES2.0)

Original Source: Version Godot 3.x - GLES3.0
Godot 3.1+ very minimal Shadertoy logic with FBO : https://www.youtube.com/watch?v=v48O7Nk_n4g&t=2040s&ab_channel=DanilS
File Folder Link:
https://www.youtube.com/redirect?event=video_description&redir_token=QUFFLUhqazNlWG1fN1NKX3lUbWx3N3ZvVWJiOHR5aUxVQXxBQ3Jtc0tuQnZpUjJnQm5KRXVXYXUtWVNseFBnZVNOY2hGOFBjOWFqa2xpb3ZBYXBqeFFXTGhGNlowMHczN1Z6RXBqV0dqVkozd3BELXFXUGdTOUZHRjZVRzdEdkVieXdqb3Jfa0lGa1FkTWViWVZrY0xkS2FTTQ&q=https%3A%2F%2Fdanilw.github.io%2Fgodot-utils-and-other%2Fshadertoy_new_2021%2Fsrc%2FGodot_shadertoy_v2new.zip&v=v48O7Nk_n4g
Godot 3.1+ very minimal Shadertoy logic with FBO : https://www.youtube.com/watch?v=v48O7Nk_n4g&t=2040s&ab_channel=DanilS

Revisions Done:
1. texelFetch() functions converted into texture functions for GLES2.0 compatibility
2. switch() command converted into if/else structure for GLES2.0 compatibility
with those changes it worked identical to original
Original GLES 3.0
![image](https://user-images.githubusercontent.com/80244322/184976173-af134f25-3d81-434a-b532-121a12aa5564.png)

Converted GLES 2.0
It is switched to GLES2.0 in the editor. Then small area changes it is almost! identical.
![image](https://user-images.githubusercontent.com/80244322/184976584-4ea4271c-ffd8-4273-bf5f-dfcac3acae00.png)
The time counters, yellow at 8 locations on the middle, does not work.

I believe there are some GLES2.0 incompatibility in the editor settings of some nodes. Viewports or Sprites. 
I could not get in detail.

