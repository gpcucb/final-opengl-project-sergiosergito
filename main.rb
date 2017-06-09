require 'opengl'
require 'glu'
require 'glut'
require 'chunky_png'
require 'wavefront'

require_relative 'model'

include Gl
include Glu
include Glut

FPS = 60.freeze
DELAY_TIME = (1000.0 / FPS)
DELAY_TIME.freeze

def load_objects
  puts "Loading model"
   @model = Model.new('obj2/lego1.obj', 'obj2/lego1.mtl')
   @model2 = Model.new('LEGO_CAR_A2/LEGO_CAR_A2.obj', 'LEGO_CAR_A2/LEGO_CAR_A2.mtl')
   @model3 = Model.new('LEGO.Creator_Plane2/LEGO.Creator_Plane2.obj', 'LEGO.Creator_Plane2/LEGO.Creator_Plane2.mtl')
  # @model4 = Model.new('e6thcu9jpf5s-Map/Minecraft_Denizfeneri.obj','e6thcu9jpf5s-Map/Minecraft_Denizfeneri.mtl')
  puts "model loaded"
end

def initGL
  glEnable(GL_DEPTH_TEST)
  #glClearColor(0.0, 0.0, 0.0, 0.0)
  glClearColor(100.0, 100.0, 0.0, 0.0)
  glEnable(GL_COLOR_MATERIAL)
  glColorMaterial(GL_FRONT_AND_BACK, GL_AMBIENT_AND_DIFFUSE)
  glEnable(GL_NORMALIZE)
  glShadeModel(GL_SMOOTH)
  glEnable(GL_CULL_FACE)
  glCullFace(GL_BACK)

  position = [0.0, 50.0, 0.0]
  #position = [0.0, 400.0, 0.0]
  #color = [1.0, 1.0, 1.0, 1.0]
  color = [100.0, 100.0, 1.0, 1.0]
  ambient = [0.2, 0.2, 0.2, 1.0]
  glLightfv(GL_LIGHT0, GL_POSITION, position)
  glLightfv(GL_LIGHT0, GL_DIFFUSE, color)
  glLightfv(GL_LIGHT0, GL_SPECULAR, color)
  glLightModelfv(GL_LIGHT_MODEL_AMBIENT, ambient)
end

def draw
  @frame_start = glutGet(GLUT_ELAPSED_TIME)
  check_fps
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
    #ControlCamara    #Por ahora solo va para abajo
    dibujarLego
    dibujarAuto
    dibujarAvion
 #   dibujarMontana
  glutSwapBuffers
end

def reshape(width, height)
  glViewport(0, 0, width, height)
  glMatrixMode(GL_PROJECTION)
  glLoadIdentity
  gluPerspective(45, (1.0 * width) / height, 0.001, 1000.0)
  glMatrixMode(GL_MODELVIEW)
  glLoadIdentity()
  controlCamara     #con @indiceCamara iniciado en 0
end

def idle     #las funciones del programa
  frameTime
  glutPostRedisplay
  mecanismosAvion
  mecanismosLego
  mecanismosCamara
  draw
  @indiceEventos=@indiceEventos+1
  
  puts "indice Eventos: #{@indiceEventos}"
  puts "indice Eventos Lego: #{@indEventosLego}"
end

def frameTime
 @frame_time = glutGet(GLUT_ELAPSED_TIME) - @frame_start
  if (@frame_time< DELAY_TIME)
    sleep((DELAY_TIME - @frame_time) / 1000.0)
  end
end

def check_fps
  current_time = glutGet(GLUT_ELAPSED_TIME)
  delta_time = current_time - @previous_time

  @frame_count += 1

  if (delta_time > 1000)
    fps = @frame_count / (delta_time / 1000.0) #si aumentas 0 es mas rapido, si quitas 0 aumenta velocidad de a poco
    puts "FPS: #{fps}"
    @frame_count = 0
    @previous_time = current_time
  end
end

