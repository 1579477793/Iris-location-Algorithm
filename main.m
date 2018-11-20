 clc;clear;close all; dbstop if error; warning('off');
% I=imread('D:\YJS\2018�����\�׵���\1.bmp');
P = 'D:\YJS\2018�����\CASIA-Iris-Interval\';
D = dir([P '*.jpg']);
%  tic 
for c =43:100
   c
    I = imread([P D(c).name]);
    close all;
     % I = imread('D:\YJS\2018�����\CASIA-Iris-Interval\S1069L01.jpg');  
    I=double(I)/double(max(I(:)));  % Idouble = im2double(I);  % 
    I=medfilt2(I,[3 3]);
    last=I;
   % figure,imshow(I);
    [m,n]=size(I);
    %I1=img_thresheld(I);
    %% �ָ���
    %{
    imhist(I);
    [m,n]=size(I);  
    background=imopen(I,strel('disk',6)); %���� imerode imopen
    I2=imsubtract(I,background); % ������Ŀ��
    figure,imshow(I2);
    T=graythresh(I2);
    I3=im2bw(I2,T);
    figure,imshow(I3);
    %}
    %%
    %% ͶӰ
    data_v=zeros(1,n);
    for i=1:n
        data_v(i)=sum(I(:,i));
    end 
    b = [1 1 1]/3;
    Signal_Filter = filter(b,1,data_v); 
   % figure,plot(1:n,Signal_Filter),hold on;title('��ֱ����ͶӰ');
     
     modify_V=zeros(1,n);
     for i=1:length(Signal_Filter)
         if Signal_Filter(i)<mean(Signal_Filter(:))
             modify_V(i)=Signal_Filter(i);
         end
     end
%     figure,plot(1:n,modify_V),hold on;title('��ֱ����ͶӰ');

    data_h=zeros(m,1);Signal_F=zeros(m,1);
    for i=1:m
       data_h(i)=sum(I(i,:));
    end 
    b = [1 1 1]/3;
    Signal_Filter = filter(b,1,data_h);
    % figure,plot(Signal_Filter,1:m),set(gca,'YDir','reverse');title('ˮƽ����ͶӰ'); % ���ݲ��������㣬���ʹ�ò����������  ,set(gca,'YDir','reverse')
           modify_H=zeros(1,m);
     for i=1:length(Signal_Filter)
         if Signal_Filter(i)<mean(Signal_Filter(:))
             modify_H(i)=Signal_Filter(i);
         end
     end

   %  figure,plot(modify_H,1:m) ,set(gca,'YDir','reverse');title('ˮƽ����ͶӰ');
      I_mode=ones(m,n);
     for i=1:m
         for j=1:n
             if modify_V(j)==0
                 I_mode(:,j)=0;
             end
             if modify_H(i)==0 
                 I_mode(i,:)=0;
             end

         end
     end
   % figure,imshow(I_mode),title('����ֱ��ͼ�ľ�ֵ�ָ�ͼ��');
      imLabe1 = bwlabel(I_mode);           %�Ը���ͨ����б��   
    stats = regionprops(imLabe1,'Area');    %�����ͨ��Ĵ�С  
    area = cat(1,stats.Area);  
    A=max(area);
    index = find(area == max(area));     %�������ͨ�������  
    I1 = ismember(imLabe1,index);  %��ȡ�����ͨ��ͼ�� 
   % figure,imshow(I1),title('ͫ�׸���������');
%     I_eg=I1.*I;
%     figure,imshow(I_eg);

    top = 1; 
    bottom = m;
    left = 1;
    right = n;
    while sum(I1(top,:))==0 && top<=m  %�жϵ�һ��Ԫ�صĺ�Ϊ0��
        top = top + 1;% ���ж���һ�У�ֱ�����������أ���¼�к�
    end
    while sum(I1(bottom,:))==0 && bottom>=1 %���һ��Ԫ�صĺ�Ϊ0
        bottom = bottom - 1;
    end
    while sum(I1(:,left))==0 && left<=n  %���һ��Ϊ0
        left = left + 1;
    end
    while sum(I1(:,right))==0 && right>=1 %�Ҳ�һ��Ϊ0 
        right = right - 1;
    end
    %%
    dd = right - left; 
    hh = bottom - top; 
    e = imcrop(I, [left top dd hh]); 
    % figure,imshow(e),title('ͫ�״�����ͼ��');
    T=graythresh(e);
   
    I2=im2bw(I,T);
   % figure,imshow(I2),title('ͼ���ֵ���Ľ��');
    I2=imopen(~I2,strel('square',5));
    I2=imfill(I2,'holes');
