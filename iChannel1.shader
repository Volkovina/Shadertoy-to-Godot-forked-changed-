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


//------------- BufB section

void mainImage( out vec4 fragColor, in vec2 fragCoord)
{
    fragColor = vec4(0.0,0.0,0.0,1.0);
    
    ivec2 ipx=ivec2(fragCoord);
    if((ipx==ivec2(0,0))||(ipx==ivec2(int(iResolution.x-1.),0))
    ||(ipx==ivec2(0,int(iResolution.y-1.)))||(ipx==ivec2(int(iResolution.x-1.),int(iResolution.y-1.)))){
		vec4 data=texture(iChannel1,vec2(float(ipx.x), float(ipx.y)));		
//		vec4 data=texelFetch(iChannel1,ipx,0);
        fragColor=vec4(iTime,float(iFrame),data.z+1.,0.);
    }
}

//------------- end of BufB section

void fragment(){
  mainImage(COLOR,FRAGCOORD.xy);
}