def controlCamara
#gluLookAt(camx,camy,camz,objx,objy,objz,vx,vy,vz);   <400 +cerca   =600 centrado.  800 +lejos
 case @indAcercamiento
  when 0 .. 299
        gluLookAt(0.0, 50.0, -800.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0)
  when 300 .. 699
        gluLookAt(0.0, 50.0, -700.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0)
  when 700 .. 1299
        gluLookAt(0.0, 50.0, -600.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0)
  when 1300 .. 1600
        gluLookAt(0.0, 50.0, -500.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0)
  else
        gluLookAt(0.0, 50.0, -400.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0)
  end
  mecanismosCamara
end

def mecanismosCamara
   if @indAcercamiento <= 1600 
      @indAcercamiento = @indAcercamiento + 1
   else
      @indAcercamiento = @indAcercamiento = 0
   end
end

def dibujarMontana
 glPushMatrix				#Para dibujar La montanha
    glTranslate(0.0, -30.0, 30.0)
   # glRotatef(@spin, 0.0, 1.0, 0.0)
   # glScalef(10.0, 10.0, 10.0)
     glScalef(0.5, 0.5, 0.5)        #tamanho del Lego
   # @model4.draw
  glPopMatrix
end

def dibujarAvion
  glPushMatrix				#Para dibujar el Avion
  #  validadorAvion
   # glTranslate(0.0, -30.0, 30.0)
   # glTranslate(0.0, -30.0, -30.0)     #para que se mueva de izquierda, derecha, arriba, abajo
  case @indEventosAvion
  when 0 .. 3
        glTranslate(0.0, 30.0, 0.0)
        @indEventosAvion=@indEventosAvion+1
  when 3 .. 6
        glTranslate(0.0, 40.0, 0.0)
        @indEventosAvion=@indEventosAvion+1
  when 7 .. 12
        glTranslate(0.0, 50.0, 0.0)
        @indEventosAvion=@indEventosAvion+1
  when 13 .. 20
        glTranslate(0.0, 60.0, 0.0)
        @indEventosAvion=@indEventosAvion+1
  when 21 .. 25
        glTranslate(0.0, 50.0, 0.0)
        @indEventosAvion=@indEventosAvion+1
  when 26 .. 30
        glTranslate(0.0, 40.0, 0.0)
        @indEventosAvion=@indEventosAvion+1
  else
        glTranslate(0.0, 30.0, 0.0)
        @indEventosAvion=0
       # puts "AVION glTranslate(0.0, -30.0, 120.0)"
  end
    glRotatef(@spinAvion, 0.0, 1.0, 0.0)     #Para mover el Avion, en los ejes x, y, z
     
    # glRotatef(0.0, 0.0, 1.0, 0.0)    #Aqui hace que avanze 10 en 10 en ejeX
   # glScalef(10.0, 10.0, 10.0)
    glScalef(0.5, 0.5, 0.5)
    @model3.draw
  glPopMatrix
end

def validadorAvion
  case @indEventosAvion
  when 0 .. 3
        glTranslate(0.0, -30.0, 30.0)
        @indEventosAvion=@indEventosAvion+1
  when 3 .. 6
        glTranslate(0.0, -30.0, 60.0)
        @indEventosAvion=@indEventosAvion+1
  when 7 .. 12
        glTranslate(0.0, -30.0, 90.0)
        @indEventosAvion=@indEventosAvion+1
  when 13 .. 18
        glTranslate(0.0, -30.0, 120.0)
        @indEventosAvion=@indEventosAvion+1
  else
        glTranslate(0.0, -30.0, 400.0)
        @indEventosAvion=0
        #puts "AVION glTranslate(0.0, -30.0, 120.0)"
  end

end

def mecanismosAvion
   @spinAvion = @spinAvion - 3
 # if @posYAvion > 0        #corrige el avion 
 #    @posYAvion = -30.0
 # end
   if @spinAvion < -360.0
      @spinAvion = 0 
   end
end

def dibujarAuto
  glPushMatrix				#Para dibujar el Auto
   # glTranslate(0.0, -30.0, 30.0)
     glTranslate(0.0, -30.0, -30.0)     #para que se mueva de izquierda, derecha, arriba, abajo
   # glRotatef(@spin, 0.0, 1.0, 0.0)     #Para mover el auto, en los ejes x, y, z
   # glScalef(10.0, 10.0, 10.0)
    glScalef(0.5, 0.5, 0.5)
    @model2.draw
  glPopMatrix
end