%     figure,imshow(I2);
%      I2=imopen(I2,strel('square',5));
    % figure,imshow(I2);
    
    imLabe1 = bwlabel(I2);           %�Ը���ͨ����б��   
    stats = regionprops(imLabe1,'Area');    %�����ͨ��Ĵ�С  
    area = cat(1,stats.Area);  
    A=max(area);
    index = find(area == max(area));     %�������ͨ�������  
    I1 = ismember(imLabe1,index);  %��ȡ�����ͨ��ͼ�� 
  %  figure,imshow(I1),title('ͫ�׷ָ�ͼ��');
    %% ����Բ�ģ��뾶
    [m,n] = size(I1); 
    x = ones(m,1)*(1:n);
    y = [1:m]'*ones(1,n);   
    area = sum(sum(I1)); 
    meanx = round ( sum(sum(I1.*x))/area ); 
    meany = round ( sum(sum(I1.*y))/area );
    %%
    line=edge(I1,'sobel');
    % figure,imshow(line),title('ͼ���Ե');
    distance=0;num=0;
    for i=1:m
        for j=1:n
            if line(i,j)==1
                distance=distance+sqrt( (i-meany)^2 + (j-meanx)^2 );
                num=num+1;
            end
        end
    end
    r=distance/num;
    theta=0:0.01:2*pi;
    Circle1=meanx+r*cos(theta);
    Circle2=meany+r*sin(theta);
  %   figure,imshow(I);hold on;
   % plot(meanx,meany,'r+'); %ʮ�ֱ������λ��
   % plot(Circle1,Circle2,'linewidth',2,'color','w');
    % close all;

    %% ��Ĥ����
    %{
    img_incline=zeros(m,n);
     for i=meany:m
         for j=1:n   % meanx:n %1:n  
               if atan((i-meany)/(j-meanx))*180/pi <0 && atan((i-meany)/(j-meanx))*180/pi >-20
                 img_incline(i,j)=I(i,j);
               end
         end
     end
     figure,imshow(img_incline);
     %I=img_incline;
    
    I_sum(1)=0; step=1;
    for k=1:5:round(n-meanx) % round((m-meany)/sin(2*pi/9))
       I_sum=0; number=0; I_test=ones(m,n);
        for i=meany:m
            for j= 1:n %meanx:n    1:n
                if  sqrt((i-meany)^2+(j-meanx)^2)<k+5 && k<=sqrt((i-meany)^2+(j-meanx)^2)  &&  atan((i-meany)/(j-meanx))*180/pi <0 && atan((i-meany)/(j-meanx))*180/pi >-20
                      I_sum=I_sum+img_incline(i,j);
                      number=number+1;
                end
            end
        end
         I_SUM(k)= I_sum/number ;  % ��λ����Ҷ�ֵ
    end
    n=length(I_SUM);
    x=1:5:n;
    v=I_SUM(x);
    xq=1:1:n;
    vq2 = interp1(x,v,xq,'linear');
    figure,plot(xq,vq2);
    xlim([1 n]); 
    for i=round(1.3*r):length(vq2) % round(3.5*r)
        data(i)=vq2(i);
    end
    IndMin=find(diff(sign(diff(data)))>0)+1;%
         figure; hold on; box on;  
    plot(1:length(data),data);  
    plot(IndMin,data(IndMin),'r^')  
    %%%%%%%%%%%%%%% pks_min=data(IndMin);
    legend('����','���ȵ�')  
    title('������ɢ�ڵ�Ĳ�����Ϣ', 'FontWeight', 'Bold');
    trough=zeros(1,length(IndMin)-1);
    for i=2:length(IndMin)
        trough(i-1)=IndMin(i);
    end
    [min_trough,loc_trough]=min(data(trough));
%      precise_point(i)=data(i+1)-data(i);
%     [maxr,index]=max(precise_point);
    if loc_trough==length(IndMin)-1  %����õ������һ����
        for i=IndMin(loc_trough+1):length(data)-1  % ���ݲ����λ�ã�ȷ���߽緶Χ
            precise_point(i)=data(i+1)-data(i);
            [maxr,index]=max(precise_point);
        end
   else    % precise_point=zeros(1,locs(max_num+1)-1-locs(max_num));
        for i=IndMin(loc_trough+1):IndMin(loc_trough+2)  % ���ݲ����λ�ã�ȷ���߽緶Χ
            precise_point(i)=data(i+1)-data(i);
            [maxr,index]=max(precise_point);
        end
    
   end
    figure; hold on; box on;  
    plot(xq,vq2);
    plot(index,data(index),'r^');
    r1=index;
     r=0.5*(r1+r1);
    theta=0:0.01:2*pi;
    Circle01=meanx+r*cos(theta);
    Circle02=meany+r*sin(theta);
    figure,imshow(I);hold on;
    %plot(meanx,meany,'r+'); %ʮ�ֱ������λ��
    
    plot(Circle1,Circle2,'linewidth',1,'color','w');
    plot(Circle01,Circle02,'linewidth',1,'color','w');
    %}
     right_r=right_main(I,r,meanx,meany);
    % left_r=left_main(I,r,meanx,meany);
    try 
     susp_r(5)=left_top_main(I,r,meanx,meany);
    catch  ErrorInfo
        susp_r(5)=50;
    end
    susp_r(6)=right_top_main(I,r,meanx,meany);
    susp_r(2)=right_bottom_main(I,r,meanx,meany);
    susp_r(3)=left_bottom_main(I,r,meanx,meany);
    susp_r(4)=left_main(I,r,meanx,meany);
    susp_r(1)=right_main(I,r,meanx,meany);

    %% �ж�
    susp_num=6;
    for i=1:6
        if abs(susp_r(i)-median(susp_r))>10
            susp_r(i)=0;
            susp_num=susp_num-1;
        end
    end
    x=zeros(6,1)+meanx;y=zeros(6,1)+meany;
    if susp_r(1)~=0
        x(1)=susp_r(1)+x(1);y(1)=y(1);
    end
    if susp_r(2)~=0
        x(2)=susp_r(2)*cos(5*pi/36)+x(2);y(2)=susp_r(2)*sin(5*pi/36)+y(2);
    end
    if susp_r(3)~=0
        x(3)=x(3)-susp_r(3)*cos(5*pi/36);y(3)=susp_r(3)*sin(5*pi/36)+y(3);
    end
    if susp_r(4)~=0
        x(4)=x(4)-susp_r(4);y(4)=y(4);
    end
    if susp_r(5)~=0
        x(5)=x(5)-susp_r(5)*cos(5*pi/36);y(5)=y(5)-susp_r(5)*sin(5*pi/36);
    end
    if susp_r(6)~=0
        x(6)=x(6)+susp_r(6)*cos(5*pi/36);y(6)=y(6)-susp_r(6)*sin(5*pi/36);
    end
   loc_x=x;loc_y=y;
    for i=6:-1:1 % susp_num
        if susp_r(i)==0
            loc_x(i,:)=[]; loc_y(i,:)=[];
        end
    end
