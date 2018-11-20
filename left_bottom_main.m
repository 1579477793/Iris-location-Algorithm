function left_bottom_r=left_bottom_main(I,r,meanx,meany)
%% ����Բ�����֣�����Ϊ5 
    [m,n]=size(I);
    img_incline=zeros(m,n);
     for i=meany:m
         for j=1:meanx  % meanx:n %1:n  
               if atan((i-meany)/(j-meanx))*180/pi >-30 && atan((i-meany)/(j-meanx))*180/pi<-20
                 img_incline(i,j)=I(i,j);
               end
         end
     end
     %% ��ʾ����
     %{
     sun=1;
     for i=3:m-1
         for j=3:n-1   % meanx:n %1:n  
               if img_incline(i,j)==0 && img_incline(i+1,j)~=0 || img_incline(i+1,j)==0 && img_incline(i,j)~=0
                    img_incline(i,j)=1; 
               end
             if img_incline(i,j)==0 && img_incline(i+1,j)~=0 && sun<19000  || img_incline(i+1,j)==0 && img_incline(i,j)~=0 && sun<19000
                    img_incline(i-1,j)=1; 
                    sun=sun+1;
             end
             if img_incline(i,j)==0 && img_incline(i+1,j)~=0 && sun<19000 || img_incline(i+1,j)==0 && img_incline(i,j)~=0 && sun<19000
                    img_incline(i-1,j)=1;  img_incline(i-1,j-1)=1; img_incline(i-2,j-2)=1; img_incline(i,j-1)=1;img_incline(i,j)=1; img_incline(i-1,j-2)=1;img_incline(i-2,j-1)=1;img_incline(i,j-2)=1;
                    sun=sun+1;
              end
         end
     end
     for i=1:m
         for j=1:meanx
             if i==450  || i==449 ||  i==448 ||i==447 ||i==446 
                img_incline(i-1,j)=1; 
             end
         end
     end
%}
%       figure,imshow(img_incline);   
     %%left_r
    I_sum(1)=0; step=1;
    for k=1:5:round(n-meanx) % round((m-meany)/sin(2*pi/9))
       I_sum=0; number=0; I_test=ones(m,n);
        for i=meany:m
            for j= 1:meanx %1:n %meanx:n    1:n
                if  sqrt((i-meany)^2+(j-meanx)^2)<k+5 && k<=sqrt((i-meany)^2+(j-meanx)^2)  &&  atan((i-meany)/(j-meanx))*180/pi>-30 && atan((i-meany)/(j-meanx))*180/pi<-20
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
%     figure,plot(xq,vq2);
%     xlim([1 n]); 
    % title('linear Interpolation'); 
    
    %%
    
    for i=round(1.3*r): length(vq2)
        data(i)=vq2(i);
    end
%    figure,plot(data);
    %%
    IndMin=find(diff(sign(diff(data)))>0)+1;%,Find local minima�� data(IndMin)��Ӧ��ֵ��IndMin��Ӧ��ֵ��x���λ��
%      figure; hold on; box on;  
%     plot(1:length(data),data);  
%     plot(IndMin,data(IndMin),'r^');
%     legend('����','���ȵ�');
%     title('������ɢ�ڵ�Ĳ�����Ϣ', 'FontWeight', 'Bold');
    %%
    [pks_max,locs]=findpeaks(data,'minpeakdistance',1);% Find local maxima��pks_max ��Ӧ��ֵ��locs ��Ӧ��ֵ�ĺ�����λ��
%     figure; hold on; box on;  
%     plot(1:length(data),data);  
%     plot(locs,data(locs),'r^');
%     legend('����','�����');
%     title('������ɢ�ڵ�Ĳ�����Ϣ', 'FontWeight', 'Bold');
    [~ ,y1]=max(pks_max); % y1����ֵ�ڼ�ֵ�е�λ�ã����޸���1��ʼ������������locs(y1)�Ǽ���ֵ��Ӧ�ĺ�����
    if data(locs(y1))<data(length(data))
        locs(y1)=length(data);
    end
    
    
    
    %%
    trough=zeros(1,length(IndMin)-1);
    for i=2:length(IndMin)
        trough(i-1)=IndMin(i); %IndMin��Ӧ��ֵ��x���λ�ã�troughȥ���˵�һ����
    end
    [min_trough,loc_trough]=min(data(trough)); %�������ȵ�Ƚ���Сֵ��min_trough�Ǽ�Сֵ��loc_trough��Сֵ�ڼ�ֵ�е�λ�ã����޸���1��ʼ����������
                                               % IndMin(loc_trough+1)�Ǽ�Сֵ��ԭ�����е�λ��(������)��data(IndMin(loc_trough+1))�Ǽ�Сֵ��Ӧ�Ĵ�С�������꣩
                                               % min_trough �� data(IndMin(loc_trough+1))һ����С
%      figure; hold on; box on; 
%      plot(1:length(data),data);  
%     plot(IndMin(loc_trough+1),data(IndMin(loc_trough+1)),'r^') ;
    if locs(y1)<IndMin(loc_trough+1) % ��֤locs(y1)�����ڼ�Сֵ���Ҳ�
        locs(y1)=length(vq2);
    end
    %{
   if loc_trough==length(IndMin)-1  %����õ������һ����,��ô�ʹ����һ���㿪ʼ������������������ݶ����ĵط����Ǳ߽�
        for i=IndMin(loc_trough+1): locs(y1)-1% length(data)-1  % ���ݲ����λ�ã�ȷ���߽緶Χ
            precise_point(i)=data(i+1)-data(i);
            [maxr,index]=max(precise_point);
        end
   else    % precise_point=zeros(1,locs(max_num+1)-1-locs(max_num)); %����õ��ǲ������һ����,��ô�ʹӸõ㵽��һ�����ȵ��������������ݶ����ĵط����Ǳ߽�
        for i=IndMin(loc_trough+1): locs(y1)-1% IndMin(loc_trough+2)  % ���ݲ����λ�ã�ȷ���߽緶Χ
            precise_point(i)=data(i+1)-data(i);
            [maxr,index]=max(precise_point);
        end
    
   end
    %}
    for i=IndMin(loc_trough+1): locs(y1)-1% length(data)-1  % ���ݲ����λ�ã�ȷ���߽緶Χ
            precise_point(i)=data(i+1)-data(i);
            [maxr,index]=max(precise_point);
    end
%     figure; hold on; box on;  
%     plot(xq,vq2);
%     plot(index,data(index),'r^');
    left_bottom_r=index+5;