clear all;close all;clc
%这里是第二次对账

%% 读取数据

 fprintf('正在读取数据\n')
[~,~,nanchaoDATA]=xlsread("对账结果数据\20180421-0525nanchaoDATA.csv");
[~,~,yikatongDATA]=xlsread("对账结果数据\20180421-0525yikatongDATA.csv");


 fprintf('读取数据完毕\n')
%% 处理南超的流水
 fprintf('正在处理南超的流水\n')
 nanchaoDATA_title=nanchaoDATA(1,:);
 nanchaoDATA(1,:)=[];
 %nanchaoDATA(end,:)=[];
nanchaoDATA_momey=cell2mat(nanchaoDATA(:,11));
nanchaoDATA_time=datetime(nanchaoDATA(:,1),'ConvertFrom','yyyy-MM-dd HH:mm:ss');
 fprintf('南超的流水处理完毕\n')
%% 另存南超一卡通数据为0的行
 fprintf('正在另存南超一卡通数据为0的行\n')
nanchaoDATA_money_0=nanchaoDATA_title;
for i=size(nanchaoDATA_momey,1):-1:1
     fprintf('%.0f\n',i)
    if nanchaoDATA_momey(i,1)==0
        nanchaoDATA_money_0=[nanchaoDATA_money_0
                                    nanchaoDATA(i,:)];
        nanchaoDATA_momey(i,:)=[];
        nanchaoDATA_time(i,:)=[];
        nanchaoDATA(i,:)=[];
    end
end
 fprintf('另存南超一卡通数据为0的行完毕\n')
%% 处理一卡通中心的流水
 fprintf('正在处理一卡通中心的流水\n')
 yikatongDATA_title=yikatongDATA(2,:);
 yikatongDATA(1:2,:)=[];
yikatongDATA_momey=[];
yikatongDATA_time=[];
for i=1:size(yikatongDATA,1)
yikatongDATA_momey(i,1)=str2double(cell2mat(yikatongDATA(i,6)));
end

time1=yikatongDATA(:,13);
time2=yikatongDATA(:,14);
time=string(time1)+' '+string(time2);
yikatongDATA_time=datetime(time,'InputFormat','yyyyMMdd HHmmss');
clear time1 time2 time

 fprintf('处理一卡通中心的流水完毕\n')
 
 %% 提前排序
 fprintf('开始排序\n')
[nanchaoDATA_time,ind] = sort(nanchaoDATA_time);
nanchaoDATA_momey = nanchaoDATA_momey(ind,:);
nanchaoDATA = nanchaoDATA(ind,:);

[yikatongDATA_time,ind] = sort(yikatongDATA_time);
yikatongDATA_momey = yikatongDATA_momey(ind,:);
yikatongDATA = yikatongDATA(ind,:);
fprintf('排序完毕\n')
 
 
%% 比较流水
 fprintf('开始比较流水\n')
rightDATA_title= [nanchaoDATA_title yikatongDATA_title];
rightDATA={};
for i=size(nanchaoDATA_momey,1):-1:1
    fprintf('\n%.0f\n',i)
    for j=size(yikatongDATA_momey,1):-1:1
        
        time_between=abs(etime(datevec(nanchaoDATA_time(i,1)),datevec(yikatongDATA_time(j,1))));
        if time_between<60*60*24*30   %比较间隔时间小于30day的数据
            fprintf('%.0f,',time_between)
            if yikatongDATA_momey(j,1)==nanchaoDATA_momey(i,1)
                rightDATA= [rightDATA
                    nanchaoDATA(i,:) yikatongDATA(j,:)];
                nanchaoDATA(i,:)=[];
                yikatongDATA(j,:)=[];
                yikatongDATA_momey(j,:)=[];
                yikatongDATA_time(j,:)=[];
                nanchaoDATA_momey(i,:)=[];
                nanchaoDATA_time(i,:)=[];
                break
            end
        end
    end
end
fprintf('\n比较流水完毕\n')
%% 写入文件
fprintf('开始写入文件\n')
cell2csv('对账结果数据\nanchaoDATA_money_0_No2.csv',nanchaoDATA_money_0);
rightDATA=[rightDATA_title
    rightDATA];
cell2csv('对账结果数据\rightDATA_No2.csv',rightDATA);
nanchaoDATA=[nanchaoDATA_title
    nanchaoDATA];
yikatongDATA=[yikatongDATA_title
    yikatongDATA];
cell2csv('对账结果数据\nanchaoDATA_No2.csv',nanchaoDATA);
cell2csv('对账结果数据\yikatongDATA_No2.csv',yikatongDATA);
fprintf('写入文件完毕\n')