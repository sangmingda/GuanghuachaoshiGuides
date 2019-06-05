clear all;close all;clc

%% 读取数据

fprintf('正在读取数据\n')

% ！！！这里可能需要更改
[~,~,nanchaoDATA]=xlsread("超市数据\pos单销售列表20180421-0525.xls");    % ！！要把文件地址和文件名改为超市导出的文件名
[~,~,yikatongDATA01]=xlsread("一卡通中心数据\交易流水查询.xls");          %！！要把文件地址和文件名改为一卡通中心导出的文件名
[~,~,yikatongDATA02]=xlsread("一卡通中心数据\交易流水查询02.xls");        %！！要把文件地址和文件名改为一卡通中心导出的文件名
% ！！！

yikatongDATA=[yikatongDATA01
    yikatongDATA02(2:end,:)];  %把一卡通中心的两个文件合并为一个文件（南超有两个前台pos机，所以有两个文件）
clear yikatongDATA01 yikatongDATA02
fprintf('读取数据完毕\n')
%% 处理南超的流水
fprintf('正在处理南超的流水\n')
nanchaoDATA_title=nanchaoDATA(1,:);
nanchaoDATA(1,:)=[];   %删除南超文件的第一行
nanchaoDATA(end,:)=[];%删除南超文件的最后一行

% ！！！这里可能需要更改
nanchaoDATA_momey=cell2mat(nanchaoDATA(:,11));%提取南超数据里面的每笔流水的金额（第11列），并把单元格格式转换成数字格式
% ！！！

nanchaoDATA_time=datetime(nanchaoDATA(:,1),'ConvertFrom','yyyy-MM-dd HH:mm:ss');%提取南超数据里面的每笔流水的时间（第1列），并把单元格格式转换成时间格式
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

% ！！！这里可能需要更改
yikatongDATA_title=yikatongDATA(2,:);%记录下来一卡通中心数据的标题   ！！！有时候文件标题是一行！！！
yikatongDATA(1:2,:)=[];%删除一卡通中心数据的前两行标题   ！！！有时候文件标题是一行！！！
% ！！！这里可能需要更改

yikatongDATA_momey=[];
yikatongDATA_time=[];
for i=1:size(yikatongDATA,1)
    
    % ！！！这里可能需要更改
    yikatongDATA_momey(i,1)=str2double(cell2mat(yikatongDATA(i,6)));%金额在第6列，提取一卡通中心数据里面的每笔流水的金额，并把单元格格式转换成数字格式
    % ！！！这里可能需要更改
    
end

% ！！！这里可能需要更改
time1=yikatongDATA(:,13);%日期在第13列
time2=yikatongDATA(:,14);%时间在第14列
% ！！！这里可能需要更改

time=string(time1)+' '+string(time2);
yikatongDATA_time=datetime(time,'InputFormat','yyyyMMdd HHmmss');%提取一卡通中心数据里面的每笔流水的时间，并把单元格格式转换成时间格式
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
        
        % ！！！这里可能需要更改
        if time_between<60*20   %比较间隔时间小于20min的数据，这里的单位是秒s，代表比对流水时，超市流水和一卡通流水的时间差上限，小于这个值的会抵消，视为已结账
         % ！！！这里可能需要更改   
            
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
fprintf('比较流水完毕\n')
%% 写入文件
fprintf('开始写入文件\n')

cell2csv('对账结果数据\nanchaoDATA_money_0.csv',nanchaoDATA_money_0);%写入南超流水中，一卡通金额为0的数据

rightDATA=[rightDATA_title
    rightDATA];
cell2csv('对账结果数据\rightDATA.csv',rightDATA);%写入流水中，超市和一卡通中心流水金额相同，流水时间相近的数据（也就是正确的数据）

nanchaoDATA=[nanchaoDATA_title
    nanchaoDATA];
yikatongDATA=[yikatongDATA_title
    yikatongDATA];
cell2csv('对账结果数据\nanchaoDATA.csv',nanchaoDATA);%写入流水中，剩余的超市流水（也就是在给定时间间隔里面，没有找到相应的一卡通中心的数据，即没有对上帐的数据）
cell2csv('对账结果数据\yikatongDATA.csv',yikatongDATA);%写入流水中，剩余的一卡通中心流水（也就是在给定时间间隔里面，没有找到相应的超市流水的数据，即没有对上帐的数据）

fprintf('写入文件完毕\n')