def dibujarLego
 glPushMatrix				#Para dibujar el lego
   # glTranslate(0.0, -30.0, 30.0)
   # glRotatef(@spin, 0.0, 1.0, 0.0)
   # glScalef(10.0, 10.0, 10.0)
  
   case @indEventosLego
  when 0 .. 5
        glTranslate(-200.0, -30.0, 40.0)
        glRotatef(@indSpinL, 0.0, 1.0, 0.0)
        @indEventosLego=@indEventosLego+1  
  when 6 .. 10
        glTranslate(-190.0, -30.0, 40.0)
        glRotatef(@indSpinL, 0.0, 1.0, 0.0)
        @indEventosLego=@indEventosLego+1
  when 11 .. 15
        glTranslate(-180.0, -30.0, 40.0)
        glRotatef(@indSpinL, 0.0, 1.0, 0.0)
        @indEventosLego=@indEventosLego+1
  when 16 .. 20
        glTranslate(-170.0, -30.0, 40.0)
        glRotatef(@indSpinL, 0.0, 1.0, 0.0)
        @indEventosLego=@indEventosLego+1
  when 21 .. 25
        glTranslate(-160.0, -30.0, 40.0)
        glRotatef(@indSpinL, 0.0, 1.0, 0.0)
        @indEventosLego=@indEventosLego+1
  when 26 .. 30
        glTranslate(-150.0, -30.0, 40.0)
        glRotatef(@indSpinL, 0.0, 1.0, 0.0)
        @indEventosLego=@indEventosLego+1
  when 31 .. 35
        glTranslate(-140.0, -30.0, 40.0)
        glRotatef(@indSpinL, 0.0, 1.0, 0.0)
        @indEventosLego=@indEventosLego+1
  when 36 .. 40
        glTranslate(-130.0, -30.0, 40.0)
        glRotatef(@indSpinL, 0.0, 1.0, 0.0)
        @indEventosLego=@indEventosLego+1  
  when 41 .. 45
        glTranslate(-120.0, -30.0, 40.0)
        glRotatef(@indSpinL, 0.0, 1.0, 0.0)
        @indEventosLego=@indEventosLego+1
  when 46 .. 50
        glTranslate(-110.0, -30.0, 40.0)
        glRotatef(@indSpinL, 0.0, 1.0, 0.0)
        @indEventosLego=@indEventosLego+1
  when 51 .. 55
        glTranslate(-100.0, -30.0, 40.0)
        glRotatef(@indSpinL, 0.0, 1.0, 0.0)
        @indEventosLego=@indEventosLego+1
  when 56 .. 60
        glTranslate(-90.0, -15.0, 40.0)
        glRotatef(@indSpinL, 0.0, 1.0, 0.0)
        @indEventosLego=@indEventosLego+1
  when 61 .. 65
        glTranslate(-80.0, -5.0, 40.0)
        glRotatef(@indSpinL, 0.0, 1.0, 0.0)
        @indEventosLego=@indEventosLego+1
  when 66 .. 70
        glTranslate(-60.0, -10.0, 40.0)
        glRotatef(@indSpinL, 0.0, 1.0, 0.0)
        @indEventosLego=@indEventosLego+1
  else
        glTranslate(0.0, -10.0, 160.0)
        @indEventosLego=0
        #puts "AVION glTranslate(0.0, -30.0, 120.0)"
  end
    glScalef(15.0, 15.0, 15.0)       #tamanho del Lego
    @model.draw
  glPopMatrix
end
def mecanismosLego  
 

end
#Variables globales
@spinAvion= -30.0 # 
@spin = 0.0   #variables globales
@previous_time = 0
@frame_count = 0
@indAcercamiento=0  #Para el ajuste de Camara en ControlCamara
@indSpin=0    #Indice del spinn
@indEventosAvion=0
@indEventosLego=0 #es el trigger para que el lego salte
@indiceEventos=0
@indSpinL=1

load_objects
glutInit
glutInitDisplayMode(GLUT_RGB | GLUT_DOUBLE | GLUT_DEPTH)
glutInitWindowSize(800,600)
glutInitWindowPosition(10,10)
glutCreateWindow("Hola OpenGL, en Ruby")
glutDisplayFunc :draw
glutReshapeFunc :reshape
glutIdleFunc :idle
initGL
glutMainLoop
