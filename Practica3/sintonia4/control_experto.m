% Cerramos y borramos todo
  clear all;
  close all;
  clc;
  
% Planta a controlar
  num=1.5; 
  den=[50 43 3 1];
  
% Presintonia con Ziegler-Nichols
  [K,T]=ZN(num,den);
  Kp=6*K;
  Ti=T/2;
  Td=T/8;
  Ki=Kp/Ti;
  Kd=Kp*Td;
  disp(' ');
  disp(' Sintonia Ziegler-Nichols');
  fprintf('  K= %3.4f\n',K);
  fprintf('  T= %3.4f\n',T);
  disp(' ');
  disp(' Pulse enter para ejecutar el control Ziegler-Nichols');
  pause;
  disp(' ');
  disp(' PID Ziegler-Nichols');
  fprintf('  Kp= %3.4f\n',Kp);
  fprintf('  Ki= %3.4f\n',Ki);
  fprintf('  Kd= %3.4f\n',Kd); 
  
% Simulamos el modelo
  pid=[Kp Ki Kd];
  [tout,yout]=simular(pid,num,den);
  
% Calculo de las caracteristicas del sistema
  [tr,tp,Mp,ts,ys]=caracteristicas(tout,yout);
  disp(' ');
  disp(' Caracteristicas del sistema');
  fprintf('  tr= %3.4f\n',tr);
  fprintf('  tp= %3.4f\n',tp);
  fprintf('  Mp= %3.4f\n',Mp);
  fprintf('  ts= %3.4f\n',ts);
  fprintf('  ys= %3.4f\n',ys);

% Respuesta del sistema con el PID sintonizado con ZN
  plot(tout,ones(size(tout)),'b',tout,yout,'r');
  hold on;
  title('Respuesta del sistema con el PID sintonizado con ZN');
  xlabel('Tiempo (s)');
  ylabel('Salida');
  hold on;
  ind_tr=tout==tr;
  ind_tp=tout==tp;
  ind_ts=tout==ts;
  stem([tr tp ts tout(end-1)],[yout(ind_tr) yout(ind_tp) yout(ind_ts) yout(end-1)],'r','filled');

% Especificaciones del sistema
  disp(' ');
  disp(' Introduzca las especificaciones del sistema');
  tr=input('  Tiempo de subida      : ');
  tp=input('  Tiempo de pico        : ');
  Mp=input('  Sobreelongacion       : ');
  ts=input('  Tiempo de asentamiento: ');
  ys=input('  Estado estacionario   : ');
  espec=[tr tp Mp ts ys];

% Llamamos a la funcion sistema_experto
  pid=[Kp Ki Kd];
  pid=sistema_experto(pid,num,den,espec);
  
% Parametros del controlador sintonizado
  disp(' ');
  disp(' PID experto');
  fprintf('  Kp= %3.4f\n',pid(1));
  fprintf('  Ki= %3.4f\n',pid(2));
  fprintf('  Kd= %3.4f\n',pid(3)); 
  
% Comparamos los PID's ZN y experto
  [tout2,yout2]=simular(pid,num,den);
  plot(tout,ones(size(tout)),'b',tout,yout,'r',tout2,yout2,'g');
  title('Control PID: ZN(rojo) y experto(verde)');
  xlabel('Tiempo (s)');
  ylabel('Salida');
  [tr,tp,Mp,ts,ys]=caracteristicas(tout2,yout2);
  ind_tr=find(tout2==tr);
  ind_tp=find(tout2==tp);
  ind_ts=find(tout2==ts);
  stem([tr tp ts tout2(end)],[yout2(ind_tr) yout2(ind_tp) yout2(ind_ts) yout2(end)],'g','filled');
  disp(' ');
  disp(' Caracteristicas del sistema');
  fprintf('  tr= %3.4f\n',tr);
  fprintf('  tp= %3.4f\n',tp);
  fprintf('  Mp= %3.4f\n',Mp);
  fprintf('  ts= %3.4f\n',ts);
  fprintf('  ys= %3.4f\n',ys);