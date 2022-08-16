extends Sprite

onready var global_v=get_tree().get_root().get_node("scene")

#bind textures as samler2D to shader
#do it here to prevent "errors" from Godot(and crash in HTML5 build)
#this logic should work same like Shadetroy
func _ready():
  bing_viewports()


func bing_viewports():
  for i in range(4):
    var snode=global_v.get_node("iChannel_buf"+str(i)).get_node("Sprite")
    var iChannel=global_v.get_node("iChannel"+str(i)).get_viewport().get_texture()
    iChannel.flags=Texture.FLAG_FILTER
    snode.texture=iChannel
    snode.offset=Vector2(0,0)
  for i in range(4):
    var cnode=global_v.get_node("iChannel"+str(i)+"/Sprite")
    for j in range(4):
      if(i>j):
        var iChannel=global_v.get_node("iChannel"+str(j)).get_viewport().get_texture()
        iChannel.flags=Texture.FLAG_FILTER
        cnode.material.set("shader_param/iChannel"+str(j),iChannel)
      if(i<=j):
        var iChannel=global_v.get_node("iChannel_buf"+str(j)).get_viewport().get_texture()
        iChannel.flags=Texture.FLAG_FILTER
        cnode.material.set("shader_param/iChannel"+str(j),iChannel)

#uniforms

# vec4 shadertoy format https://www.shadertoy.com/view/llySRh
# in two vec2 because Godot dont have vec4
var iMouse = Vector2(0,0)
var iMouse_click = Vector2(0,0)

var last_click_state=false # shadertoy make negative iMouse.z for single frame on click

#var KEY_LEFT=false
#var KEY_UP=false
#var KEY_RIGHT=false
#var KEY_DOWN=false

func _process(_delta):
  resize_viewport_buf_copy()
  resize_sprite()
  mouse_click()
  iMouse=global_v.iMouse
  self.material.set("shader_param/iTime",global_v.iTime)
  self.material.set("shader_param/iFrame",global_v.iFrame)
  self.material.set("shader_param/iMouseXY",iMouse)
  self.material.set("shader_param/iMouseZW",iMouse_click)
  self.material.set("shader_param/iResolution",global_v.iResolution)

func _input(event):
  if event is InputEventKey:
    var key=event.get_scancode()
    match(key):
      KEY_LEFT:
        self.material.set("shader_param/KEY_LEFT",event.pressed)
      KEY_UP:
        self.material.set("shader_param/KEY_UP",event.pressed)
      KEY_RIGHT:
        self.material.set("shader_param/KEY_RIGHT",event.pressed)
      KEY_DOWN:
        self.material.set("shader_param/KEY_DOWN",event.pressed)
    

var iResolution:Vector2 = Vector2(1280, 720) # local viewport resolution
func resize_sprite():
  if((int(global_v.iResolution.x)!=int(iResolution.x))||(int(global_v.iResolution.y)!=int(iResolution.y))):
    var img=Image.new()
    img.create(global_v.iResolution.x,global_v.iResolution.y,false,Image.FORMAT_RGBA8)
    var texture_n = ImageTexture.new()
    texture_n.create_from_image(img,0)
    texture=texture_n
    offset=Vector2(0,0)
  iResolution=global_v.iResolution

func resize_viewport_buf_copy():
  if(!global_v.resize_Viewport_to_screen):
    return
  var size_changed=((int(global_v.iResolution.x)!=int(iResolution.x))||(int(global_v.iResolution.y)!=int(iResolution.y)))
  for i in range(4):
    if(size_changed):
      var cnode=global_v.get_node("iChannel_buf"+str(i)+"/Sprite")
      var vnode=global_v.get_node("iChannel_buf"+str(i))
      vnode.size=global_v.iResolution
  if(size_changed):
    bing_viewports()

func mouse_click():
  if(!last_click_state):
    if(global_v.iMouse_b[0]):
      last_click_state=true
      iMouse_click=iMouse
  else:
    if(global_v.iMouse_b[0]):
      iMouse_click.y=-abs(iMouse_click.y)
    else:
      iMouse_click.x=-abs(iMouse_click.x)
      iMouse_click.y=-abs(iMouse_click.y)
      last_click_state=false





