shader_type spatial;
render_mode unshaded, cull_back;
uniform bool activ = false;

uniform vec4 color1:hint_color = vec4(1.0, 1.0,0.,1.0);

void vertex(){
	if(activ){
	float t = TIME *10.0;
	VERTEX.y += cos(VERTEX.z * t*6. ) * sin(VERTEX.z * t*6.);
	}
}

void fragment(){
	ALBEDO =  color1.rgb ;
	EMISSION =  color1.rgb;
	ALPHA = 5.0;
	
	
}