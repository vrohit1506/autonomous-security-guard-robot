function varargout = MainGUI(varargin)
clc;

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MainGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @MainGUI_OutputFcn, ...
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


% --- Executes just before MainGUI is made visible.
function MainGUI_OpeningFcn(hObject, eventdata, handles, varargin)

handles.video = videoinput('winvideo', 1,'YUY2_320x240');
set(handles.video,'TimerPeriod', 0.01, ...
'TimerFcn',['if(~isempty(gco)),'...
'handles=guidata(gcf);'... % Update handles
'imshow(ycbcr2rgb(getsnapshot(handles.video)));rectangle(''Position'',[70 20 179 199],''EdgeColor'',''r'');'... % Get picture using GETSNAPSHOT and put it into axes using IMAGE
'set(handles.VideoCam,''ytick'',[],''xtick'',[]),'... % Remove tickmarks and labels that are inserted when using IMAGE
'else '...
'delete(imaqfind);'... % Clean up - delete any image acquisition objects
'end']);
triggerconfig(handles.video,'manual');
handles.video.FramesPerTrigger = Inf;
 
guidata(hObject, handles);
%startStopCamera_Callback(hObject, eventdata, handles);
% UIWAIT makes MainGUI wait for user response (see UIRESUME)
 uiwait(handles.MainGUI);
%uiwait(handles.MainGUI);


% --- Outputs from this function are returned to the command line.
function varargout = MainGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
handles.output = hObject;
varargout{1} = handles.output;


% --- Executes on button press in startStopCamera.
function startStopCamera_Callback(hObject, eventdata, handles)
set(handles.Msg,'String','');
if strcmp(get(handles.startStopCamera,'String'),'Start Camera')
    set(handles.startStopCamera,'String','Stop Camera')
    axes(handles.VideoCam);
    start(handles.video);
else
    set(handles.startStopCamera,'String','Start Camera')
    axes(handles.VideoCam);
    stop(handles.video);
end


% --- Executes when user attempts to close MainGUI.
function MainGUI_CloseRequestFcn(hObject, eventdata, handles)
if strcmp(get(handles.startStopCamera,'String'),'Stop Camera')
stop(handles.video);
end
delete(hObject);


% --- Executes on button press in Face.
function Face_Callback(hObject, eventdata, handles)

if strcmp(get(handles.startStopCamera,'String'),'Stop Camera')
    
    imgface=ycbcr2rgb(getsnapshot(handles.video));
    imgface=imcrop(imgface,[70,20,179,199]);
    stop(handles.video);
    axes(handles.faceAxes);
    imshow(imgface);
    if(size(imgface)==3)
        imgface=rgb2gray(imgface);
    end
    
    %[ EV IW m M] = CreateEigenVector( 'trFcdb','jpg' );
    %[ id im ] = EigenMatch( imgface,EV,IW,m,M);
   % [id im]=getImgMatch(imgface,'trFcdb');
    T = CreateDatabase('trFcdb');
[m V_PCA V_Fisher ProjectedImages_Fisher] = FisherfaceCore(T);
OutputName = Recognition(imgface, m, V_PCA, V_Fisher, ProjectedImages_Fisher);

SelectedImage = strcat('trFcdb\',OutputName); 
display(SelectedImage);
    set(handles.fc,'String',SelectedImage);
    axes(handles.VideoCam);
    start(handles.video)
    
else
    set(handles.Msg,'String','Please Turn ON the camera');
end



% --- Executes on button press in Match.
function Match_Callback(hObject, eventdata, handles)
face=(get(handles.fc,'String'));
fcdb='fc_database.dat';
if (exist(fcdb,'file')==2)
    load(fcdb,'-mat');
end
for i=1:fc_no
    if strcmp(face,fname)
        set(handles.Msg,'String',pname);
    end
end
if strcmp(get(handles.startStopCamera,'String'),'Stop Camera')
    
    stop(handles.video);
    axes(handles.RegFaceAxes);
    imgface=imread(face);
    imshow(imgface);
     
    axes(handles.VideoCam);
    start(handles.video)
    
else
    axes(handles.RegFaceAxes);
    imgface=imread(face);
    imshow(imgface);
     
    axes(handles.VideoCam)
end

 


% --- Executes during object creation, after setting all properties.
function fc_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in browse.
function browse_Callback(hObject, eventdata, handles)
if strcmp(get(handles.startStopCamera,'String'),'Start Camera')
    
[namefile,pathname]=uigetfile({'*.jpg;*.jpeg','IMAGE Files (*.jpg,*.jpeg)'});
img=imread(strcat(pathname,namefile));
[r c z]=size(img);
if r>200 && c>180
    img=imcrop(img,[70,20,179,199]);
end
axes(handles.faceAxes);
        handles.face1=img;
        guidata(hObject, handles);
        imshow(handles.face1);
       T = CreateDatabase('trFcdb');
[m V_PCA V_Fisher ProjectedImages_Fisher] = FisherfaceCore(T);
OutputName = Recognition(img, m, V_PCA, V_Fisher, ProjectedImages_Fisher);

SelectedImage = strcat('trFcdb\',OutputName); 
display(SelectedImage);
    set(handles.fc,'String',SelectedImage);
    %[ EV IW m M] = CreateEigenVector( 'trFcdb','jpg' );
    %[ id im ] = EigenMatch( img,EV,IW,m,M );    
    
axes(handles.VideoCam);

else
stop(handles.video);
[namefile,pathname]=uigetfile({'*.jpg;*.jpeg','IMAGE Files (*.jpg,*.jpeg)'});
img=imread(strcat(pathname,namefile));
[r c z]=size(img);
if r>200 && c>180
    img=imcrop(img,[70,20,179,199]);
end

   
        axes(handles.faceAxes);
        handles.face1=img;
        guidata(hObject, handles);
        imshow(handles.face1);
        T = CreateDatabase('trFcdb');
[m V_PCA V_Fisher ProjectedImages_Fisher] = FisherfaceCore(T);
OutputName = Recognition(img, m, V_PCA, V_Fisher, ProjectedImages_Fisher);

SelectedImage = strcat('trFcdb\',OutputName); 
display(SelectedImage);
    set(handles.fc,'String',SelectedImage);
   % [ EV IW m M ] = CreateEigenVector( 'trFcdb','jpg' );
   % [ id im ] = EigenMatch( img,EV,IW,m,M );
    %display(id);
    

axes(handles.VideoCam);
start(handles.video);

end
%guidata(hObject, handles);
