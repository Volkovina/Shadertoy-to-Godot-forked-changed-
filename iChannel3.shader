shader_type canvas_item;
render_mode blend_premul_alpha,unshaded;

uniform float iTime;
uniform int iFrame;
uniform vec2 iMouseXY;
uniform vec2 iMouseZW;

// DO NOT use TEXTURE_PIXEL_SIZE
// because of bug https://github.com/godotengine/godot/issues/45428
// ALWAYS send resolution in your own uniform
uniform vec2 iResolution =vec2(1280.,720.);

uniform sampler2D iChannel0;
uniform sampler2D iChannel1;
uniform sampler2D iChannel2;
uniform sampler2D iChannel3;


// base on https://www.shadertoy.com/view/WlcBWr

//------------- Common section

float DigitBin(in int x)
{
    if (x==0)return 480599.0;
	else if(x==1) return 139810.0;
	else if(x==2) return 476951.0;
	else if(x==3) return 476999.0;
	else if(x==4) return 350020.0;
	else if(x==5) return 464711.0;
	else if(x==6) return 464727.0;
	else if(x==7) return 476228.0;
	else if(x==8) return 481111.0;
	else if(x==9) return 481095.0;
	return 0.0;
}

float PrintValue(vec2 fragCoord, vec2 pixelCoord, vec2 fontSize, float value,
		float digits, float decimals) {
	vec2 charCoord = (fragCoord - pixelCoord) / fontSize;
	if(charCoord.y < 0.0 || charCoord.y >= 1.0) return 0.0;
	float bits = 0.0;
	float digitIndex1 = digits - floor(charCoord.x)+ 1.0;
	if(- digitIndex1 <= decimals) {
		float pow1 = pow(10.0, digitIndex1);
		float absValue = abs(value);
		float pivot = max(absValue, 1.5) * 10.0;
		if(pivot < pow1) {
			if(value < 0.0 && pivot >= pow1 * 0.1) bits = 1792.0;
		} else if(digitIndex1 == 0.0) {
			if(decimals > 0.0) bits = 2.0;
		} else {
			value = digitIndex1 < 0.0 ? fract(absValue) : absValue * 10.0;
			bits = DigitBin(int (mod(value / pow1, 10.0)));
		}
	}
	return floor(mod(bits / pow(2.0, floor(fract(charCoord.x) * 4.0) + floor(charCoord.y * 5.0) * 4.0), 2.0));
}

vec3 print_n(in vec2 uv ,float nm){
    	vec2 vPixelCoord2 = vec2(0.);
		float fValue2 = nm;
		float fDigits = 1.0;
		float fDecimalPlaces = 6.0;
        vec2 fontSize = vec2(50.)/vec2(1280,720);
		float fIsDigit2 = PrintValue(uv, vPixelCoord2, fontSize, fValue2, fDigits, fDecimalPlaces);
        return vec3(1.0, 1.0, 1.0)* fIsDigit2;
}

//------------- end of Common


//------------- BufD section

// https://www.shadertoy.com/view/WdBGzc

// Created by Danil (2019+) https://github.com/danilw
// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.


vec3 gc(float x, float s) {return vec3( .6 + .6 * cos( 6.3 *  x/s  + vec3(0,23,21)));}
vec3 gc2(float x, float s) {return vec3( .6 + .6 * cos( 6.3 *  s-1.-x/s  + vec3(0,23,21)));}

void mainImage( out vec4 O, in vec2 u){
    O = vec4(vec3(0x1a,0x13,0x21)/float(0xff),1.);
    vec2 R = iResolution.xy,
    U = (u -.5*R) / R.y;
    if(max(abs(U.x),U.y) > .5){O=vec4(0.); return;}
    float s=1./8., //8. it number of tiles, set to any
    t = iTime,
    z = 1./ R.y;
    vec2 p=(fract(U/s)-.5),
    v=floor(U/s)+.5/s;
    s=1./s;
    bvec2 gv=bvec2(v.x==0.,v.y==s-1.);
    float r=(v.x+1.)/2.-.5,r1=(s-1.-v.y+1.)/2.-.5;
    if(gv.x)r=r1;if(gv.y)r1=r;
    vec3 ccx=gc(v.x,s);
    vec3 ccy=gc2(v.y,s);
    float dc=0.;
    for(float i=0.;i<2.;i++)
    dc=max(dc,smoothstep(z*s,-z*s,length(p+.45*vec2(sin((t+1./120.*i)*r-1.57),cos((t+1./120.*i)*r1-1.57))) - .015));
    O.rgb = mix(O.rgb,ccy+ccx-ccy*ccx,dc);
    vec4 yc=texture(iChannel3,u/R)*(1.-0.25*smoothstep(24.3,25.132,mod(t,25.132)));
    O=(gv.x||gv.y)?max(O,yc/(1.+.025*max(r,r1)/s)):max(O,yc/(1.+0.02*max(mod(t,25.132)/13.-1.,0.)));
}

//------------- end of BufD section

void fragment(){
  mainImage(COLOR,FRAGCOORD.xy);
}




