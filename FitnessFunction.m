function [ cost,sol ] = FitnessFunction( chromosome,model )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

    x= zeros(1,model.dim);
    y= zeros(1,model.dim);
    z = zeros(1,model.dim);
    %取第uav个航路的坐标
    for i=1:model.dim
    x(i) = chromosome.pos(i,1);
    y(i) = chromosome.pos(i,2);
    z(i) = chromosome.pos(i,3);
    end
    sx = model.startp(1);
    sy = model.startp(2);
    sz = model.startp(3);
    ex = model.endp(1);
    ey =model.endp(2);
    ez=model.endp(3);
        
    
    xobs = model.xobs;
    yobs = model.yobs;
    zobs = model.zobs;
    robs = model.robs;
    
    XS=[sx x ex];
    YS=[sy y ey];
    ZS=[sz z ez];
    k =numel(XS);
    TP =linspace(0,1,k);
    tt =linspace(0,1,50);
    xx =[];
    yy =[];
    zz=[];
    for i=1:k-1
    %每一段向量分成10个点
    x_r = linspace(XS(i),XS(i+1),10);
    y_r= linspace(YS(i),YS(i+1),10);
    z_r =linspace(ZS(i),ZS(i+1),10);
    xx = [xx,x_r];
    yy = [yy,y_r];
    zz =[zz ,z_r];
    end
    
    %calc L
    dx =diff(xx);
    dy =diff(yy);
    dz = diff(zz);
    Length = sum(sqrt(dx.^2+dy.^2+dz.^2));
    nobs = numel(xobs);
     violation=0;
    for i=1:nobs
       d = sqrt( (xx-xobs(i)).^2+(yy-yobs(i)).^2 );
       v = max(1-d/robs(i),0);
       violation = violation + mean(v);
    end
    sol.TP=TP;
    sol.XS =XS;
    sol.YS=YS;
    sol.ZS=ZS;
    sol.tt=tt;
    sol.xx=xx;
    sol.yy=yy;
    sol.zz=zz;
    sol.dx=dx;
    sol.dy=dy;
    sol.dz=dz;
    sol.Length=Length;
    sol.violation=violation;
    sol.IsFeasible=(violation==0);
    
    %计算协调适应值
    % 3、飞行高度限制
     high=0;
   for i=1:k-1
    point =2;
    %每一段向量分成point个点
    x_r = linspace(XS(i),XS(i+1),point);
    y_r= linspace(YS(i),YS(i+1),point);
    z_r =linspace(ZS(i),ZS(i+1),point); 
    for p=1:point
        h=terrain(x_r(p),y_r(p));        
        if z_r(p)<=(h)  %限制飞行最低高度
            high=high+10;          
        elseif z_r(p)>1   %限制飞行最高高度              
            high=high+10;           
        else  
            high=high+abs(z_r(p) -0.4); %计算与理想高度差距和      
        end        
    end
   end
    %z
  
    %w4 =20;
    %计算距离代价
     w1 =0.05;
     w2=0.3;
     w3=0.1;
     w4=5;
     %markov evaluatea
     %获取所有维度的坐标
     r_xx=[];r_yy=[];r_zz=[];
    for i=1:numel(XS)-1
    %每一段向量分成10个点
    r_x = linspace(XS(i),XS(i+1),4);
    r_y= linspace(YS(i),YS(i+1),4);
    r_z =linspace(ZS(i),ZS(i+1),4);
    r_xx = [r_xx,r_x];
    r_yy = [r_yy,r_y];
    r_zz =[r_zz ,r_z];
    end
     
    Allpos = [r_xx',r_yy',r_zz'];
   %[stateProbabilityProcess, expectedCostProcess]=MarkovEvaluate(Allpos,model);
   %sol.MarkovState = stateProbabilityProcess;
   %sol.MarkovCost = expectedCostProcess;
   start2end =norm(model.startp -model.endp);
    sol.costs=[w1*sol.Length,w3*high,w2*Length*violation];
    cost= w1* (sol.Length)+w3*high+w2*Length*violation;
     
   
end

