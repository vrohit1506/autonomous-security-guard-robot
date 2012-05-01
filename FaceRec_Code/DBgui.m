function varargout = DBgui(varargin)
clc;
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DBgui_OpeningFcn, ...
                   'gui_OutputFcn',  @DBgui_OutputFcn, ...
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


% --- Executes just before DBgui is made visible.
function DBgui_OpeningFcn(hObject, eventdata, handles, varargin)

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
uiwait(handles.DBgui);


% --- Outputs from this function are returned to the command line.
function varargout = DBgui_OutputFcn(hObject, eventdata, handles) 
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




function pname_Callback(hObject, eventdata, handles)
% hObject    handle to pname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pname as text
%        str2double(get(hObject,'String')) returns contents of pname as a double


% --- Executes during object creation, after setting all properties.
function pname_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when user attempts to close DBgui.
function DBgui_CloseRequestFcn(hObject, eventdata, handles)
if strcmp(get(handles.startStopCamera,'String'),'Stop Camera')
stop(handles.video);
end
delete(hObject);


% --- Executes on button press in DB.
function DB_Callback(hObject, eventdata, handles)
name=get(handles.pname,'String');
if ~strcmp(name,'')
    no=Add2Database(handles.face1,name);
    
    set(handles.Msg,'String',strcat('New record added at:-',int2str(no)));
else
    set(handles.Msg,'String','Please enter Person name');
end 



% --- Executes on button press in captureFace.
function captureFace_Callback(hObject, eventdata, handles)
if strcmp(get(handles.startStopCamera,'String'),'Stop Camera')
    
    face=ycbcr2rgb(getsnapshot(handles.video));
    face=imcrop(face,[70,20,179,199]);
    stop(handles.video);
    if strcmp(get(handles.Fcnt,'String'),'0')
        axes(handles.FaceAxes1);
        handles.face1=face;
        guidata(hObject, handles);
        imshow(handles.face1);
        set(handles.Fcnt,'String','0');
    %else if strcmp(get(handles.Fcnt,'String'),'1')
    %    axes(handles.FaceAxes2);
    %    handles.face2=face;
    %    guidata(hObject, handles);
    %    imshow(handles.face2);
    %    set(handles.Fcnt,'String','0');
    %    end
    end
        
    
    axes(handles.VideoCam);
    start(handles.video);
    
else
    set(handles.Msg,'String','Please Turn ON the camera');
end
%guidata(hObject, handles);


% --- Executes on button press in browseFingerprint.
function browseFingerprint_Callback(hObject, eventdata, handles)
!sgdx
if strcmp(get(handles.startStopCamera,'String'),'Start Camera')
    
   % [namefile,pathname]=uigetfile({'*.bmp;*.tif;*.tiff;*.jpg;*.jpeg;*.gif','IMAGE Files (*.bmp,*.tif,*.tiff,*.jpg,*.jpeg,*.gif)'});
img=imread('new.bmp');
if (exist('new.bmp','file')==2)
    delete('new.bmp');
end
if size(img,3)==3
    img=rgb2gray(img);
end
handles.finger1=img;
guidata(hObject, handles);
axes(handles.FingerAxes1);
imshow(handles.finger1);
axes(handles.VideoCam);

else
stop(handles.video);
%[namefile,pathname]=uigetfile({'*.bmp;*.tif;*.tiff;*.jpg;*.jpeg;*.gif','IMAGE Files (*.bmp,*.tif,*.tiff,*.jpg,*.jpeg,*.gif)'});
%img=imread(strcat(pathname,namefile));
img=imread('new.bmp');
if (exist('new.bmp','file')==2)
    delete('new.bmp');
end
if size(img,3)==3
    img=rgb2gray(img);
end
handles.finger1=img;
guidata(hObject, handles);
axes(handles.FingerAxes1);
imshow(handles.finger1);
axes(handles.VideoCam);
start(handles.video);

end
%guidata(hObject, handles);



function Fcnt_Callback(hObject, eventdata, handles)
% hObject    handle to Fcnt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Fcnt as text
%        str2double(get(hObject,'String')) returns contents of Fcnt as a double


% --- Executes during object creation, after setting all properties.
function Fcnt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Fcnt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Pcnt_Callback(hObject, eventdata, handles)
% hObject    handle to Pcnt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Pcnt as text
%        str2double(get(hObject,'String')) returns contents of Pcnt as a double


% --- Executes during object creation, after setting all properties.
function Pcnt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Pcnt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
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
 if strcmp(get(handles.Fcnt,'String'),'0')
        axes(handles.FaceAxes1);
        handles.face1=img;
        guidata(hObject, handles);
        imshow(handles.face1);
        set(handles.Fcnt,'String','0');
    %else if strcmp(get(handles.Fcnt,'String'),'1')
    %    axes(handles.FaceAxes2);
    %    handles.face2=img;
    %    guidata(hObject, handles);
    %    imshow(handles.face2);
    %    set(handles.Fcnt,'String','0');
    %    end
 end
axes(handles.VideoCam);

else
stop(handles.video);
[namefile,pathname]=uigetfile({'*.jpg;*.jpeg','IMAGE Files (*.jpg,*.jpeg)'});
img=imread(strcat(pathname,namefile));
[r c z]=size(img);
if r>200 && c>180
    img=imcrop(img,[70,20,179,199]);
end

    if strcmp(get(handles.Fcnt,'String'),'0')
        axes(handles.FaceAxes1);
        handles.face1=img;
        guidata(hObject, handles);
        imshow(handles.face1);
        set(handles.Fcnt,'String','0');
    %else if strcmp(get(handles.Fcnt,'String'),'1')
    %    axes(handles.FaceAxes2);
    %    handles.face2=img;
    %    guidata(hObject, handles);
    %    imshow(handles.face2);
    %    set(handles.Fcnt,'String','0');
    %    end
    end

axes(handles.VideoCam);
start(handles.video);

end
%guidata(hObject, handles);
