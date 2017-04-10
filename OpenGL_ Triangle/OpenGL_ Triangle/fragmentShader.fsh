//in vec4 vertexColor; // 从顶点着色器传来的输入变量 （名称相同，类型相同）

//out vec4 color; // 片段着色器输出的变量名(可以任意命名)，类型必须是vec4

//void main()
//{
//    color = vertexColor;
//}

precision mediump float;

void main()
{
    gl_FragColor = vec4(1.0, 1.0, 0.0, 1.0);
}
