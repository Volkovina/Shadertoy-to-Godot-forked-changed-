extends Node2D

# set true to resize Viewports(iChannels) in real time
# if false used static resoltion
const resize_Viewport_to_screen = false

var is_paused:bool = false # Space to pause/unpause

var iTime:float=0 # multiplied by time_speed
var iTime_real:float=0 # without time_speed
var iFrame:int=-1

var time_speed:float = 1.0 # delta*time_speed

var iResolution:Vector2 = Vector2(1280, 720) # global viewport resolution

 
# Mouse [0,0] is left bottom corner
var iMouse:Vector2=Vector2(0, 0) # mouse xy

# mouse pressed xy (same as in Shadertoy)
# [vec2(left),vec2(right)]
var iMouse_press = [Vector2(0, 0),Vector2(0, 0)]

var iMouse_d = Vector2(0, 0) # mouse press left,right 0 to 1 linear value multiplied by time_speed (1 sec time)
var iMouse_b = [false, false] # mouse pressed buttons [left, right]
var iMouse_press_time=Vector2(-10, -10) # last mouse click time iTime

func _ready():
  pass


var event_once=true
func _input(event):
  if event is InputEventKey:
    var key=event.get_scancode()
    match(key):
      KEY_SPACE:
        if(event.pressed):
          if(event_once):
            is_paused=!is_paused
          event_once=false
        else:
          event_once=true

func _process(delta):
  iResolution=get_viewport().size
  iResolution.x=max(iResolution.x,1)
  iResolution.y=max(iResolution.y,1)
  iTime_real+=delta
  
  if(!is_paused):
    iTime+=delta*time_speed
    iFrame+=1
  _process_mouse(delta)
  

func _process_mouse(delta):
  var m_pos=get_viewport().get_mouse_position()/iResolution
  iMouse=Vector2(m_pos.x*iResolution.x,iResolution.y*(1.0-m_pos.y))
  iMouse_b=[Input.is_mouse_button_pressed(BUTTON_LEFT),Input.is_mouse_button_pressed(BUTTON_RIGHT)]
  if(iMouse_b[0]):
    iMouse_press[0]=iMouse
    iMouse_press_time.x=iTime
  if(iMouse_b[1]):
    iMouse_press[1]=iMouse
    iMouse_press_time.y=iTime
  
  if(iMouse_b[0]):
    iMouse_d.x=min(iMouse_d.x+delta*time_speed,1.0)
  else:
    iMouse_d.x=max(iMouse_d.x-delta*time_speed,0.0)
    
  if(iMouse_b[1]):
    iMouse_d.y=min(iMouse_d.y+delta*time_speed,1.0)
  else:
    iMouse_d.y=max(iMouse_d.y-delta*time_speed,0.0)