%     figure,imshow(I),hold on
%     plot(loc_x,loc_y,'r+');
%% ���
    ydata = loc_y;
    xdata = loc_x;
    k0 = ones(1,3);
    F = @(k)(xdata-k(1)).^2+(ydata-k(2)).^2-k(3)^2;
    [k,resnorm] = lsqnonlin(F,k0);
    %k(1)��Բ�ĵ�x����
    %k(2)��Բ�ĵ�y����
    %k(3)�ľ���ֵ��Բ�İ뾶
    r0 = [k(1),k(2)];
    R = abs(k(3));
    xx = k(1)-R:0.01*R:k(1)+R;
    y1_h = sqrt(R.^2 - (xx - r0(1)).^2) + r0(2);
    y2_h = -sqrt(R.^2 - (xx - r0(1)).^2) + r0(2);
    figure,imshow(I),hold on
    plot(xx,y1_h,'linewidth',2,'color','w'),plot(xx,y2_h','linewidth',2,'color','w');
    plot(Circle1,Circle2,'linewidth',2,'color','w');
   % close all;

%}
end
% t=toc

% figure,imshow(I),hold on;
%  r=0.5*(r1+r2);
% rectangle('Position',[meanx-r,meany-r,2*r,2*r],'Curvature',[1,1],'EdgeColor','w'); 




