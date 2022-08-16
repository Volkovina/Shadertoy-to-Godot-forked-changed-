extends Sprite


onready var global_v=get_tree().get_root().get_node("scene")

var iResolution:Vector2 = Vector2(1280, 720) # local viewport resolution

# vec4 shadertoy format https://www.shadertoy.com/view/llySRh
# in two vec2 because Godot dont have vec4
var iMouse = Vector2(0,0)
var iMouse_click = Vector2(0,0)

var last_click_state=false # shadertoy make negative iMouse.z for single frame on click

func _ready():
  pass

func _process(_delta):
  resize_viewport()
  resize_to_local()
  mouse_click()
  self.material.set("shader_param/iTime",global_v.iTime)
  self.material.set("shader_param/iFrame",global_v.iFrame)
  self.material.set("shader_param/iMouseXY",iMouse)
  self.material.set("shader_param/iMouseZW",iMouse_click)
  self.material.set("shader_param/iResolution",iResolution)


func resize_viewport():
  if(!global_v.resize_Viewport_to_screen):
    return
  if((int(global_v.iResolution.x)!=int(iResolution.x))||(int(global_v.iResolution.y)!=int(iResolution.y))):
    get_parent().size=global_v.iResolution
    var img=Image.new()
    img.create(global_v.iResolution.x,global_v.iResolution.y,false,Image.FORMAT_RGBA8)
    var texture_n = ImageTexture.new()
    texture_n.create_from_image(img,0)
    texture=texture_n
    offset=Vector2(0,0)
    

func resize_to_local():
  iResolution=get_parent().size
  iMouse=(global_v.iMouse/global_v.iResolution)*iResolution
  
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
  
  
  


