clear all;close all;clc

%% ��ȡ����

 fprintf('���ڶ�ȡ����\n')
[~,~,nanchaoDATA]=xlsread("��������\pos�������б�20181124-1221.xls");
[~,~,yikatongDATA01]=xlsread("һ��ͨ��������\�ϳ�01 1124-1221.xlsx");
[~,~,yikatongDATA02]=xlsread("һ��ͨ��������\�ϳ�02 1124-1221.xlsx");
yikatongDATA=[yikatongDATA01
    yikatongDATA02(2:end,:)];
clear yikatongDATA01 yikatongDATA02
 fprintf('��ȡ�������\n')
%% �����ϳ�����ˮ
 fprintf('���ڴ����ϳ�����ˮ\n')
 nanchaoDATA_title=nanchaoDATA(1,:);
 nanchaoDATA(1,:)=[];
 nanchaoDATA(end,:)=[];
nanchaoDATA_momey=cell2mat(nanchaoDATA(:,11));
nanchaoDATA_time=datetime(nanchaoDATA(:,1),'ConvertFrom','yyyy-MM-dd HH:mm:ss');
 fprintf('�ϳ�����ˮ�������\n')
%% �����ϳ�һ��ͨ����Ϊ0����
 fprintf('���������ϳ�һ��ͨ����Ϊ0����\n')
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
 fprintf('�����ϳ�һ��ͨ����Ϊ0�������\n')
%% ����һ��ͨ���ĵ���ˮ
 fprintf('���ڴ���һ��ͨ���ĵ���ˮ\n')
 yikatongDATA_title=yikatongDATA(1,:);
 yikatongDATA(1,:)=[];
 
yikatongDATA_momey=[];
yikatongDATA_time=[];
for i=1:size(yikatongDATA,1)
yikatongDATA_momey(i,1)=cell2mat(yikatongDATA(i,16))/100;
end

time1=yikatongDATA(:,9);
time2=yikatongDATA(:,10);
time=string(time1)+' '+string(time2);
yikatongDATA_time=datetime(time,'InputFormat','yyyyMMdd HHmmss');
clear time1 time2 time

 fprintf('����һ��ͨ���ĵ���ˮ���\n')
 
 %% ��ǰ����
 fprintf('��ʼ����\n')
[nanchaoDATA_time,ind] = sort(nanchaoDATA_time);
nanchaoDATA_momey = nanchaoDATA_momey(ind,:);
nanchaoDATA = nanchaoDATA(ind,:);

[yikatongDATA_time,ind] = sort(yikatongDATA_time);
yikatongDATA_momey = yikatongDATA_momey(ind,:);
yikatongDATA = yikatongDATA(ind,:);
fprintf('�������\n')
 
 
%% �Ƚ���ˮ
 fprintf('��ʼ�Ƚ���ˮ\n')
rightDATA= [nanchaoDATA_title yikatongDATA_title];
for i=size(nanchaoDATA_momey,1):-1:1
    fprintf('\n%.0f\n',i)
    for j=size(yikatongDATA_momey,1):-1:1
        
        time_between=abs(etime(datevec(nanchaoDATA_time(i,1)),datevec(yikatongDATA_time(j,1))));
        if time_between<60*20   %�Ƚϼ��ʱ��С��20min������
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
fprintf('�Ƚ���ˮ���\n')
%% д���ļ�
fprintf('��ʼд���ļ�\n')
cell2csv('���˽������\nanchaoDATA_money_0.csv',nanchaoDATA_money_0);
cell2csv('���˽������\rightDATA.csv',rightDATA);
nanchaoDATA=[nanchaoDATA_title
    nanchaoDATA];
yikatongDATA=[yikatongDATA_title
    yikatongDATA];
cell2csv('���˽������\nanchaoDATA.csv',nanchaoDATA);
cell2csv('���˽������\yikatongDATA.csv',yikatongDATA);
fprintf('д���ļ����\n')