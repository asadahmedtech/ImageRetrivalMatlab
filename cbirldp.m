function varargout = cbirldp(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @cbirldp_OpeningFcn, ...
    'gui_OutputFcn',  @cbirldp_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before cbires is made visible.
function cbirldp_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to cbires (see VARARGIN)

% Choose default command line output for cbires
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes cbires wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = cbirldp_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btn_BrowseImage.
function btn_BrowseImage_Callback(hObject, eventdata, handles)
% hObject    handle to btn_BrowseImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[query_fname, query_pathname] = uigetfile('*.jpeg; *.png; *.bmp', 'Select query image');

if (query_fname ~= 0)
    query_fullpath = strcat(query_pathname, query_fname);
    imgInfo = imfinfo(query_fullpath);
    [pathstr, name, ext] = fileparts(query_fullpath); % fiparts returns char type
    if ( strcmpi(ext, '.jpeg') == 1 || strcmpi(ext, '.png') == 1 ...
            || strcmpi(ext, '.bmp') == 1 )
        
        queryImage = imread( fullfile( pathstr, strcat(name, ext) ) );
%         handles.queryImage = queryImage;
%         guidata(hObject, handles);
        
        % extract query image features
         set = ldp(queryImage,1,1,1,256);
%         image = rgb2gray(queryImage);
%         image = imresize(image, [88 88]);
%         set = extractLBPFeatures(image);
        queryImageFeature = [set', str2num(name)];
        
        % update handles
        handles.queryImageFeature = queryImageFeature;
        handles.img_ext = ext;
        handles.folder_name = pathstr;
        guidata(hObject, handles);
        helpdlg('Proceed with the query by executing the green button!');
        
        % Clear workspace
        clear('query_fname', 'query_pathname', 'query_fullpath', ...
            'name', 'ext', 'queryImage', 'queryImageFeature', 'imgInfo');
    else
        errordlg('You have not selected the correct file type');
    end
else
    return;
end


% --- Executes on selection change in popupmenu_DistanceFunctions.
function popupmenu_DistanceFunctions_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_DistanceFunctions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_DistanceFunctions contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_DistanceFunctions

handles.DistanceFunctions = get(handles.popupmenu_DistanceFunctions, 'Value');
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function popupmenu_DistanceFunctions_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_DistanceFunctions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_NumOfReturnedImages.
function popupmenu_NumOfReturnedImages_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_NumOfReturnedImages (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_NumOfReturnedImages contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_NumOfReturnedImages

handles.numOfReturnedImages = get(handles.popupmenu_NumOfReturnedImages, 'Value');
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function popupmenu_NumOfReturnedImages_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_NumOfReturnedImages (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btnExecuteQuery.
function btnExecuteQuery_Callback(hObject, eventdata, handles)
% hObject    handle to btnExecuteQuery (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% check for image query
if (~isfield(handles, 'queryImageFeature'))
    errordlg('Please select an image first, then choose your similarity metric and num of returned images!');
    return;
end

% check for dataset existence
if (~isfield(handles, 'imageDataset'))
    errordlg('Please load a dataset first. If you dont have one then you should consider creating one!');
    return;
end

% set variables
if (~isfield(handles, 'DistanceFunctions') && ~isfield(handles, 'numOfReturnedImages'))
    metric = get(handles.popupmenu_DistanceFunctions, 'Value');
    numOfReturnedImgs = get(handles.popupmenu_NumOfReturnedImages, 'Value');
elseif (~isfield(handles, 'DistanceFunctions') || ~isfield(handles, 'numOfReturnedImages'))
    if (~isfield(handles, 'DistanceFunctions'))
        metric = get(handles.popupmenu_DistanceFunctions, 'Value');
        numOfReturnedImgs = handles.numOfReturnedImages;
    else
        metric = handles.DistanceFunctions;
        numOfReturnedImgs = get(handles.popupmenu_NumOfReturnedImages, 'Value');
    end
else
    metric = handles.DistanceFunctions;
    numOfReturnedImgs = handles.numOfReturnedImages;
end

if (metric == 1)
    L1(numOfReturnedImgs, handles.queryImageFeature, handles.imageDataset.dataset, handles.folder_name, handles.img_ext);
elseif (metric == 2 || metric == 3 || metric == 4 || metric == 5 || metric == 6  || metric == 7 || metric == 8 || metric == 9 || metric == 10 || metric == 11)
    L2(numOfReturnedImgs, handles.queryImageFeature, handles.imageDataset.dataset, metric, handles.folder_name, handles.img_ext);
else
    relativeDeviation(numOfReturnedImgs, handles.queryImageFeature, handles.imageDataset.dataset, handles.folder_name, handles.img_ext);
end


% --- Executes on button press in btnExecuteSVM.
function btnExecuteSVM_Callback(hObject, eventdata, handles)
% hObject    handle to btnExecuteSVM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% check for image query
if (~isfield(handles, 'queryImageFeature'))
    errordlg('Please select an image first!');
    return;
end

% check for dataset existence
if (~isfield(handles, 'imageDataset'))
    errordlg('Please load a dataset first. If you dont have one then you should consider creating one!');
    return;
end

numOfReturnedImgs = get(handles.popupmenu_NumOfReturnedImages, 'Value');
metric = get(handles.popupmenu_DistanceFunctions, 'Value');

% call svm function passing as parameters the numOfReturnedImgs, queryImage and the dataset
[precision, recall, cmat] = svm(numOfReturnedImgs, handles.imageDataset.dataset, handles.queryImageFeature, metric, handles.folder_name, handles.img_ext);
fprintf('Precsion : %f \n',precision);
fprintf('Recall : %f \n',recall);
% plot confusion matrix
opt = confMatPlot('defaultOpt');
opt.className = {
    'Africa', 'Beach', 'Monuments', ...
    'Buses', 'Dinosaurs', 'Elephants', ...
    'Flowers', 'Horses', 'Mountains', ...
    'Food'
    };
opt.mode = 'both';
figure('Name', 'Confusion Matrix');
confMatPlot(cmat, opt);
xlabel('Confusion Matrix');

%Precision and Recall
if (~isfield(handles, 'imageDataset'))
    errordlg('Please select a dataset first!');
    return;
end

[p,r]=calcPandR(cmat);
% set var
% [query_fname, query_pathname] = uigetfile('*.jpg; *.png; *.bmp', 'Select query image');
% query_fullpath = strcat(query_pathname, query_fname);
% imgInfo = imfinfo(query_fullpath);
% [pathstr, name, ext] = fileparts(query_fullpath);
% 
% numOfReturnedImgs = 20;
% database = handles.imageDataset.dataset;
% metric =  get(handles.popupmenu_DistanceFunctions, 'Value');
% 
% precAndRecall = zeros(2, 10);
% 
% for k = 1:15
%     randImgName = randi([0 999], 1);
%     randStrName = int2str(randImgName);
%     randStrName = strcat( pathstr,'/', randStrName, '.jpg');
%     queryImage = imread(randStrName);
%     
%     % extract query image features
%     set = ldp(queryImage,4,4,8,2);
%     queryImageFeature = [set', randImgName];
%     disp(['Random Image = ', num2str(randImgName), '.jpg']);
%     [precision, recall] = svm(numOfReturnedImgs, database, queryImageFeature, metric);
%     precAndRecall(1, k) = precision;
%     precAndRecall(2, k) = recall;
% end
% 
% figure;
% plot(precAndRecall(2, :), precAndRecall(1, :), '--mo');
% xlabel('Recall'), ylabel('Precision');
% title('Precision and Recall');
% legend('Recall & Precision', 'Location', 'NorthWest');


% --- Executes on button press in btnPlotPrecisionRecall.
function btnPlotPrecisionRecall_Callback(hObject, eventdata, handles)
% hObject    handle to btnPlotPrecisionRecall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if (~isfield(handles, 'imageDataset'))
    errordlg('Please select a dataset first!');
    return;
end

% set variables
numOfReturnedImgs = 20;
database = handles.imageDataset.dataset;
metric =  get(handles.popupmenu_DistanceFunctions, 'Value');

precAndRecall = zeros(2, 10);

for k = 1:15
    randImgName = randi([0 999], 1);
    randStrName = int2str(randImgName);
    randStrName = strcat('/home/asad/Desktop/corel 1k/', randStrName, '.jpg');
    queryImage = imread(randStrName);
    
    % extract query image features
    set = ldp(queryImage,1,1,1,256);
    queryImageFeature = [set', randImgName];
    disp(['Random Image = ', num2str(randImgName), '.jpg']);
    [precision, recall] = svm(numOfReturnedImgs, database, queryImageFeature, metric);
    precAndRecall(1, k) = precision;
    precAndRecall(2, k) = recall;
end

figure;
plot(precAndRecall(2, :), precAndRecall(1, :), '--mo');
xlabel('Recall'), ylabel('Precision');
title('Precision and Recall');
legend('Recall & Precision', 'Location', 'NorthWest');


% --- Executes on button press in btnSelectImageDirectory.
function btnSelectImageDirectory_Callback(hObject, eventdata, handles)
% hObject    handle to btnSelectImageDirectory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% select image directory
folder_name = uigetdir(pwd, 'Select the directory of images');
if ( folder_name ~= 0 )
    handles.folder_name = folder_name;
    guidata(hObject, handles);
else
    return;
end


% --- Executes on button press in btnCreateDB.
function btnCreateDB_Callback(hObject, eventdata, handles)
% hObject    handle to btnCreateDB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles ccccand user data (see GUIDATA)

if (~isfield(handles, 'folder_name'))
    errordlg('Please select an image directory first!');
    return;
end

% construct folder name foreach image type
ImagesDir = fullfile(handles.folder_name, '*.jpeg');
% calculate total number of images
num_of_images = numel( dir(ImagesDir) );
totalImages = num_of_images;

img_files = dir(ImagesDir);
if (~isempty( img_files ))
    for k = 1:totalImages
        imgInfo = imfinfo( fullfile( handles.folder_name, img_files(k).name ) );
        if ( strcmpi( imgInfo.Format, 'jpg') == 1 )
            % read images
            sprintf('%s creating \n', img_files(k).name)
            % extract features
            image = imread( fullfile( handles.folder_name, img_files(k).name ) );
            [~, name, ~] = fileparts( fullfile( handles.folder_name, img_files(k).name ) );
        end
%           set = ldp(image,1,1,256,1);
          image = im2double(image);
%           set = get_feature_vector_lbp(image);
%         image = rgb2gray(image);
%         image = imresize(image, [88 88]);
        set = extractLBPFeatures(image);
%         add to the last column the name of image file we are processing at
        % the moment
        dataset(k, :) = [set str2num(name)];
        
        % clear workspace
        clear('image', 'set', 'imgInfo');
    end
    
    % prompt to save dataset
    uisave('dataset', 'dataset1');
    % save('dataset.mat', 'dataset', '-mat');
    clear('dataset');
end


% --- Executes on button press in btn_LoadDataset.
function btn_LoadDataset_Callback(hObject, eventdata, handles)
% hObject    handle to btn_LoadDataset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fname, pthname] = uigetfile('*.mat', 'Select the Dataset');
if (fname ~= 0)
    dataset_fullpath = strcat(pthname, fname);
    [pathstr, name, ext] = fileparts(dataset_fullpath);
    if ( strcmp(lower(ext), '.mat') == 1)
        filename = fullfile( pathstr, strcat(name, ext) );
        handles.imageDataset = load(filename);
        guidata(hObject, handles);
        % make dataset visible from workspace
        % assignin('base', 'database', handles.imageDataset.dataset);
        helpdlg('Dataset loaded successfuly!');
    else
        errordlg('You have not selected the correct file type');
    end
else
    return;
end


