//layout (location = 0) in vec3 position; // 变量的属性位置值为0

//out vec4 vertexColor; // 为片段着色器指定一个颜色值输出

//void main()
//{
//    gl_Position = vec4(position, 1.0f); // 注意我们如何把一个vec3作为vec4的构造参数
//    vertexColor = vec4(0.5f, 0.0f, 0.0f, 1.0f); // 输出变量为暗红色
//}
attribute vec4 Position;
attribute vec4 SourceColor;

varying vec4 DestinationColor;

void main(void)
{
    DestinationColor = SourceColor;
    gl_Position = Position;
}
