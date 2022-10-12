function varargout = MCT(varargin)
% MCT MATLAB code for MCT.fig
%      MCT, by itself, creates a new MCT or raises the existing
%      singleton*.
%
%      H = MCT returns the handle to a new MCT or the handle to
%      the existing singleton*.
%
%      MCT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MCT.M with the given input arguments.
%
%      MCT('Property','Value',...) creates a new MCT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MCT_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MCT_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MCT

% Last Modified by GUIDE v2.5 14-Sep-2019 21:40:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MCT_OpeningFcn, ...
                   'gui_OutputFcn',  @MCT_OutputFcn, ...
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


% --- Executes just before MCT is made visible.
function MCT_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MCT (see VARARGIN)

% Choose default command line output for MCT
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

set(handles.text33, 'style', 'text', 'string', ...
      ['Diffusion coefficient (',char(hex2dec(strsplit('03BC'))),'m',char(hex2dec(strsplit('00B2'))),'/s)'])
set(handles.D_beta, 'style', 'text', 'string', ...
      [char(hex2dec(strsplit('03B2'))),'   parameter of diffusion coef. prior (',...
       char(hex2dec(strsplit('03BC'))),'m',char(hex2dec(strsplit('00B2'))),'/s)'])
set(handles.text27, 'style', 'text', 'string', ...
      ['Initial position',char(hex2dec(strsplit('0027'))),'s variance in xy plane (',...
       char(hex2dec(strsplit('03BC'))),'m',char(hex2dec(strsplit('00B2'))),' )'])
set(handles.text46, 'style', 'text', 'string', ...
      ['Initial position',char(hex2dec(strsplit('0027'))),'s variance in z axis (',...
       char(hex2dec(strsplit('03BC'))),'m',char(hex2dec(strsplit('00B2'))),' )'])
set(handles.text57, 'style', 'text', 'string', ...
      ['Convergence threshold (',char(hex2dec(strsplit('03BC'))),'m',char(hex2dec(strsplit('00B2'))),'/s)'])
 
 

% Add the function folder to the path
addpath('sampler_Fun')

% Add the raw data folder to the path
addpath('raw_data')

% Creat the MEX files related to the thomas algorithm and save them in the folder of 'sampler_Fun'
Current_folder = cd;
cd([Current_folder,'/sampler_Fun'])
mex tri_solver_binned.c
mex tri_solver_single_photons.c
cd(Current_folder)


% UIWAIT makes MCT wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MCT_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Start.
function Start_Callback(hObject, eventdata, handles)
% hObject    handle to Start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Stop.
function Stop_Callback(hObject, eventdata, handles)
% hObject    handle to Stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in partial_signal.
function partial_signal_Callback(hObject, eventdata, handles)
% hObject    handle to partial_signal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function Min_signal_Callback(hObject, eventdata, handles)
% hObject    handle to Min_signal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Min_signal as text
%        str2double(get(hObject,'String')) returns contents of Min_signal as a double


% --- Executes during object creation, after setting all properties.
function Min_signal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Min_signal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Max_signal_Callback(hObject, eventdata, handles)
% hObject    handle to Max_signal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Max_signal as text
%        str2double(get(hObject,'String')) returns contents of Max_signal as a double


% --- Executes during object creation, after setting all properties.
function Max_signal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Max_signal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Results_show.
function Results_show_Callback(hObject, eventdata, handles)
% hObject    handle to Results_show (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function Refractive_index_Callback(hObject, eventdata, handles)
% hObject    handle to Refractive_index (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Refractive_index as text
%        str2double(get(hObject,'String')) returns contents of Refractive_index as a double


% --- Executes during object creation, after setting all properties.
function Refractive_index_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Refractive_index (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Laser_Wavelength_Callback(hObject, eventdata, handles)
% hObject    handle to Laser_Wavelength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Laser_Wavelength as text
%        str2double(get(hObject,'String')) returns contents of Laser_Wavelength as a double


% --- Executes during object creation, after setting all properties.
function Laser_Wavelength_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Laser_Wavelength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function Objective_magnification_Callback(hObject, eventdata, handles)
% hObject    handle to Objective_magnification (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Objective_magnification as text
%        str2double(get(hObject,'String')) returns contents of Objective_magnification as a double


% --- Executes during object creation, after setting all properties.
function Objective_magnification_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Objective_magnification (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function wx_Callback(hObject, eventdata, handles)
% hObject    handle to wx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of wx as text
%        str2double(get(hObject,'String')) returns contents of wx as a double


% --- Executes during object creation, after setting all properties.
function wx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function wz_Callback(hObject, eventdata, handles)
% hObject    handle to wz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of wz as text
%        str2double(get(hObject,'String')) returns contents of wz as a double


% --- Executes during object creation, after setting all properties.
function wz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function mu_back_Callback(hObject, eventdata, handles)
% hObject    handle to mu_back (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mu_back as text
%        str2double(get(hObject,'String')) returns contents of mu_back as a double



% --- Executes during object creation, after setting all properties.
function mu_back_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mu_back (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function Delta_t_Callback(hObject, eventdata, handles)
% hObject    handle to Delta_t (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Delta_t as text
%        str2double(get(hObject,'String')) returns contents of Delta_t as a double


% --- Executes during object creation, after setting all properties.
function Delta_t_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Delta_t (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function concen_radious_xy_Callback(hObject, eventdata, handles)
% hObject    handle to concen_radious (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of concen_radious as text
%        str2double(get(hObject,'String')) returns contents of concen_radious as a double


% --- Executes during object creation, after setting all properties.
function concen_radious_xy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to concen_radious (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function concen_radious_z_Callback(hObject, eventdata, handles)
% hObject    handle to concen_radious_z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of concen_radious_z as text
%        str2double(get(hObject,'String')) returns contents of concen_radious_z as a double


% --- Executes during object creation, after setting all properties.
function concen_radious_z_CreateFcn(hObject, eventdata, handles)
% hObject    handle to concen_radious_z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function mu_prior_z_Callback(hObject, eventdata, handles)
% hObject    handle to mu_prior_z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mu_prior_z as text
%        str2double(get(hObject,'String')) returns contents of mu_prior_z as a double


% --- Executes during object creation, after setting all properties.
function mu_prior_z_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mu_prior_z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function var_prior_xy_Callback(hObject, eventdata, handles)
% hObject    handle to var_prior_xy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of var_prior_xy as text
%        str2double(get(hObject,'String')) returns contents of var_prior_xy as a double


% --- Executes during object creation, after setting all properties.
function var_prior_xy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to var_prior_xy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function mu_prior_xy_Callback(hObject, eventdata, handles)
% hObject    handle to mu_prior_xy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mu_prior_xy as text
%        str2double(get(hObject,'String')) returns contents of mu_prior_xy as a double


% --- Executes during object creation, after setting all properties.
function mu_prior_xy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mu_prior_xy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function alpha_load_Callback(hObject, eventdata, handles)
% hObject    handle to alpha_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of alpha_load as text
%        str2double(get(hObject,'String')) returns contents of alpha_load as a double


% --- Executes during object creation, after setting all properties.
function alpha_load_CreateFcn(hObject, eventdata, handles)
% hObject    handle to alpha_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end






function Number_particles_Callback(hObject, eventdata, handles)
% hObject    handle to Number_particles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Number_particles as text
%        str2double(get(hObject,'String')) returns contents of Number_particles as a double


% --- Executes during object creation, after setting all properties.
function Number_particles_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Number_particles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function mu_init_Callback(hObject, eventdata, handles)
% hObject    handle to mu_init (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mu_init as text
%        str2double(get(hObject,'String')) returns contents of mu_init as a double


% --- Executes during object creation, after setting all properties.
function mu_init_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mu_init (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function mu_alpha_Callback(hObject, eventdata, handles)
% hObject    handle to mu_alpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mu_alpha as text
%        str2double(get(hObject,'String')) returns contents of mu_alpha as a double


% --- Executes during object creation, after setting all properties.
function mu_alpha_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mu_alpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function mu_beta_Callback(hObject, eventdata, handles)
% hObject    handle to mu_beta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mu_beta as text
%        str2double(get(hObject,'String')) returns contents of mu_beta as a double


% --- Executes during object creation, after setting all properties.
function mu_beta_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mu_beta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function D_init_Callback(hObject, eventdata, handles)
% hObject    handle to D_init (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of D_init as text
%        str2double(get(hObject,'String')) returns contents of D_init as a double


% --- Executes during object creation, after setting all properties.
function D_init_CreateFcn(hObject, eventdata, handles)
% hObject    handle to D_init (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function D_alpha_prior_Callback(hObject, eventdata, handles)
% hObject    handle to D_alpha_prior (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of D_alpha_prior as text
%        str2double(get(hObject,'String')) returns contents of D_alpha_prior as a double


% --- Executes during object creation, after setting all properties.
function D_alpha_prior_CreateFcn(hObject, eventdata, handles)
% hObject    handle to D_alpha_prior (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function D_beta_prior_Callback(hObject, eventdata, handles)
% hObject    handle to D_beta_prior (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of D_beta_prior as text
%        str2double(get(hObject,'String')) returns contents of D_beta_prior as a double


% --- Executes during object creation, after setting all properties.
function D_beta_prior_CreateFcn(hObject, eventdata, handles)
% hObject    handle to D_beta_prior (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Diff_synth_Callback(hObject, eventdata, handles)
% hObject    handle to Diff_synth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Diff_synth as text
%        str2double(get(hObject,'String')) returns contents of Diff_synth as a double


% --- Executes during object creation, after setting all properties.
function Diff_synth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Diff_synth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function mu_synth_Callback(hObject, eventdata, handles)
% hObject    handle to mu_synth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mu_synth as text
%        str2double(get(hObject,'String')) returns contents of mu_synth as a double


% --- Executes during object creation, after setting all properties.
function mu_synth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mu_synth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Num_synth_Callback(hObject, eventdata, handles)
% hObject    handle to Num_synth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Num_synth as text
%        str2double(get(hObject,'String')) returns contents of Num_synth as a double


% --- Executes during object creation, after setting all properties.
function Num_synth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Num_synth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function edit35_Callback(hObject, eventdata, handles)
% hObject    handle to edit35 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit35 as text
%        str2double(get(hObject,'String')) returns contents of edit35 as a double


% --- Executes during object creation, after setting all properties.
function edit35_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit35 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit36_Callback(hObject, eventdata, handles)
% hObject    handle to edit36 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit36 as text
%        str2double(get(hObject,'String')) returns contents of edit36 as a double


% --- Executes during object creation, after setting all properties.
function edit36_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit36 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1


% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox4


% --- Executes on button press in checkbox3.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3


% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3



function edit44_Callback(hObject, eventdata, handles)
% hObject    handle to edit44 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit44 as text
%        str2double(get(hObject,'String')) returns contents of edit44 as a double


% --- Executes during object creation, after setting all properties.
function edit44_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit44 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    load('results.mat');
    
    handles.edit44.Enable                        ='off';
    handles.checkbox1.Enable                     ='off';
    handles.checkbox2.Enable                     ='off';
    handles.checkbox3.Enable                     ='off';
    handles.checkbox4.Enable                     ='off';
    handles.checkbox7.Enable                     ='off';
    handles.checkbox8.Enable                     ='off';


    MAXX=floor(length(Data.D)*str2num(handles.edit44.String));
    
if handles.checkbox1.Value==1
   
        
   figure(1)
   subplot(2,1,1)
  
      hist_D=histogram(Data.D(MAXX:end),logspace(log10(min(Data.D(MAXX:end))),log10(max(Data.D(MAXX:end))),100),...
           'Normalization','pdf','FaceColor',[0    0.4470    0.7410]);

      hh=patch([quantile(Data.D(MAXX:end),0.025) ,...
                quantile(Data.D(MAXX:end),0.975) ,...
                quantile(Data.D(MAXX:end),0.975) ,...
                quantile(Data.D(MAXX:end),0.025)],...
               [0 0 1.1*max(hist_D.Values) 1.1*max(hist_D.Values)],'c');
      set(hh,'FaceAlpha',0.2,'EdgeColor','none')
      hold on
      histogram(Data.D(MAXX:end),logspace(log10(min(Data.D(MAXX:end))),log10(max(Data.D(MAXX:end))),100),...
           'Normalization','pdf','FaceColor',[0    0.4470    0.7410]);
      
      ylim([0 1.3*max(hist_D.Values)])
      xlim([0  max(Data.D(MAXX:end))])
      set(gca,'XScale','log')
      xlabel('Diff. coeff. (\mum^2/s)');
      ylabel('Posterior');
      legend([hist_D,hh],'Posterior',...
                         '95% confidence interval',...
                         'Orientation','Horizontal','location','North','Box','off');

   subplot(2,1,2)
   
      plot(1:1:MAXX,Data.D(1:MAXX),'color',[1    0    0])
      hold on
      plot(MAXX:1:str2num(handles.edit39.String)+1,Data.D(MAXX:end),'color',[0    0.4470    0.7410])
      xlabel('Iteration')
      ylabel('Diff. coeff. (\mum^2/s) in Log scale')
      set(gca,'YScale','log')

end
    
      
if handles.checkbox2.Value==1
    
   figure(3)
   for  mm=1:length(Data.Wxyz(1,:))
        subplot(2,length(Data.Wxyz(1,:)),mm)
        hist_mu=histogram(Data.mu(MAXX:end),logspace(log10(min(Data.mu(MAXX:end,mm))),...
                          log10(max(Data.mu(MAXX:end,mm))),100),...
                          'Normalization','pdf','FaceColor',[0    0.4470    0.7410]);
      
        hh=patch([quantile(Data.mu(MAXX:end,mm),0.025) ,...
                  quantile(Data.mu(MAXX:end,mm),0.975) ,...
                  quantile(Data.mu(MAXX:end,mm),0.975) ,...
                  quantile(Data.mu(MAXX:end,mm),0.025)],...
                 [0 0 1.1*max(hist_mu.Values) 1.1*max(hist_mu.Values)],'c');
        set(hh,'FaceAlpha',0.2,'EdgeColor','none')
        hold on
        histogram(Data.mu(MAXX:end,mm),logspace(log10(min(Data.mu(MAXX:end,mm))),...
                  log10(max(Data.mu(MAXX:end,mm))),100),...
                  'Normalization','pdf','FaceColor',[0    0.4470    0.7410]);
      
        ylim([0 1.3*max(hist_mu.Values)])
        xlim([0  max(Data.mu(MAXX:end,mm))])
        xlabel({'Molecular brightness';'(photons/s)'})
        if mm==1
           ylabel('Posterior')
        end
        set(gca,'XScale','log')
        legend([hist_mu,hh],'Posterior',...
                            '95% confidence interval',...
                            'Orientation','Horizontal','location','North','Box','off');

        
        subplot(2,length(Data.Wxyz(1,:)),length(Data.Wxyz(1,:))+mm)
        plot(1:1:MAXX,Data.mu(1:MAXX,mm),'color',[1    0    0])
        hold on
        plot(MAXX:1:str2num(handles.edit39.String)+1,Data.mu(MAXX:end,mm),'color',[0    0.4470    0.7410])
        xlabel('Iteration')
        if mm==1
           ylabel({'Molecular brightness';'(photons/s)'})
        end
        set(gca,'YScale','log')
   end
end

if handles.checkbox3.Value==1
figure(2)

maxx_size_signals=length(Data.Trace_partial);
      for k=1:maxx_size_signals
          subplot(2,maxx_size_signals,k)

          plot(1:1:MAXX,sum(Data.b(1:MAXX,(k-1)*str2num(handles.Number_particles.String)+1:k*...
                                                str2num(handles.Number_particles.String)),2),'color',[1 0 0])
          hold on
          plot(MAXX:1:str2num(handles.edit39.String)+1,sum(Data.b(MAXX:end,(k-1)*...
                      str2num(handles.Number_particles.String)+1:k*...
                      str2num(handles.Number_particles.String)),2),'color',[0 0 1])
          xlabel('Iteration')
          if k==1
             ylabel('Active molecules')
          end
          ylim([0 str2num(handles.Number_particles.String)])
          title(['Signal ',num2str(k)])
      
          subplot(2,maxx_size_signals,maxx_size_signals+k)
          histogram(sum(Data.b(MAXX:end,(k-1)*str2num(handles.Number_particles.String)+1:k*...
                                              str2num(handles.Number_particles.String)),2),'Normalization','pdf')
          xlim([0 str2num(handles.Number_particles.String)])
          xlabel('Active molecules')
          if k==1
             ylabel('Posterior')
          end
      end
end

if handles.checkbox4.Value==1
   figure(4)
   if  length(str2num(handles.Diff_synth.String))>0
       if  length(Data.Wxyz(1,:))==1
           Data.Data_type = 1 ;
           Plot_concentration( Data )
       else
           for k=1:length(Data.Trace_partial)
               HJ=histcounts(sum(Data.b(:,(k-1)*str2num(handles.Number_particles.String)+1:k*...
                                                str2num(handles.Number_particles.String)),2),'Normalization','pdf');
               max_num_active(k)=min(find(HJ==max(HJ)));
               for hh=1:str2num(handles.Number_particles.String)
                   molecules(k,hh)=sum(Data.b(:,(k-1)*str2num(handles.Number_particles.String)+hh));
               end
               [~,AB]=sort(molecules(k,:),'descend');
               Active_molecules=AB(1:max_num_active(k));
           end

           Plot_trajectories_multi_focuses(Data,1,Active_molecules)
       end
   else
       if  length(Data.Wxyz(1,:))==1
           
           Data.Data_type = 2 ;
           Plot_concentration( Data )
       else
           for k=1:length(Data.Trace_partial)
               HJ=histcounts(sum(Data.b(:,(k-1)*str2num(handles.Number_particles.String)+1:k*...
                                   str2num(handles.Number_particles.String)),2),'Normalization','pdf');
               max_num_active(k)=find(HJ==max(HJ));
               for hh=1:str2num(handles.Number_particles.String)
                   molecules(k,hh)=sum(Data.b(:,(k-1)*str2num(handles.Number_particles.String)+hh));
               end
               [~,AB]=sort(molecules(k,:),'descend');
               Active_molecules=AB(1:max_num_active(k));
           end
           Plot_trajectories_multi_focuses(Data,1,Active_molecules,str2num(handles.Number_particles.String))
       end
   end
end


if handles.checkbox8.Value==1
   figure(5)

   Results=[Data.D(MAXX:end)   ;   Data.mu(MAXX:end,:)'   ;   Data.mu_back(MAXX:end,:)']';
   numParams=size(Results,2);
      
   Titles={'D'};
   for  j=1:size(Data.Wxyz,2)
        Titles{1+j}=['\mu_{',num2str(j),',mol}'];
        Titles{size(Data.Wxyz,2)+1+j}=['\mu_{',num2str(j),',back}'];
   end
      
   for i=1:numParams
       for j=i:numParams
           subplot(numParams,numParams,numParams*(i-1)+i+(j-i));
           if i~=j
            
            histogram2(Results(:,i),Results(:,j),'Normalization','Probability');
            title([Titles{i},' , ',Titles{j}])
            ylabel(Titles{j})
            xlabel(Titles{i})
            zlabel('Join Posterior')
            hold on
           end
           if i==j
           histogram(Results(:,j),'Normalization','pdf')
           ylabel('Posterior')
           xlabel(Titles{i})
           box off
           hold on 
           end
       end
   end
end


   if handles.checkbox7.Value==1
       
   figure(6)
   for  mm=1:length(Data.Wxyz(1,:))
        subplot(2,length(Data.Wxyz(1,:)),mm)
        hist_mu_back=histogram(Data.mu_back(MAXX:end,mm),logspace(log10(min(Data.mu_back(MAXX:end,mm))),...
            log10(max(Data.mu_back(MAXX:end,mm))),100),...
          'Normalization','pdf','FaceColor',[0    0.4470    0.7410]);
      
        hh=patch([quantile(Data.mu_back(MAXX:end,mm),0.025) ,...
                  quantile(Data.mu_back(MAXX:end,mm),0.975) ,...
                  quantile(Data.mu_back(MAXX:end,mm),0.975) ,...
                  quantile(Data.mu_back(MAXX:end,mm),0.025)],...
                 [0 0 1.1*max(hist_mu_back.Values) 1.1*max(hist_mu_back.Values)],'c');
        set(hh,'FaceAlpha',0.2,'EdgeColor','none')
        hold on
        histogram(Data.mu_back(MAXX:end,mm),logspace(log10(min(Data.mu_back(MAXX:end,mm))),...
            log10(max(Data.mu_back(MAXX:end,mm))),100)...
          ,'Normalization','pdf','FaceColor',[0    0.4470    0.7410]);
      
        ylim([0 1.3*max(hist_mu_back.Values)])
        xlim([0  max(Data.mu_back(MAXX:end,mm))])
        xlabel({'Background photon';'emission rate';'(photons/s)'})
        if mm==1
           ylabel('Posterior')
        end
        set(gca,'XScale','log')
        legend([hist_mu_back,hh],'Posterior','95% confidence interval',...
            'Orientation','Horizontal','location','North','Box','off');

        subplot(2,length(Data.Wxyz(1,:)),length(Data.Wxyz(1,:))+mm)
        plot(1:1:MAXX,Data.mu_back(1:MAXX,mm),'color',[1    0    0])
        hold on
        plot(MAXX:1:str2num(handles.edit39.String)+1,Data.mu_back(MAXX:end,mm),...
                                   'color',[0    0.4470    0.7410])
        xlabel('Iteration')
        if mm==1
           ylabel({'Background photon';'emission rate';'(photons/s)'})
        end
        set(gca,'YScale','log')
   end
   end
   handles.checkbox7.Enable                     ='on';



    drawnow
    handles.edit44.Enable                        ='on';
    handles.checkbox1.Enable                     ='on';
    handles.checkbox2.Enable                     ='on';
    handles.checkbox3.Enable                     ='on';
    handles.checkbox4.Enable                     ='on';
    handles.checkbox8.Enable                     ='on';




% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



    
    handles.D_alpha_prior.Enable           ='off';
    handles.D_beta_prior.Enable            ='off';
    handles.mu_alpha.Enable                ='off';
    handles.mu_beta.Enable                 ='off';
    handles.Number_particles.Enable        ='off';
    handles.alpha_load.Enable              ='off';
    handles.concen_radious.Enable          ='off';
    handles.mu_prior_xy.Enable             ='off';
    handles.mu_prior_z.Enable              ='off';
    handles.var_prior_xy.Enable            ='off';
    handles.var_prior_z.Enable             ='off';
    handles.pushbutton11.Enable            ='off';
    handles.pushbutton16.Enable            ='off';
    handles.pushbutton22.Enable            ='off';
    handles.pushbutton17.Enable            ='off';
    handles.pushbutton23.Enable            ='off';
    handles.pushbutton20.Enable            ='off';
    handles.pushbutton8.Enable             ='off';
    handles.checkbox1.Enable               ='off';
    handles.checkbox2.Enable               ='off';
    handles.checkbox3.Enable               ='off';
    handles.checkbox4.Enable               ='off';
    handles.checkbox7.Enable               ='off';
    handles.checkbox8.Enable               ='off';
    handles.edit44.Enable                  ='off';
    handles.edit52.Enable                  ='off';
    handles.edit39.Enable                  ='off';
    handles.edit40.Enable                  ='off';
    handles.edit41.Enable                  ='off';
    handles.edit46.Enable                  ='off';
    handles.edit47.Enable                  ='off';
    handles.edit48.Enable                  ='off';
    handles.edit53.Enable                  ='off';
    
    
    cla(handles.axes7)
    cla(handles.axes8)
    cla(handles.axes15)
    cla(handles.axes16)
    cla(handles.axes18)
    cla(handles.axes19)
    cla(handles.axes20)
    cla(handles.axes26)
    cla(handles.axes27)
    cla(handles.axes28)
    cla(handles.axes31)
    cla(handles.axes32)
    cla(handles.axes33)
    
    
    minn = str2num(get(handles.edit35,'String')) ;
    maxx = str2num(get(handles.edit36,'String')) ;
   
    load('results.mat');
    
    
    signal=Data.Trace(1,:);
    
    while isempty(maxx-minn) || maxx-minn<=0 || maxx<=0 || minn<=0 || maxx>length(signal)

              opts.Interpreter = 'tex';
              answer = inputdlg({'Minimum Time step','Maximum Time step'},...
                       'Please choose some reasonable vlues!',[1 60;1 60],...
                       {'1',num2str(length(signal))},opts);
                   
              minn = str2num(answer{1}) ;
              maxx = str2num(answer{2}) ;
    end
    
    handles.edit35.String  = num2str(minn);
    handles.edit36.String  = num2str(maxx);
    
    signal_partial = Data.Trace(1,minn:maxx);
    
    if  Data.Model_type==1
        plot(handles.axes7,repelem(cumsum(signal_partial),1,3) , repmat([0 1 0],1,length(signal_partial)))
        hold (handles.axes7,'off')
        handles.axes7.YTick = [];
        
        
        ylim(handles.axes7,[0 1.1])
        xlim(handles.axes7,[min(cumsum(signal_partial)) max(cumsum(signal_partial))])
        
        
        if  length(Data.Wxyz(1,:))>1
            if sum(handles.axes33.Visible)==sum('off')
               set(handles.axes33,'Visible','on')
               handles.axes7.Position=handles.axes7.Position.*[1 1/(0.75) 1 1/(1.7)];
            end
            
            plot(handles.axes33,cumsum(Data.Trace(1,minn:maxx)) ,Data.Trace(2,minn:maxx) ,'.')
            xlim(handles.axes33,[min(cumsum(signal_partial)) max(cumsum(signal_partial))])
            xlabel(handles.axes33,'Time (s)')
            ylabel(handles.axes33,'Detector')
            ylim(handles.axes33,[0.8 length(Data.Wxyz(1,:))+0.2])
            
            ylabel(handles.axes7,{'Detected','photons'})
            set(handles.axes7,'XTick',[],'YTick',[])
        else
            if sum(handles.axes33.Visible)==sum('on')
               handles.axes7.Position=handles.axes7.Position.*[1 0.75 1 1.7];
            end
            set(handles.axes33,'Visible','off')
            xlabel(handles.axes7,'Time (s)')
            ylabel(handles.axes7,'Detected photons')
        end
        
    else
        if sum(handles.axes33.Visible)==sum('on')
           handles.axes7.Position=handles.axes7.Position.*[1 0.75 1 1.7];
        end
        set(handles.axes33,'Visible','off')
        
        plot(handles.axes7,minn:1:maxx,signal_partial)
        hold (handles.axes7,'off')
        handles.axes7.YTick = [];
        
        xlabel(handles.axes7,['Time step (\Deltat =', num2str(str2num(handles.Delta_t.String)), 's)'])
        ylabel(handles.axes7,'Detected photons')
        xlim(handles.axes7,[minn maxx])
    end


    if length(handles.uitable5.Data)>0
       handles.pushbutton28.Enable             ='on' ;
    else
        handles.pushbutton28.Enable            ='off';
        handles.pushbutton30.Enable            ='off';
        handles.pushbutton31.Enable            ='off';
    end
    
    handles.pushbutton29.Enable            ='on';
    handles.edit53.Enable                  ='on';
    
    handles.text36.Enable                  ='on';
    handles.text37.Enable                  ='on';
    
    
    
    Data.Automatic = 0;
    handles.pushbutton23.String = 'Automatic (OFF)';
    handles.pushbutton23.Enable = 'off';
    save('results','Data','-v7.3','-nocompression')
    
    
    
    
    
% --- Executes on button press in Import_signal.
function Import_signal_Callback(hObject, eventdata, handles)
% hObject    handle to Import_signal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    handles.D_alpha_prior.Enable           ='off';
    handles.D_beta_prior.Enable            ='off';
    handles.mu_alpha.Enable                ='off';
    handles.mu_beta.Enable                 ='off';
    handles.Number_particles.Enable        ='off';
    handles.alpha_load.Enable              ='off';
    handles.concen_radious.Enable          ='off';
    handles.mu_prior_xy.Enable             ='off';
    handles.mu_prior_z.Enable              ='off';
    handles.var_prior_xy.Enable            ='off';
    handles.var_prior_z.Enable             ='off';
    
    handles.pushbutton8.Enable             ='off';
    handles.pushbutton10.Enable            ='off';
    handles.pushbutton11.Enable            ='off';
    handles.pushbutton16.Enable            ='off';
    handles.pushbutton17.Enable            ='off';
    handles.pushbutton22.Enable            ='off';
    handles.pushbutton23.Enable            ='off';
    handles.pushbutton28.Enable            ='off';
    handles.pushbutton20.Enable            ='off';
    handles.pushbutton29.Enable            ='off';
    handles.pushbutton30.Enable            ='off';
    handles.pushbutton31.Enable            ='off';
    handles.pushbutton32.Enable            ='off';
    handles.pushbutton33.Enable            ='off';
    
    handles.edit35.Enable                  ='off';
    handles.edit36.Enable                  ='off';
    handles.edit39.Enable                  ='off';
    handles.edit40.Enable                  ='off';
    handles.edit41.Enable                  ='off';
    handles.edit46.Enable                  ='off';
    handles.edit44.Enable                  ='off';
    handles.edit47.Enable                  ='off';
    handles.edit48.Enable                  ='off';
    handles.edit52.Enable                  ='off';
    handles.edit53.Enable                  ='off';
    
    handles.checkbox1.Enable               ='off';
    handles.checkbox2.Enable               ='off';
    handles.checkbox3.Enable               ='off';
    handles.checkbox4.Enable               ='off';
    handles.checkbox7.Enable               ='off';
    handles.checkbox8.Enable               ='off';
    handles.checkbox9.Enable               ='off';
    
    cla(handles.Original_signal)
    cla(handles.axes7)
    cla(handles.axes8)
    cla(handles.axes15)
    cla(handles.axes16)
    cla(handles.axes18)
    cla(handles.axes19)
    cla(handles.axes20)
    cla(handles.axes26)
    cla(handles.axes27)
    cla(handles.axes28)
    cla(handles.axes31)
    cla(handles.axes32)
    
    handles.uitable5.Data                         =  [] ;
    
    handles.Import_signal.Enable                  ='off';
    handles.Generate_Synthetic_signal.Enable      ='off';
    handles.Measure_Background.Enable             ='off';

    
    
    
    choice = questdlg({'Do you want to import a single photon arrival time trace?'},...
                       'Sample analysis','Yes','No','Yes');
    
    if  strcmp(choice,'Yes')
        Data.Model_type=1;
  
        handles.Delta_t.String='Inter-arrival';
        
        opts.Interpreter = 'tex';
        answer = inputdlg({'How many confocal volume do you have?'},...
                           'Parameters',[1 60],{'1'},opts);
  
        while isempty(str2num(answer{1})) || str2num(answer{1})==0
              opts.Interpreter = 'tex';
              answer = inputdlg({'How many confocal volumes do you have?'},...
                                 'Parameters',[1 60],{'1'},opts);
        end
        
        if   str2num(answer{1})>1
             Data.single_confocal = false;
        else
             Data.single_confocal = true;
        end
        
        
        Number_confocals=str2num(answer{1});
        Data.Wxyz=[];
        Data.Cxyz=[];
        AS_1=[];
        
        handles.wx.String='';
        handles.wy.String='';
        handles.wz.String='';
        
        handles.edit65.String = '';
        handles.edit66.String = '';
        handles.edit67.String = '';
        
        handles.edit51.String = '';
        
        for conf=1:Number_confocals
            opts.Interpreter = 'tex';
            answer={};
            answer = inputdlg({['Center of the confocal volume',num2str(conf),'in x axis (\mum)'],...
                               ['Center of the confocal volume',num2str(conf),'in y axis (\mum)'],...
                               ['Center of the confocal volume',num2str(conf),'in z axis (\mum)'],...
                               ['Confocal',num2str(conf),'radius in x axis (\mum)'],...
                               ['Confocal',num2str(conf),'radius in y axis (\mum)'],...
                               ['Confocal',num2str(conf),'radius in z axis (\mum)']},...
                                'Parameters',[1 60;1 60;1 60;1 60;1 60;1 60],...
                                              {'0','0','0','0.3','0.3','3.5'},opts);
  
            while isempty(str2num(answer{1})) ||...
                  isempty(str2num(answer{2})) ||...
                  isempty(str2num(answer{3})) ||...
                  isempty(str2num(answer{4})) || str2num(answer{4})<=0 ||...
                  isempty(str2num(answer{5})) || str2num(answer{5})<=0 ||...
                  isempty(str2num(answer{6})) || str2num(answer{6})<=0 
                  
                  opts.Interpreter = 'tex';
                  answer = inputdlg({['Center of the confocal volume',num2str(conf),'in x axis (\mum)'],...
                                     ['Center of the confocal volume',num2str(conf),'in y axis (\mum)'],...
                                     ['Center of the confocal volume',num2str(conf),'in z axis (\mum)'],...
                                     ['Confocal',num2str(conf),'radius in x axis (\mum)'],...
                                     ['Confocal',num2str(conf),'radius in y axis (\mum)'],...
                                     ['Confocal',num2str(conf),'radius in z axis (\mum)']},...
                                      'Parameters',[1 60;1 60;1 60;1 60;1 60;1 60],...
                                                   {'0','0','0','0.3','0.3','3.5'},opts);
            end
            
            Data.Cxyz =[Data.Cxyz, [ str2num(answer{1}) ; str2num(answer{2}) ; str2num(answer{3}) ]];
            
            choice    = questdlg('Please choose the Point Spread Function of interest:',...
                                 'Point Spread Function','Gaussian','Lorentzian','Cylindrical','');
    
            if     strcmp(choice,'Gaussian')
                   Data.Wxyz =[Data.Wxyz, [ str2num(answer{4}) ; str2num(answer{5}) ; str2num(answer{6}) ]];
                   if  conf==1
                       handles.edit51.String = '3DG';
                   else
                       handles.edit51.String = [handles.edit51.String,', 3DG'] ;
                   end
                   Data.PSF_func(conf) = 1 ;
           
            elseif strcmp(choice,'Lorentzian')
                   Data.Wxyz =[Data.Wxyz, [ str2num(answer{4}) ; str2num(answer{5}) ; str2num(answer{6}) ]];
                   if  conf==1
                       handles.edit51.String = '2DGL' ;
                   else
                       handles.edit51.String = [handles.edit51.String,', 2DGL'] ;
                   end
                   Data.PSF_func(conf) = 2 ;
           
            elseif strcmp(choice,'Cylindrical')
                   Data.Wxyz = [Data.Wxyz,[ str2num(answer{4}) ; str2num(answer{5}) ; 1000]];
                   if  conf==1
                       handles.edit51.String = '2DGC' ;
                   else
                       handles.edit51.String = [handles.edit51.String,', 2DGC'] ;
                   end
                   Data.PSF_func(conf) = 3 ;
            else
                   handles.edit51.String = 'NAN' ;
                   handles.Import_signal.Enable                  ='on';
                   handles.Generate_Synthetic_signal.Enable      ='on';
                   handles.Measure_Background.Enable             ='on';
            end
            
            if conf==1
                handles.wx.String     = [handles.wx.String , answer{4}];
                handles.wy.String     = [handles.wy.String , answer{5}];
                handles.wz.String     = [handles.wz.String , answer{6}];
            
                handles.edit65.String = [handles.edit65.String , answer{1}];
                handles.edit66.String = [handles.edit66.String , answer{2}];
                handles.edit67.String = [handles.edit67.String , answer{3}];
            else
                handles.wx.String     = [handles.wx.String,',', answer{4}];
                handles.wy.String     = [handles.wy.String,',', answer{5}];
                handles.wz.String     = [handles.wz.String,',', answer{6}];
        
                handles.edit65.String = [handles.edit65.String ,',', answer{1}];
                handles.edit66.String = [handles.edit66.String ,',', answer{2}];
                handles.edit67.String = [handles.edit67.String ,',', answer{3}];
            end
             % Find the file from the directory
             [filename, pathname] = uigetfile( { '*.txt','Text-files (*.txt)';...
                                                 '*.mat','MAT-files (*.mat)' }, ...
                                                 'Import a time series', ...
                                                 'MultiSelect', 'off');
             % Check the filename                             
             if  ~isequal(filename,0)
                 ans_11=load(filename,pathname);
                 if length(ans_11(:,1))>length(ans_11(1,:))
                     ans_11=ans_11';
                 end
                 Trace_singel_photon{conf} = ans_11;
                 AS_1=[AS_1,Trace_singel_photon{conf}];
             end
        end

        AS_2=sort(AS_1);
        Data.Trace(1,:)=diff(AS_2);
        if length(find(Data.Trace(1,:)==0))>0
            keyboard
            % the imported trace has a same time for at least two detected
            % photons. Please rerun the GUI and import the corrected trace.
        end
        for conf=1:Number_confocals
            Data.Trace(2,find(AS_2==Trace_singel_photon{conf})) = conf;
        end

       
        % plot data
        plot(handles.Original_signal,repelem(AS_2,1,3),repmat([0 1 0],1,length(AS_2)))
        xlabel(handles.Original_signal,'Time (s)')
        ylabel(handles.Original_signal,'Detected photons')
        handles.Original_signal.YTick = [];

        % Precalculation of the PSFs and their gradiant
        [Data] = PSF_calculation(Data);
        
        % Save the imported trace
        save('results','Data','-v7.3','-nocompression')
  
        
    else
        Data.Model_type=2;
        opts.Interpreter = 'tex';
        answer = inputdlg({'Bin Size(s)'});
  
        while isempty(str2num(answer{1})) || str2num(answer{1})==0
              opts.Interpreter = 'tex';
              answer = inputdlg({'Bin Size(s)'});
        end
        Delta_t = str2num(answer{1});
        handles.Delta_t.String=answer{1};
        
        choice    = questdlg('Please choose the Point Spread Function of interest:',...
                             'Point Spread Function','Gaussian','Lorentzian','Cylindrical','');
    
        if     strcmp(choice,'Gaussian')
               handles.edit51.String = '3DG' ;
               Data.PSF_func = 1 ;
        elseif strcmp(choice,'Lorentzian')
               handles.edit51.String = '2DGL' ;
               Data.PSF_func = 2 ;
        elseif strcmp(choice,'Cylindrical')
               handles.edit51.String = '2DGC' ;
               Data.PSF_func = 3 ;
        else
               handles.edit51.String = 'NAN' ;
               handles.Import_signal.Enable                  ='on';
               handles.Generate_Synthetic_signal.Enable      ='on';
               handles.Measure_Background.Enable             ='on';
        end
            
        opts.Interpreter = 'tex';
        answer={};
        answer = inputdlg({['Confocal',num2str(conf),'radius in x axis (\mum)'],...
                           ['Confocal',num2str(conf),'radius in y axis (\mum)'],...
                           ['Confocal',num2str(conf),'radius in z axis (\mum)']},...
                            'Parameters',[1 60;1 60;1 60],...
                                           {'0.3','0.3','3.5'},opts);
  
        while isempty(str2num(answer{1})) || str2num(answer{1})<=0 ||...
              isempty(str2num(answer{2})) || str2num(answer{2})<=0 ||...
              isempty(str2num(answer{3})) || str2num(answer{3})<=0 
                  
              opts.Interpreter = 'tex';
              answer = inputdlg({['Confocal',num2str(conf),'radius in x axis (\mum)'],...
                                 ['Confocal',num2str(conf),'radius in y axis (\mum)'],...
                                 ['Confocal',num2str(conf),'radius in z axis (\mum)']},...
                                  'Parameters',[1 60;1 60;1 60],...
                                                   {'0.3','0.3','3.5'},opts);
        end
        Data.Cxyz =[ 0                 ; 0                  ; 0                 ];
        Data.Wxyz =[ str2num(answer{1}); str2num(answer{2}) ; str2num(answer{3})];
        
        handles.wx.String     = answer{1};
        handles.wy.String     = answer{2};
        handles.wz.String     = answer{3};
        
        handles.edit65.String = '0';
        handles.edit66.String = '0';
        handles.edit67.String = '0';
        
        [filename, pathname] = uigetfile( { '*.txt','Text-files (*.txt)'  ;...
                                                '*.mat','MAT-files (*.mat)' } , ...
                                                'Import a time series'        , ...
                                                'MultiSelect'                 , 'off');
            
        if ~isequal(filename,0)
            AS_1=load(filename,pathname);
            if  length(AS_1(:,1))>length(AS_1(1,:))
                AS_1=AS_1';
            end
            Data.Trace(1,:) = AS_1;
    
            % plot data
            plot(handles.Original_signal,1:length(Trace_uniform_bin),Data.Trace)
            xlabel(handles.Original_signal,['Time step (\Deltat=' num2str(Delta_t) 's)'])
            ylabel(handles.Original_signal,'Detected photons')
            
            % Save the imported trace
            save('results','Data','-v7.3','-nocompression');
 
        end
    end

    
    
    % Set the handles
    handles.pushbutton10.Enable                   ='on';
    handles.edit53.Enable                         ='on';
           
    handles.edit35.String                         ='0' ;
    handles.edit36.String                         ='0' ;
            
    handles.edit35.Enable                         ='on';
    handles.edit36.Enable                         ='on';
   
    handles.Import_signal.Enable                  ='on';
    handles.Generate_Synthetic_signal.Enable      ='on';
    handles.Measure_Background.Enable             ='on';
    handles.pushbutton32.Enable                   ='on';
    handles.pushbutton33.Enable                   ='on';
  
    
    
    
    
    handles.Import_signal.Enable                  ='on';
    handles.Generate_Synthetic_signal.Enable      ='on';
    handles.Measure_Background.Enable             ='on';
    handles.pushbutton32.Enable                   ='on';
    handles.pushbutton33.Enable                   ='on';
 
    
    

    
        
        
        




    
    
% --- Executes on button press in Generate_Synthetic_signal.
function Generate_Synthetic_signal_Callback(hObject, eventdata, handles)
% hObject    handle to Generate_Synthetic_signal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
    S = dir('*.mat');                   % Collect directories
    N = {S.name};                       % Collect Names of the text files
    for i=1:length(N)                   % A For loop for read data
        delete(N{i});           % Import data from the file
    end
    clear('S','N')
    
    handles.Import_signal.Enable                ='off';
    handles.Generate_Synthetic_signal.Enable    ='off';
    handles.Measure_Background.Enable           ='off';

     
    handles.uitable5.Data                       =   [];
       
    handles.edit35.Enable                       ='off';
    handles.edit36.Enable                       ='off';
    handles.edit39.Enable                       ='off';
    handles.edit40.Enable                       ='off';
    handles.edit41.Enable                       ='off';
    handles.edit44.Enable                       ='off';
    handles.edit46.Enable                       ='off';
    handles.edit47.Enable                       ='off';
    handles.edit48.Enable                       ='off';
    handles.edit52.Enable                       ='off';
    handles.edit53.Enable                       ='off';
    
    handles.concen_radious.Enable               ='off';
    handles.D_alpha_prior.Enable                ='off';
    handles.D_beta_prior.Enable                 ='off'; 
    handles.mu_alpha.Enable                     ='off';
    handles.mu_beta.Enable                      ='off'; 
    handles.Number_particles.Enable             ='off'; 
    handles.alpha_load.Enable                   ='off';
    handles.mu_prior_xy.Enable                  ='off';
    handles.mu_prior_z.Enable                   ='off';
    handles.var_prior_xy.Enable                 ='off';
    handles.var_prior_z.Enable                  ='off';
    
    handles.pushbutton8.Enable                  ='off'; 
    handles.pushbutton10.Enable                 ='off';
    handles.pushbutton11.Enable                 ='off';
    handles.pushbutton16.Enable                 ='off';
    handles.pushbutton17.Enable                 ='off';
    handles.pushbutton19.Enable                 ='off';
    handles.pushbutton20.Enable                 ='off';
    handles.pushbutton21.Enable                 ='off';
    handles.pushbutton22.Enable                 ='off';
    handles.pushbutton23.Enable                 ='off';
    handles.pushbutton24.Enable                 ='off';
    handles.pushbutton25.Enable                 ='off';
    handles.pushbutton26.Enable                 ='off';
    handles.pushbutton28.Enable                 ='off';
    handles.pushbutton29.Enable                 ='off';
    handles.pushbutton30.Enable                 ='off';
    handles.pushbutton31.Enable                 ='off';
    handles.pushbutton32.Enable                 ='off';
    handles.pushbutton33.Enable                 ='off';
    
    handles.edit44.Enable                       ='off';
    handles.checkbox1.Enable                    ='off';
    handles.checkbox2.Enable                    ='off';
    handles.checkbox3.Enable                    ='off';
    handles.checkbox4.Enable                    ='off';
    handles.checkbox7.Enable                    ='off';
    handles.checkbox8.Enable                    ='off';

    cla(handles.Original_signal)
    cla(handles.axes7)
    cla(handles.axes8)
    cla(handles.axes15)
    cla(handles.axes16)
    cla(handles.axes18)
    cla(handles.axes19)
    cla(handles.axes20)
    cla(handles.axes26)
    cla(handles.axes27)
    cla(handles.axes28)
    cla(handles.axes31)
    cla(handles.axes32)
    cla(handles.axes33)
    
    choice1 = questdlg('Please choose the trace type','Trace type','inter-arrival times','Binned','');

    
    if     strcmp(choice1,'inter-arrival times')
           Data.Model_type=1;
           
           handles.uitable5.ColumnName{1} = 'First photon';
           handles.uitable5.ColumnName{2} = 'Last photon';
           
           choice2 = questdlg('Please identify the experimental setup',...
                              'single or multi-focuses confocal volumes',...
                              'Single_focus','Multi-Focuses','');
    
           if strcmp(choice2,'Single_focus')
                 
              answer={};

              opts.Interpreter = 'tex';
              answer = inputdlg({'Total number of photons',...
                                 'Confocal radius in x axis (\mum)',...
                                 'Confocal radius in y axis (\mum)',...
                                 'Confocal radius in z axis (\mum)',...
                                 'Diffusion coefficent (\mum^2/s)',...
                                 'Background photon emission rate (photons/s)',...
                                 'Molecular brightness (photons/s)',...
                                 'Radius of the periodic boundary in x axis (\mum)',...
                                 'Radius of the periodic boundary in y axis (\mum)',...
                                 'Radius of the periodic boundary in z axis (\mum)',...
                                 'Number of molecules'},...
                                 'Parameters',...
                                 [1 60;1 60; 1 60; 1 60; 1 60; 1 60; 1 60; 1 60; 1 60; 1 60; 1 60],...
                                 {'1000','0.3','0.3','3.5','10','1000','50000','2','2','5','30'},opts);
               
              if length(answer)==11
                  while isempty(str2num(answer{1})) || str2num(answer{1})<=0 ||...
                        isempty(str2num(answer{2})) || str2num(answer{2})<=0 ||...
                        isempty(str2num(answer{3})) || str2num(answer{3})<=0 ||...
                        isempty(str2num(answer{4})) || str2num(answer{4})<=0 ||...
                        isempty(str2num(answer{5})) || str2num(answer{5})<=0 ||...
                        isempty(str2num(answer{6})) || str2num(answer{6})<=0 ||...
                        isempty(str2num(answer{7})) || str2num(answer{7})<=0 ||...
                        isempty(str2num(answer{8})) || str2num(answer{8})<=0 ||...
                        isempty(str2num(answer{9})) || str2num(answer{9})<=0 ||...
                        isempty(str2num(answer{10}))|| str2num(answer{10})<=0||...
                        isempty(str2num(answer{11}))|| str2num(answer{11})<=0
          
                        opts.Interpreter = 'tex';
                        answer = inputdlg({'Total number of photons',...
                                           'Confocal radius in x axis (\mum)',...
                                           'Confocal radius in y axis (\mum)',...
                                           'Confocal radius in z axis (\mum)',...
                                           'Diffusion coefficent (\mum^2/s)',...
                                           'Background photon emission rate(photons/s)',...
                                           'Molecular brightness (photons/s)',...
                                           'Radius of the periodic boundary in x axis (\mum)',...
                                           'Radius of the periodic boundary in y axis (\mum)',...
                                           'Radius of the periodic boundary in z axis (\mum)',...
                                           'Number of molecules'},...
                                           'Parameters',...
                                           [1 60;1 60; 1 60; 1 60; 1 60; 1 60; 1 60; 1 60; 1 60; 1 60; 1 60],...
                                           {'1000','0.3','3.5','10','1000','50000','2','2','5','30'},opts);
                  end

   
                  choice = questdlg('Please choose the Point Spread Function of interest:',...
                                    'Point Spread Function','Gaussian','Lorentzian','Cylindrical','');
    
                  if     strcmp(choice,'Gaussian')
                      
                         Data.Wxyz = [ str2num(answer{2}) ; str2num(answer{3}) ; str2num(answer{4}) ];
                         handles.edit51.String = '3DG' ;
                         Data.PSF_func = 1 ;
           
                  elseif strcmp(choice,'Lorentzian')
                      
                         Data.Wxyz = [ str2num(answer{2}) ; str2num(answer{3}) ; str2num(answer{4}) ];
                         handles.edit51.String = '2DGL' ;
                         Data.PSF_func = 2 ;
           
                  elseif strcmp(choice,'Cylindrical')
        
                         Data.Wxyz = [ str2num(answer{2}) ; str2num(answer{3}) ; 100];
                         handles.edit51.String = '2DGC' ;
                         Data.PSF_func = 3 ;
                  else
                         handles.edit51.String = 'NAN' ;
                         handles.Import_signal.Enable                  ='on';
                         handles.Generate_Synthetic_signal.Enable      ='on';
                         handles.Measure_Background.Enable             ='on';
                  end
    
                  handles.edit65.String     = 0; 
                  handles.edit66.String     = 0;
                  handles.edit67.String     = 0;
                  handles.wx.String         = answer{2};
                  handles.wy.String         = answer{3};
                  handles.wz.String         = answer{4};
                  handles.Diff_synth.String = answer{5};
                  handles.mu_back.String    = answer{6};
                  handles.mu_synth.String   = answer{7};
                  handles.Delta_t.String    ='Inter-arrival';
               
                  if  strcmp(choice,'') 
                      text(handles.Original_signal,0.4 ,0.5 ,'No point spread function is selected!')
                  else
                      Data.Lxyz = [ str2num(answer{8}) , str2num(answer{9}) , str2num(answer{10})];
                      Data.Cxyz = [ 0                  ; 0                  ; 0                  ];
                      
                      Data.Length_signal         = str2num(answer{1})  ;
                      Data.mu_real               = str2num(answer{7})  ;
                      Data.mu_back_real          = str2num(answer{6})  ;
                      Data.D_real                = str2num(answer{5})  ;
                      Data.Number_molecules_real = str2num(answer{11}) ;
                      
   
                      Data.single_confocal = true;
                      % Precalculation of the PSFs and their gradiant
                      [Data] = PSF_calculation(Data);
                      
                      % sample from the generator function, you should direct it to the same folder
                      [ Data ] = Generative_model_inter_arrival( Data , handles , 1 );
                  
                      if  length(Data.Trace(1,:))<1   
                          text(handles.Original_signal,0.4 ,0.5 ,...
                               {'No Photon is detected';'Please redo the generation with lorger time steps'})
                      else
                          handles.pushbutton10.Enable            ='on';
                          handles.edit53.Enable                  ='on';
                          handles.edit35.Enable                  ='on';
                          handles.edit36.Enable                  ='on';
                          
                          handles.edit35.String                  ='0';
                          handles.edit36.String                  ='0';
   

                          save('results','Data','-v7.3','-nocompression')

                          % set(handles.Plot_signal,signal)
                          plot(handles.Original_signal,repelem(cumsum(Data.Trace(1,:)),1,3),...
                               repmat([0 1 0],1,length(Data.Trace(1,:))))
                          xlabel(handles.Original_signal,'Time (s)')
                          ylabel(handles.Original_signal,'Detected photons')
                          ylim(handles.Original_signal,[0 1.1])
                          handles.Original_signal.YTick = [];
                          xlim(handles.Original_signal,[0 max(cumsum(Data.Trace(1,:)))])
                      end

                      handles.pushbutton19.Enable                   ='on';
                  end
              end
                  
                  
                  
           elseif strcmp(choice2,'Multi-Focuses')
                   
                  answer={};

                  opts.Interpreter = 'tex';
                  answer = inputdlg({'Total number of photons',...
                                     'Confocals radii in x axis (\mum)',...
                                     'Confocals radii in y axis (\mum)',...
                                     'Confocals radii in z axis (\mum)',...
                                     'Confocals centers in x axis (\mum)',...
                                     'Confocals centers in y axis (\mum)',...
                                     'Confocals centers in z axis (\mum)',...
                                     'Diffusion coefficent (\mum^2/s)',...
                                     'Background photon emission rate (photons/s)',...
                                     'Molecular brightness (photons/s)',...
                                     'Radius of the periodic boundary in x axis (\mum)',...
                                     'Radius of the periodic boundary in y axis (\mum)',...
                                     'Radius of the periodic boundary in z axis (\mum)',...
                                     'Number of molecules'},...
                                     'Parameters',...
                                     [1 60; 1 60; 1 60; 1 60; 1 60; 1 60; 1 60;...
                                      1 60; 1 60; 1 60; 1 60; 1 60; 1 60; 1 60],...
                                     {'1000',...
                                      '0.3 , 0.3 , 0.3 , 0.3', ...
                                      '0.3 , 0.3 , 0.3 , 0.3', ...
                                      '3.5 , 3.5 , 3.5 , 3.5', ...
                                      '0.2 ,-0.2 , 0.0 , 0.0', ...
                                      '0.0 , 0.0 , 0.2 ,-0.2', ...
                                      '0.5 , 0.5 ,-0.5 ,-0.5', ...
                                      '10',...
                                      '1000,1000,1000,1000',...
                                      '50000,50000,50000,50000',...
                                      '2','2','5','30'},opts);
               
                  if length(answer)==14
                  while isempty(str2num(answer{1})) || str2num(answer{1})<=0 ||...
                        isempty(sum(str2num(answer{2}))) || sum(str2num(answer{2}))<=0 ||...
                        isempty(sum(str2num(answer{3}))) || sum(str2num(answer{3}))<=0 ||...
                        isempty(sum(str2num(answer{4}))) || sum(str2num(answer{4}))<=0 ||...
                        isempty(sum(str2num(answer{5}))) || ...
                        isempty(sum(str2num(answer{6}))) || ...
                        isempty(sum(str2num(answer{7}))) || ...
                        isempty(str2num(answer{8})) || str2num(answer{8})<=0 ||...
                        isempty(sum(str2num(answer{9}))) || sum(str2num(answer{9}))<=0 ||...
                        isempty(sum(str2num(answer{10})))|| sum(str2num(answer{10}))<=0||...
                        isempty(str2num(answer{11}))|| str2num(answer{11})<=0||...
                        isempty(str2num(answer{12}))|| str2num(answer{12})<=0||...
                        isempty(str2num(answer{13}))|| str2num(answer{13})<=0||...
                        isempty(str2num(answer{14}))|| str2num(answer{14})<=0
          
                        opts.Interpreter = 'tex';
                        answer = inputdlg({'Total number of photons',...
                                     'Confocals radii in x axis (\mum)',...
                                     'Confocals radii in y axis (\mum)',...
                                     'Confocals radii in z axis (\mum)',...
                                     'Confocals centers in x axis (\mum)',...
                                     'Confocals centers in y axis (\mum)',...
                                     'Confocals centers in z axis (\mum)',...
                                     'Diffusion coefficent (\mum^2/s)',...
                                     'Background photon emission rate (photons/s)',...
                                     'Molecular brightness (photons/s)',...
                                     'Radius of the periodic boundary in x axis (\mum)',...
                                     'Radius of the periodic boundary in y axis (\mum)',...
                                     'Radius of the periodic boundary in z axis (\mum)',...
                                     'Number of molecules'},...
                                     'Parameters',...
                                     [1 60; 1 60; 1 60; 1 60; 1 60; 1 60; 1 60;...
                                      1 60; 1 60; 1 60; 1 60; 1 60; 1 60; 1 60],...
                                     {'1000',...
                                      '0.3 ,  0.3 ,  0.3 , 0.3', ...
                                      '0.3 ,  0.3 ,  0.3 , 0.3', ...
                                      '3.5 ,  3.5 ,  3.5 , 3.5', ...
                                      '0.2 , -0.2 ,  0.0 , 0.0', ...
                                      '0.0 ,  0.0 ,  0.2 ,-0.2', ...
                                      '0.5 ,  0.5 , -0.5 ,-0.5', ...
                                      '10',...
                                      '1000 , 1000 , 1000 , 1000',...
                                      '50000 , 50000 , 50000 , 50000 ',...
                                      '2','2','5','30'},opts);
                  end
                  
                  handles.edit51.String='';
                  for mn=1:length(str2num(answer{2}))
                      choice = questdlg(['Please choose the Point Spread Functions of interest (',num2str(mn),'):'],...
                                         'Point Spread Function','Gaussian','Lorentzian','Cylindrical','');
                      
                      if     strcmp(choice,'Gaussian')
                             handles.edit51.String = [handles.edit51.String,'3DG,'] ;
                             Data.PSF_func(mn) = 1 ;
           
                      elseif strcmp(choice,'Lorentzian')
        
                             handles.edit51.String = [handles.edit51.String , '2DGL,'] ;
                             Data.PSF_func(mn) = 2 ;
           
                      elseif strcmp(choice,'Cylindrical')
        
                             handles.edit51.String = [ handles.edit51.String, '2DGC,'] ;
                             Data.PSF_func(mn)   = 3 ;
                      else
                             handles.edit51.String = 'NAN' ;
                             handles.Import_signal.Enable                  ='on';
                             handles.Generate_Synthetic_signal.Enable      ='on';
                             handles.Measure_Background.Enable             ='on';
                             break;
                      end
                  end
                  
    

                  handles.wx.String         = answer{2};
                  handles.wy.String         = answer{3};
                  handles.wz.String         = answer{4};
                  handles.edit65.String     = answer{5}; 
                  handles.edit66.String     = answer{6};
                  handles.edit67.String     = answer{7};
                  handles.Diff_synth.String = answer{8};
                  handles.mu_back.String    = answer{9};
                  handles.mu_synth.String   = answer{10};
                  handles.Delta_t.String    ='Inter-arrival';
               
                  if  strcmp(choice,'') 
                      text(handles.Original_signal,0.4 ,0.5 ,'No point spread function is selected!')
                  else
                  
                      Data.Length_signal         = str2num(answer{1})  ;
                      
                      Data.Lxyz = [ str2num(answer{11}) , str2num(answer{12}) , str2num(answer{13})];
                      Data.Wxyz = [ str2num(answer{2})  ; str2num(answer{3})  ; str2num(answer{4}) ];
                      Data.Cxyz = [ str2num(answer{5})  ; str2num(answer{6})  ; str2num(answer{7}) ];
                      
                      Data.mu_real               = str2num(answer{10}) ;
                      Data.mu_back_real          = str2num(answer{9})  ;
                      Data.D_real                = str2num(answer{8})  ;
                      Data.Number_molecules_real = str2num(answer{14}) ;
                      
                       % Precalculation of the PSFs and their gradiant
                      Data.single_confocal = false;
                      [Data] = PSF_calculation(Data);
                      
                      % sample from the generator function, you should direct it to the same folder
                      [ Data ] = Generative_model_inter_arrival( Data , handles  , 1    );
                  
                      if  length(Data.Trace(1,:))<1   
                          text(handles.Original_signal,0.4 ,0.5 ,{'No Photon is detected';...
                               'Please redo the generation with lorger time steps'})
                      else
                          handles.pushbutton10.Enable            ='on';
                          handles.edit53.Enable                  ='on';
                          handles.edit35.Enable                  ='on';
                          handles.edit36.Enable                  ='on';
                          
                          handles.edit35.String                  ='0';
                          handles.edit36.String                  ='0';
   

                          save('results','Data','-v7.3','-nocompression')

                          % set(handles.Plot_signal,signal)
                          plot(handles.Original_signal,repelem(cumsum(Data.Trace(1,:)),1,3),...
                                                     repmat([0 1 0],1,length(Data.Trace(1,:))))
                          xlabel(handles.Original_signal,'Time (s)')
                          ylabel(handles.Original_signal,'Detected photons')
                          ylim([0 1.1])
                          handles.Original_signal.YTick = [];
                          xlim(handles.Original_signal,[0 max(cumsum(Data.Trace(1,:)))])
                      end

                      handles.pushbutton19.Enable                   ='on';
                  
                  end
                  end      
           else
               handles.edit51.String = 'NAN' ;
               handles.Import_signal.Enable                  ='on';
               handles.Generate_Synthetic_signal.Enable      ='on';
               handles.Measure_Background.Enable             ='on';
           end
           
    elseif strcmp(choice1,'Binned')
           Data.Model_type=2;
           
           handles.uitable5.ColumnName{1} = 'Start step';
           handles.uitable5.ColumnName{2} = 'End step';
           
              answer={};

              opts.Interpreter = 'tex';
              answer = inputdlg({'Length of the trace (time step)',...
                                 'Bin size (s)',...
                                 'Confocal radius in x axis (\mum)',...
                                 'Confocal radius in y axis (\mum)',...
                                 'Confocal radius in z axis (\mum)',...
                                 'Diffusion coefficent (\mum^2/s)',...
                                 'Background photon emission rate (photons/s)',...
                                 'Molecular brightness (photons/s)',...
                                 'Radius of the periodic boundary in x axis (\mum)',...
                                 'Radius of the periodic boundary in y axis (\mum)',...
                                 'Radius of the periodic boundary in z axis (\mum)',...
                                 'Number of molecules'},...
                                 'Parameters',...
                                 [1 60;1 60;1 60; 1 60; 1 60; 1 60; 1 60; 1 60; 1 60; 1 60; 1 60; 1 60],...
                                 {'1000','0.0001','0.3','0.3','3.5','10','1000','50000','2','2','5','30'},opts);
               
              if length(answer)==12
                  while isempty(str2num(answer{1})) || str2num(answer{1})<=0 ||...
                        isempty(str2num(answer{2})) || str2num(answer{2})<=0 ||...
                        isempty(str2num(answer{3})) || str2num(answer{3})<=0 ||...
                        isempty(str2num(answer{4})) || str2num(answer{4})<=0 ||...
                        isempty(str2num(answer{5})) || str2num(answer{5})<=0 ||...
                        isempty(str2num(answer{6})) || str2num(answer{6})<=0 ||...
                        isempty(str2num(answer{7})) || str2num(answer{7})<=0 ||...
                        isempty(str2num(answer{8})) || str2num(answer{8})<=0 ||...
                        isempty(str2num(answer{9})) || str2num(answer{9})<=0 ||...
                        isempty(str2num(answer{10}))|| str2num(answer{10})<=0||...
                        isempty(str2num(answer{11}))|| str2num(answer{11})<=0||...
                        isempty(str2num(answer{12}))|| str2num(answer{12})<=0
          
                        opts.Interpreter = 'tex';
                        answer = inputdlg({'Length of the trace (time step)',...
                                           'Bin size (s)',...
                                           'Confocal radius in x axis (\mum)',...
                                           'Confocal radius in y axis (\mum)',...
                                           'Confocal radius in z axis (\mum)',...
                                           'Diffusion coefficent (\mum^2/s)',...
                                           'Background photon emission rate (photons/s)',...
                                           'Molecular brightness (photons/s)',...
                                           'Radius of the periodic boundary in x axis (\mum)',...
                                           'Radius of the periodic boundary in y axis (\mum)',...
                                           'Radius of the periodic boundary in z axis (\mum)',...
                                           'Number of molecules'},...
                                           'Parameters',...
                                           [1 60;1 60;1 60; 1 60; 1 60; 1 60; 1 60; 1 60; 1 60; 1 60; 1 60; 1 60],...
                                           {'1000','0.0001','0.3','0.3','3.5','10','1000','50000','2','2','5','30'},opts);
                  end

   
                  choice = questdlg('Please choose the Point Spread Function of interest:',...
                                    'Point Spread Function','Gaussian','Lorentzian','Cylindrical','');
    
                  if     strcmp(choice,'Gaussian')
                         handles.edit51.String = '3DG' ;
                         Data.PSF_func = 1 ;
                         Data.Wxyz = [ str2num(answer{3}) ; str2num(answer{4}) ; str2num(answer{5}) ];
                         
                  elseif strcmp(choice,'Lorentzian')
                         Data.Wxyz = [ str2num(answer{3}) ; str2num(answer{4}) ; str2num(answer{5}) ];
                         handles.edit51.String = '2DGL' ;
                         Data.PSF_func = 2 ;
           
                  elseif strcmp(choice,'Cylindrical')
                         Data.Wxyz = [ str2num(answer{3}) ; str2num(answer{4}) ; 100 ];
                         handles.edit51.String = '2DGC' ;
                         Data.PSF_func = 3 ;
                  else
                         handles.edit51.String = 'NAN' ;
                         handles.Import_signal.Enable                  ='on';
                         handles.Generate_Synthetic_signal.Enable      ='on';
                         handles.Measure_Background.Enable             ='on';
                  end
    
                  handles.edit65.String     = 0; 
                  handles.edit66.String     = 0;
                  handles.edit67.String     = 0;
                  handles.wx.String         = answer{3};
                  handles.wy.String         = answer{4};
                  handles.wz.String         = answer{5};
                  handles.Diff_synth.String = answer{6};
                  handles.mu_back.String    = answer{7};
                  handles.mu_synth.String   = answer{8};
                  handles.Delta_t.String    = answer{2};
                              
                  if  strcmp(choice,'') 
                      text(handles.Original_signal,0.4 ,0.5 ,'No point spread function is selected!')
                  else
                      
                      Data.Length_signal         = str2num(answer{1})               ;
                      Data.Cxyz                  = [0;0;0]                          ;
                      Data.mu_real               = str2num(handles.mu_synth.String) ;
                      Data.mu_back_real          = str2num(handles.mu_back.String ) ;

                      % Precalculation of the PSFs and their gradiant
                      [Data]                    = PSF_calculation(Data)             ;
                      
                      Data.Lxyz = [ str2num(answer{9}) ; str2num(answer{10}) ; str2num(answer{11})];
                      
                      Data.mu_real               = str2num(answer{8})  ;
                      Data.mu_back_real          = str2num(answer{7})  ;
                      Data.D_real                = str2num(answer{6})  ;
                      Data.Number_molecules_real = str2num(answer{12}) ;
                      Data.bin                   = str2num(answer{2})  ;

                      % sample from the generator function, you should direct it to the same folder
                      [ Data ] = Generative_model_binned( Data , handles  , 1  );
                  
                      if  length(Data.Trace(1,:))<1   
                          text(handles.Original_signal,0.4 ,0.5 ,{'No Photon is detected';...
                                     'Please redo the generation with lorger time steps'})
                      else
                          handles.pushbutton10.Enable            ='on';
                          handles.edit53.Enable                  ='on';
                          handles.edit35.Enable                  ='on';
                          handles.edit36.Enable                  ='on';
                          
                          handles.edit35.String                  ='0';
                          handles.edit36.String                  ='0';
   

                          save('results','Data','-v7.3','-nocompression')

                          % set(handles.Plot_signal,signal)
                          plot(handles.Original_signal,1:length(Data.Trace(1,:)),Data.Trace(1,:))
                          xlabel(handles.Original_signal,'Time (s)')
                          ylabel(handles.Original_signal,'Detected photons')
                          ylim([0 1.1])
                          handles.Original_signal.YTick = [];
                          xlim(handles.Original_signal,[0 length(Data.Trace(1,:))])
                      end

                      handles.pushbutton19.Enable                   ='on';
                  end
              end

end

   handles.Import_signal.Enable                  ='on';
   handles.Generate_Synthetic_signal.Enable      ='on';
   handles.Measure_Background.Enable             ='on';
   handles.pushbutton32.Enable                   ='on';
   handles.pushbutton33.Enable                   ='on';



     



% --- Executes on button press in Measure_Background.
function Measure_Background_Callback(hObject, eventdata, handles)
% hObject    handle to Measure_Background (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    handles.pushbutton19.Enable            ='on';
    cla(handles.Original_signal)
    cla(handles.axes7)
    cla(handles.axes8)
    cla(handles.axes15)
    cla(handles.axes16)
    cla(handles.axes18)
    cla(handles.axes19)
    cla(handles.axes20)
    
    cla(handles.axes26)
    cla(handles.axes27)    
    cla(handles.axes28)
    cla(handles.axes31)    
    cla(handles.axes32)
    cla(handles.axes33)
    
    
    
    handles.uitable5.Data                    =  [];
     
    handles.Delta_t.String                   = '-';
    handles.wx.String                        = '-';
    handles.wy.String                        = '-';
    handles.wz.String                        = '-';
    handles.mu_back.String                   = '-';
    handles.Diff_synth.String                = '-';
    handles.mu_synth.String                  = '-';
    
    handles.edit35.String                    = '0'   ;
    handles.edit36.String                    = '0'   ;
    handles.edit39.String                    = '1000';
    handles.edit40.String                    = '1000';
    handles.edit41.String                    = '10'  ;
    
    
    handles.D_alpha_prior.Enable             ='off';
    handles.D_beta_prior.Enable              ='off';
    handles.mu_alpha.Enable                  ='off';
    handles.mu_beta.Enable                   ='off';
    handles.Number_particles.Enable          ='off';
    handles.Measure_Background.Enable        ='off';
    handles.Generate_Synthetic_signal.Enable ='off';
    handles.Import_signal.Enable             ='off';
    handles.alpha_load.Enable                ='off';
    handles.concen_radious.Enable            ='off';
    handles.mu_prior_xy.Enable               ='off';
    handles.mu_prior_z.Enable                ='off';
    handles.var_prior_xy.Enable              ='off';
    handles.var_prior_z.Enable               ='off';
    handles.pushbutton10.Enable              ='off';
    handles.edit35.Enable                    ='off';
    handles.edit36.Enable                    ='off';
    handles.edit39.Enable                    ='off';
    handles.edit40.Enable                    ='off';
    handles.edit41.Enable                    ='off';
    handles.edit53.Enable                    ='off';
    handles.pushbutton8.Enable               ='off';
    handles.pushbutton11.Enable              ='off';
    handles.pushbutton17.Enable              ='off';
    handles.pushbutton20.Enable              ='off';
    handles.pushbutton21.Enable              ='off';
    handles.pushbutton22.Enable              ='off';
    handles.pushbutton23.Enable              ='off';
    handles.pushbutton24.Enable              ='off';
    handles.pushbutton25.Enable              ='off';
    handles.pushbutton26.Enable              ='off';
    handles.pushbutton32.Enable              ='off';
    handles.pushbutton33.Enable              ='off';
    
    handles.edit44.Enable                    ='off';
    handles.checkbox1.Enable                 ='off';
    handles.checkbox2.Enable                 ='off';
    handles.checkbox3.Enable                 ='off';
    handles.checkbox4.Enable                 ='off';
    handles.checkbox7.Enable                 ='off';
    handles.checkbox8.Enable                 ='off';
    

    
    
    choice = questdlg({'Do you want to import a single photon arrival time signal?'},...
                           'Sample analysis','Yes','No','Yes');
    
    if  strcmp(choice,'Yes')
    
%         
%         opts.Interpreter = 'tex';
%         answer = inputdlg({'Bin Size (s)   "smaller Bin size=longer calculation time"'},...
%                            'Parameters',[1 60],{handles.Delta_t.String},opts);
%   
%         while isempty(str2num(answer{1})) || str2num(answer{1})==0
%               opts.Interpreter = 'tex';
%               answer = inputdlg({'Bin Size (s)   "smaller Bin size=longer calculation time"'},...
%                                  'Parameters',[1 60],{handles.Delta_t.String},opts);
%         end
%         Delta_t = str2num(answer{1});
%         handles.Delta_t.String=answer{1};
%         
        [filename, pathname] = uigetfile( { '*.txt','Text-files (*.txt)';...
                                        '*.mat','MAT-files (*.mat)' }, ...
                                        'Import a time series', ...
                                        'MultiSelect', 'off');
            
         if ~isequal(filename,0)
            b_signal         = load(filename,pathname) ;
            background_trace = diff(b_signal)          ;

            if length(background_trace(:,1))>length(background_trace(1,:))
               background_trace  = background_trace' ;
               b_signal          = b_signal'         ;
            end
            % plot data
            plot(handles.Original_signal,repelem(b_signal,1,3),repmat([0 1 0],1,length(b_signal)))
            xlabel(handles.Original_signal,['Time (s)'])
            ylabel(handles.Original_signal,'Detected photons')
            handles.Original_signal.YTick = [];
            
            mu_back_alpha_prior =  1              ;
            mu_back_beta_prior  = 10              ;
            
            alpha_prime = mu_back_alpha_prior+length(b_signal);
            beta_prime  = 1/((1/ mu_back_beta_prior) + sum(background_trace));
            
            handles.mu_back.String=alpha_prime*beta_prime;
         end
             
         handles.Import_signal.Enable                  ='on';
         handles.Generate_Synthetic_signal.Enable      ='on';
         handles.Measure_Background.Enable             ='on';
         handles.pushbutton32.Enable                   ='on';
         handles.pushbutton33.Enable                   ='on';
    else
        choice1 = questdlg({'Do you want to import a binned signal?'},...
                            'Sample analysis','Yes','No','Yes');
        
        if  strcmp(choice1,'Yes')
            opts.Interpreter = 'tex';
            answer = inputdlg({'Bin Size (s)'});
  
            while isempty(str2num(answer{1})) || str2num(answer{1})==0
                  opts.Interpreter = 'tex';
                  answer = inputdlg({'Bin Size(s)'});
            end
            Delta_t = str2num(answer{1});
            handles.Delta_t.String=answer{1};
            
            [filename, pathname] = uigetfile( { '*.txt','Text-files (*.txt)';...
                                        '*.mat','MAT-files (*.mat)' }, ...
                                        'Import a time series', ...
                                        'MultiSelect', 'off');
            
             if ~isequal(filename,0)
                 background_signal = load(filename,pathname);
                 % plot data
                 plot(handles.Original_signal,1:length(background_signal),background_signal)
                 xlabel(handles.Original_signal,['Time step (\Deltat=' num2str(Delta_t) 's)'])
                 ylabel(handles.Original_signal,'Detected photons')
                 
                 mu_back_alpha_prior =  1              ;
                 mu_back_beta_prior  = 10              ;
                 
                 alpha_prime = mu_back_alpha_prior+sum(background_signal);
                 beta_prime  = 1/((1/ mu_back_beta_prior) + length(background_signal)*Delta_t);
                 
                 handles.mu_back.String=alpha_prime*beta_prime;
             end
        end
        handles.Import_signal.Enable                  ='on';
        handles.Generate_Synthetic_signal.Enable      ='on';
        handles.Measure_Background.Enable             ='on'; 
        handles.pushbutton32.Enable                   ='on';
        handles.pushbutton33.Enable                   ='on';
    end







% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
     
     
    handles.D_alpha_prior.Enable           ='off';
    handles.D_beta_prior.Enable            ='off';
    handles.mu_alpha.Enable                ='off';
    handles.mu_beta.Enable                 ='off';
    handles.Number_particles.Enable        ='off';
    handles.alpha_load.Enable              ='off';
    handles.concen_radious.Enable          ='off';
    handles.mu_prior_xy.Enable             ='off';
    handles.mu_prior_z.Enable              ='off';
    handles.var_prior_xy.Enable            ='off';
    handles.var_prior_z.Enable             ='off';
    
    handles.pushbutton8.String             = 'Start';
    
    handles.Generate_Synthetic_signal.Enable = 'off';
    handles.Measure_Background.Enable      ='off';
    handles.Import_signal.Enable           ='off';
    
    handles.edit35.Enable                  ='off';
    handles.edit36.Enable                  ='off';
    handles.edit39.Enable                  ='off';
    handles.edit40.Enable                  ='off';
    handles.edit41.Enable                  ='off';
    handles.edit46.Enable                  ='off';
    handles.edit47.Enable                  ='off';
    handles.edit48.Enable                  ='off';
    handles.edit52.Enable                  ='off';
    handles.edit53.Enable                  ='off';
    
    handles.pushbutton8.Enable             ='off';
    handles.pushbutton10.Enable            ='off';
    handles.pushbutton11.Enable            ='off';
    handles.pushbutton16.Enable            ='off';
    handles.pushbutton17.Enable            ='off';
    handles.pushbutton18.Enable            ='off';
    handles.pushbutton19.Enable            ='off';
    handles.pushbutton20.Enable            ='off';
    handles.pushbutton21.Enable            ='off';
    handles.pushbutton22.Enable            ='off';
    handles.pushbutton23.Enable            ='off';
    handles.pushbutton24.Enable            ='off';
    handles.pushbutton25.Enable            ='off';
    handles.pushbutton26.Enable            ='off';
    handles.pushbutton28.Enable            ='off';
    handles.pushbutton29.Enable            ='off';
    handles.pushbutton30.Enable            ='off';
    handles.pushbutton31.Enable            ='off';
    handles.pushbutton32.Enable            ='off';
    handles.pushbutton33.Enable            ='off';
    
    handles.edit44.Enable                  ='off';
    handles.checkbox1.Enable               ='off';
    handles.checkbox2.Enable               ='off';
    handles.checkbox3.Enable               ='off';
    handles.checkbox4.Enable               ='off';
    handles.checkbox7.Enable               ='off';
    handles.checkbox8.Enable               ='off';
    handles.checkbox9.Enable               ='off';
    handles.pushbutton8.Enable             ='off';

     load('results.mat');

     Data.Save_on_off=handles.checkbox9.Value;
     
     len = length(Data.Trace_partial)                                                     ;
     Data.concen_radious = str2num(handles.concen_radious.String)                          ;
     for k=1:len
         sign_siz(k)   = length(Data.Trace_partial{k})                                     ; 
         Data.x{k}     = zeros(3*str2num(handles.Number_particles.String),sign_siz(k))+.1  ;
         % Set the concentration to zero
         Data.concentration{k} = cast(zeros(1,sign_siz(k),length(Data.concen_radious)),'uint8') ;
     end
     

%%%%%%%%%%%%%%%%%%%%%%%%%%%% Initial vslues %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      
     Data.D              = 1/gamrnd( str2num(handles.D_alpha_prior.String) , ...
                                     str2num(handles.D_beta_prior.String) ) ;
                                 
     Data.mu             =   gamrnd( str2num(handles.mu_alpha.String) , ...
                                     str2num(handles.mu_beta.String) , 1 , length(Data.Wxyz(1,:) ) )  ;
                                 
     Data.mu_back        =   gamrnd(str2num(handles.edit46.String) , ...
                                    str2num(handles.edit47.String) , 1, length(Data.Wxyz(1,:) ) )   ;
     Data.b              = zeros(1,len*str2num(handles.Number_particles.String))                   ;
     
     
     Data.percentage_dif = str2num(handles.edit52.String);
     Data.save_size = str2num(handles.edit41.String);
     Data.iter_b_mu =10;
     if   Data.Model_type==1
         [ Data ] = Gibbs_sampler_multi_focuses_inter_arrival_photons( Data , str2num(handles.edit39.String) , handles , 1 );
     
         if  length(Data.Wxyz(1,:))>1
             for k=1:length(Data.Trace_partial)
                 
                 timing=cumsum(Data.Trace_partial{k}(1,:));
                    
                    burn_in=floor(size(Data.b,1)*40/100);
                    HJ=histcounts(sum(Data.b(burn_in:end,(k-1)*Data.Number_molecules+1:k*Data.Number_molecules),2),1:1:Data.Number_molecules+1);
                    max_num_active(k)=min(find(HJ==max(HJ)));
                    
                    for  hh=1:Data.Number_molecules
                         molecules(k,hh)=sum(Data.b(:,(k-1)*Data.Number_molecules+hh));
                    end
    
    
                    [~,AB]=sort(molecules(k,:),'descend');
                    Active_molecules=AB(1:max_num_active(k));
                    

                    begin_of=1;

                    ell    = char(hex2dec(strsplit('2113')));
                    learned=[];
                    learned_25=[];
                    learned_75=[];

                    numpa=Active_molecules;

                    for numpar=numpa
                        learned(1,:)=quantile(reshape(Data.x{k}(3*numpar-2,:,begin_of:end),...
                        size(Data.x{k}(1,:,begin_of:end),2),size(Data.x{k}(1,:,begin_of:end),3))',0.5);
                        learned(2,:)=quantile(reshape(Data.x{k}(3*numpar-1,:,begin_of:end),...
                        size(Data.x{k}(1,:,begin_of:end),2),size(Data.x{k}(1,:,begin_of:end),3))',0.5);
                        learned(3,:)=quantile(reshape(Data.x{k}(3*numpar  ,:,begin_of:end),...
                        size(Data.x{k}(1,:,begin_of:end),2),size(Data.x{k}(1,:,begin_of:end),3))',0.5);

                        learned_25(1,:)=quantile(reshape(Data.x{k}(3*numpar-2,:,begin_of:end),...
                        size(Data.x{k}(1,:,begin_of:end),2),size(Data.x{k}(1,:,begin_of:end),3))',0.025);
                        learned_25(2,:)=quantile(reshape(Data.x{k}(3*numpar-1,:,begin_of:end),...
                        size(Data.x{k}(1,:,begin_of:end),2),size(Data.x{k}(1,:,begin_of:end),3))',0.025);
                        learned_25(3,:)=quantile(reshape(Data.x{k}(3*numpar  ,:,begin_of:end),...
                        size(Data.x{k}(1,:,begin_of:end),2),size(Data.x{k}(1,:,begin_of:end),3))',0.025);

                        learned_75(1,:)=quantile(reshape(Data.x{k}(3*numpar-2,:,begin_of:end),...
                        size(Data.x{k}(1,:,begin_of:end),2),size(Data.x{k}(1,:,begin_of:end),3))',0.975);
                        learned_75(2,:)=quantile(reshape(Data.x{k}(3*numpar-1,:,begin_of:end),...
                        size(Data.x{k}(1,:,begin_of:end),2),size(Data.x{k}(1,:,begin_of:end),3))',0.975);
                        learned_75(3,:)=quantile(reshape(Data.x{k}(3*numpar  ,:,begin_of:end),...
                        size(Data.x{k}(1,:,begin_of:end),2),size(Data.x{k}(1,:,begin_of:end),3))',0.975);
                    
                    
                        plot(handles.axes28,timing,learned(1,:),'b')
                        hold(handles.axes28,'on')
                        plot(handles.axes28,timing,learned_25(1,:),'m')
                        plot(handles.axes28,timing,learned_75(1,:),'m')
                        
                        plot(handles.axes31,timing,learned(2,:),'b')
                        hold(handles.axes31,'on')
                        plot(handles.axes31,timing,learned_25(2,:),'m')
                        plot(handles.axes31,timing,learned_75(2,:),'m')
                        
                        plot(handles.axes32,timing,learned(3,:),'b')
                        hold(handles.axes32,'on')
                        plot(handles.axes32,timing,learned_25(3,:),'m')
                        plot(handles.axes32,timing,learned_75(3,:),'m')
                    end
                    
                    if isfield(Data,'X')
                       for mm=1:size(Data.X,1)
                           plot(handles.axes28,timing,Data.X_partial{k}(mm,:),'g')
                           plot(handles.axes31,timing,Data.Y_partial{k}(mm,:),'g')
                           plot(handles.axes32,timing,Data.Z_partial{k}(mm,:),'g')      
                           
                           ylim(handles.axes28,[-Data.Lxyz(1) Data.Lxyz(1)])
                           ylim(handles.axes31,[-Data.Lxyz(2) Data.Lxyz(2)])
                           ylim(handles.axes32,[-Data.Lxyz(3) Data.Lxyz(3)])
                        end
                    end
                 
             end
             handles.axes28.XTick = [];
             handles.axes31.XTick = [];
             
             hold(handles.axes28,'off')
             hold(handles.axes31,'off')
             hold(handles.axes32,'off')
                
             xlabel(handles.axes32,'Time')
             
             ylabel(handles.axes28,'X (\mum)')
             ylabel(handles.axes31,'Y (\mum)')
             ylabel(handles.axes32,'Z (\mum)')
             
             xlim(handles.axes28,[min(timing) max(timing)])
             xlim(handles.axes31,[min(timing) max(timing)])
             xlim(handles.axes32,[min(timing) max(timing)])
             
         end
     
     
     else
         [ Data ] = Gibbs_sampler_binned_single_focus_confocal_volume( Data , str2num(handles.edit39.String) , handles , 1 , sign_siz  );
     end
    
     save('results' , 'Data' ,'-v7.3','-nocompression'  )
     
  
     for j=1:length(Data.Wxyz(1,:))
         plot(handles.axes16,1:1:length(Data.mu(:,j)),Data.mu(:,j),'color',[0, 0.4470, 0.7410])
         histogram(handles.axes20,Data.mu(:,j),'Normalization','pdf',...
             'Orientation','horizontal','facecolor',[0, 0.4470, 0.7410])
      
         plot(handles.axes26,1:1:length(Data.mu(:,j)),Data.mu_back(:,j),'color',[0, 0.4470, 0.7410])
         histogram(handles.axes27,Data.mu_back(:,j),'Normalization','pdf',...
             'Orientation','horizontal','facecolor',[0, 0.4470, 0.7410])
         
         hold(handles.axes16,'on')
         hold(handles.axes20,'on')
         hold(handles.axes26,'on')
         hold(handles.axes27,'on')
     end
     hold(handles.axes16,'off')
     hold(handles.axes20,'off')
     hold(handles.axes26,'off')
     hold(handles.axes27,'off')
     
     handles.axes20.YTick = [];
     handles.axes20.XTick = [];
     handles.axes20.XAxisLocation = 'top';
     ylim(handles.axes20,[0 max(max(Data.mu))])
    
     handles.axes27.YTick = [];
     handles.axes27.XTick = [];
     handles.axes27.XAxisLocation = 'top';
     ylim(handles.axes27,[0 max(max(Data.mu))])
     
     xlabel(handles.axes16,'Iteration')
     ylabel(handles.axes16,{'Molecular brightness';'(photons/s)'})
     xlim(handles.axes16,[0 length(Data.mu)])
     
     xlabel(handles.axes26,'Iteration')
     ylabel(handles.axes26,{'Background photon';'emission rate';'(photons/s)'})
     xlim(handles.axes26,[0 length(Data.mu)])
     
     handles.edit46.Enable                  ='on';
     handles.edit47.Enable                  ='on';
     handles.edit48.Enable                  ='on';
     
    plot(handles.axes8,1:1:length(Data.D),Data.D)
    xlabel(handles.axes8,'Iteration')
    ylabel(handles.axes8,'Diff. coeff. (\mum^2/s)')
    xlim(handles.axes8,[0 length(Data.mu(:,1))])
    ylim(handles.axes8,[0 max(Data.D)])
    set(handles.axes8,'yscale','log') 
    
    
    for k=1:len
        plot(handles.axes15,1:1:length(Data.D),...
             sum(Data.b(:,(k-1)*str2num(handles.Number_particles.String)+1:k*...
                                         str2num(handles.Number_particles.String)),2))
        hold (handles.axes15,'on')
        
        histogram(handles.axes18,...
            sum(Data.b(:,(k-1)*str2num(handles.Number_particles.String)+1:k*...
                                         str2num(handles.Number_particles.String)),2),...
                  'Normalization','pdf','Orientation','horizontal')
        hold (handles.axes18,'on')
    end
    hold (handles.axes15,'off')
    hold (handles.axes18,'off')
    handles.axes18.YTick = [];
    handles.axes18.XAxisLocation = 'top';
    ylim(handles.axes18,[0 str2num(handles.Number_particles.String)])
    
    
    xlabel(handles.axes15,'Iteration')
    ylabel(handles.axes15,{'Number of';'active molecules'})
    ylim(handles.axes15,[0 str2num(handles.Number_particles.String)])
    xlim(handles.axes15,[0 length(Data.mu)])
    
    
    
    histogram(handles.axes19,Data.D,'Normalization','pdf','Orientation','horizontal')
    handles.axes19.XAxisLocation = 'top';
    ylim(handles.axes19,[0 max(Data.D)])
    handles.axes19.YAxisLocation = 'right';
    set(handles.axes19,'yscale','log') 
    
   
    drawnow
    
    handles.edit44.Enable                        ='on';
    handles.checkbox1.Enable                     ='on';
    handles.checkbox2.Enable                     ='on';
    handles.checkbox3.Enable                     ='on';
    handles.checkbox4.Enable                     ='on';
    handles.checkbox7.Enable                     ='on';
    handles.checkbox8.Enable                     ='on';
    handles.checkbox9.Enable                     ='on';
    
    handles.Generate_Synthetic_signal.Enable     ='on';
    handles.Measure_Background.Enable            ='on';
    handles.Import_signal.Enable                 ='on';
    
    handles.edit35.Enable                        ='on';
    handles.edit36.Enable                        ='on';
    handles.edit40.Enable                        ='on';
    handles.edit53.Enable                        ='on';
    
    handles.pushbutton8.Enable                   ='on';
    handles.pushbutton10.Enable                  ='on';
    handles.pushbutton11.Enable                  ='on';
    handles.pushbutton16.Enable                  ='on';
    handles.pushbutton18.Enable                  ='on';
    handles.pushbutton19.Enable                  ='on';
    handles.pushbutton21.Enable                  ='on';
    handles.pushbutton22.Enable                  ='on';
    handles.pushbutton23.Enable                  ='on';
    handles.pushbutton24.Enable                  ='on';
    handles.pushbutton25.Enable                  ='on';
    handles.pushbutton26.Enable                  ='on';
    handles.pushbutton29.Enable                  ='on';
    handles.pushbutton30.Enable                  ='on';
    handles.pushbutton31.Enable                  ='on';
    handles.pushbutton32.Enable                  ='on';
    handles.pushbutton33.Enable                  ='on';
    
    if  sum(handles.pushbutton23.String) == sum('Automatic (OFF)')
        handles.pushbutton20.Enable              ='on';
        handles.pushbutton17.Enable              ='on';
        handles.edit39.Enable                    ='on';
        handles.edit41.Enable                    ='on';
    else
        handles.edit52.Enable                    ='on';
    end
    

    handles.D_alpha_prior.Enable                 ='on';
    handles.D_beta_prior.Enable                  ='on';
    handles.mu_alpha.Enable                      ='on';
    handles.mu_beta.Enable                       ='on';
    handles.Number_particles.Enable              ='on';
    handles.alpha_load.Enable                    ='on';
    handles.concen_radious.Enable                ='on';
    handles.mu_prior_xy.Enable                   ='on';
    handles.mu_prior_z.Enable                    ='on';
    handles.var_prior_xy.Enable                  ='on';
    handles.var_prior_z.Enable                   ='on';

    
    
    
function edit41_Callback(hObject, eventdata, handles)
% hObject    handle to edit41 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit41 as text
%        str2double(get(hObject,'String')) returns contents of edit41 as a double


% --- Executes during object creation, after setting all properties.
function edit41_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit41 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit40_Callback(hObject, eventdata, handles)
% hObject    handle to edit40 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit40 as text
%        str2double(get(hObject,'String')) returns contents of edit40 as a double


% --- Executes during object creation, after setting all properties.
function edit40_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit40 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit39_Callback(hObject, eventdata, handles)
% hObject    handle to edit39 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit39 as text
%        str2double(get(hObject,'String')) returns contents of edit39 as a double


% --- Executes during object creation, after setting all properties.
function edit39_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit39 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton16.
function pushbutton16_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    load('results.mat');
    
    handles.edit44.Enable                        ='off';
    handles.checkbox1.Enable                     ='off';
    handles.checkbox2.Enable                     ='off';
    handles.checkbox3.Enable                     ='off';
    handles.checkbox4.Enable                     ='off';
    handles.checkbox7.Enable                     ='off';
    handles.checkbox8.Enable                     ='off';
    handles.pushbutton11.Enable                  ='off';
    
    current_location=cd;
    
    mkdir Saved_Results
    cd Saved_Results
    
    MAXX=floor(length(Data.D)*str2num(handles.edit44.String));
    
    
    choice = questdlg({'In what format do you want to save the results?'},...
                       'SAVE RESULTS','Text(.txt)','Matlab(.mat)','Cancel');
    

    if  strcmp(choice,'Text(.txt)')
        formatSpec = ' %4.2f ';
        if  handles.checkbox1.Value==1
            fid1 = fopen( 'Diffusion_coefficient.txt', 'wt' );        
            fprintf(fid1,formatSpec,Data.D(MAXX:end));
        end
        if  handles.checkbox2.Value==1
            for jj=1:length(Data.Wxyz(1,:))
                fid2 = fopen( ['Molecular_brightness_',num2str(jj),'.txt'], 'wt' );
                fprintf(fid2,formatSpec,Data.mu(MAXX:end,jj));
            end
        end
        if  handles.checkbox7.Value==1
            for jj=1:length(Data.Wxyz(1,:))
                fid7 = fopen( ['Background_emission_rate_',num2str(jj),'.txt'], 'wt' );
                fprintf(fid7,formatSpec,Data.mu_back(MAXX:end,jj));
            end
        end
        if  handles.checkbox3.Value==1
            fid3 = fopen( 'Number_of_Acive_molecules (loads).txt', 'wt' );
            for i=1:length(Data.Trace_partial)
                fprintf(fid3,['\n','Trace',num2str(i),'\n']);
                fprintf(fid3,'%g\t',sum(Data.b(MAXX:end,(i-1)*...
                      str2num(handles.Number_particles.String)+1:i*...
                      str2num(handles.Number_particles.String)),2));
            end
        end
        
        

        if  handles.checkbox4.Value==1
            fid4 = fopen( 'Concentration_or_Trajectories.txt', 'wt' );
            if  length(Data.Wxyz(1,:))>1
                for i=1:length(Data.Trace_partial)
                    fprintf(fid4,['\n','Trace',num2str(i),'\n']);
                    AAA=[];
                    AAA(1,:)=1:3:3*str2num(handles.Number_particles.String);
                    AAA(2,:)=2:3:3*str2num(handles.Number_particles.String);
                    AAA(3,:)=3:3:3*str2num(handles.Number_particles.String);
                    
                    ASS=find(Data.b_max==1);
                    for l=1:length(ASS)
                        fprintf(fid4,['\n','Trajectory of molecule ',num2str(l),'\n','X(micro meter)   ']);
                        fprintf(fid4,'%g\t',Data.x_max{i}(AAA(1,ASS(l)),:));
                        fprintf(fid4,['\n','Y(micro meter)   ']);
                        fprintf(fid4,'%g\t',Data.x_max{i}(AAA(2,ASS(l)),:));
                        fprintf(fid4,['\n','Z(micro meter)   ']);
                        fprintf(fid4,'%g\t',Data.x_max{i}(AAA(3,ASS(l)),:));
                        fprintf(fid4,'\n');
                    end
                end
            else
                for i=1:length(Data.Trace_partial)
                    fprintf(fid4,['\n','Trace',num2str(i),'\n']);
                    for l=1:length(str2num(handles.concen_radious.String))
                        concenn50=[];
                        concenn75=[];
                        concenn25=[];
                        for k = 1 : length(Data.Trace_partial{i}(1,:))
                            concenn50(1,k)=quantile(reshape(Data.concentration{i}(:,k,l),1,size(Data.concentration{i},1)),0.50)    ;
                            concenn25(1,k)=quantile(reshape(Data.concentration{i}(:,k,l),1,size(Data.concentration{i},1)),0.025)    ;
                            concenn75(1,k)=quantile(reshape(Data.concentration{i}(:,k,l),1,size(Data.concentration{i},1)),0.975)    ;
                        end
                        fprintf(fid4,['\n','Number of molecules',num2str(l),'\n','Median of posterior                ']);
                        fprintf(fid4,'%g\t',concenn50);
                        fprintf(fid4,['\n','0.25 percent quantile of posterior   ']);
                        fprintf(fid4,'%g\t',concenn25);
                        fprintf(fid4,['\n','97.5 percent quantile of posterior   ']);
                        fprintf(fid4,'%g\t',concenn75);
                        fprintf(fid4,'\n');
                    end
                end
            end
        end
        
        
      

        fid5 = fopen('Signal.txt', 'wt' );
        for i = 1 : length(Data.Trace_partial)
            fprintf(fid5,['\n','Trace',num2str(i),'\n']);
            fprintf(fid5,'%g\t',Data.Trace_partial{i});
        end
        
        
    else
        if  strcmp(choice,'Matlab(.mat)')
            save('Results','Data','-v7.3','-nocompression')
        end
    end
    
    drawnow
    handles.edit44.Enable                        ='on';
    handles.checkbox1.Enable                     ='on';
    handles.checkbox2.Enable                     ='on';
    handles.checkbox3.Enable                     ='on';
    handles.checkbox4.Enable                     ='on';
    handles.checkbox8.Enable                     ='on';
    handles.pushbutton11.Enable                  ='on';
    handles.checkbox7.Enable             ='on';
    
    
    
    cd(current_location)
    clear all
    clc
    
   





% --- Executes on button press in pushbutton17.
function pushbutton17_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



    handles.Generate_Synthetic_signal.Enable    =  'off';
    handles.Measure_Background.Enable           =  'off';
    handles.Import_signal.Enable                =  'off';
    
    
    
    handles.pushbutton8.Enable                  =  'off';
    handles.pushbutton10.Enable                 =  'off';
    handles.pushbutton11.Enable                 =  'off';
    handles.pushbutton16.Enable                 =  'off';
    handles.pushbutton17.Enable                 =  'off';
    handles.pushbutton19.Enable                 =  'off';
    handles.pushbutton20.Enable                 =  'off';
    handles.pushbutton22.Enable                 =  'off';
    handles.pushbutton23.Enable                 =  'off';
    handles.pushbutton28.Enable                 =  'off';
    handles.pushbutton29.Enable                 =  'off';
    handles.pushbutton32.Enable                 =  'off';
    handles.pushbutton33.Enable                 =  'off';
    handles.pushbutton30.Enable                 =  'off';
    
    handles.edit35.Enable                       =  'off';
    handles.edit36.Enable                       =  'off';
    
    handles.edit44.Enable                       =  'off';
    
    handles.checkbox1.Enable                    =  'off';
    handles.checkbox2.Enable                    =  'off';
    handles.checkbox7.Enable                    =  'off';
    handles.checkbox3.Enable                    =  'off';
    handles.checkbox4.Enable                    =  'off';
    handles.checkbox8.Enable                    =  'off';
    handles.checkbox9.Enable                    =  'off';
    
    handles.edit39.Enable                       =  'off';
    handles.edit40.Enable                       =  'off';
    handles.edit41.Enable                       =  'off';
    handles.edit48.Enable                       =  'off';
    handles.concen_radious.Enable               =  'off';
    
    handles.edit51.Enable                       =  'off';
    handles.wx.Enable                           =  'off';
    handles.wy.Enable                           =  'off';
    handles.wz.Enable                           =  'off';
    handles.edit65.Enable                       =  'off';
    handles.edit66.Enable                       =  'off';
    handles.edit67.Enable                       =  'off';
    handles.Diff_synth.Enable                   =  'off';
    handles.mu_back.Enable                      =  'off';
    handles.mu_synth.Enable                     =  'off';
    
    handles.D_alpha_prior.Enable                =  'off';
    handles.D_beta_prior.Enable                 =  'off';
    
    handles.mu_alpha.Enable                     =  'off';
    handles.mu_beta.Enable                      =  'off';
    handles.edit46.Enable                       =  'off';
    handles.edit47.Enable                       =  'off';
    
    handles.Number_particles.Enable             =  'off';
    handles.alpha_load.Enable                   =  'off';
    
    handles.mu_prior_xy.Enable                  =  'off';
    handles.mu_prior_z.Enable                   =  'off';
    handles.var_prior_xy.Enable                 =  'off';
    handles.var_prior_z.Enable                  =  'off';
    
    
    load('results.mat');
     
     
     
     Data.D_alpha              = str2num(handles.D_alpha_prior.String)            ;
     Data.D_beta               = str2num(handles.D_beta_prior.String)             ;
     Data.mu_alpha             = str2num(handles.mu_alpha.String)                 ;
     Data.mu_beta              = str2num(handles.mu_beta.String)                  ;
     Data.mu_back_alpha        = str2num(handles.edit46.String)                   ;
     Data.mu_back_beta         = str2num(handles.edit47.String)                   ;
     Data.mu_prior_xyz         = [str2num(handles.mu_prior_xy.String) ,...
                                  str2num(handles.mu_prior_xy.String) ,...
                                  str2num(handles.mu_prior_z.String) ]            ;
     Data.var_prior_xyz        = [str2num(handles.var_prior_xy.String) ,...
                                  str2num(handles.var_prior_xy.String) ,...
                                  str2num(handles.var_prior_z.String) ]           ;
     Data.Number_molecules     = str2num(handles.Number_particles.String)         ;
     Data.gamma_b              = str2num(handles.alpha_load.String)               ;
     
     Data.Q                    = 1/(1+(Data.Number_molecules-1)/Data.gamma_b)     ;
                             
     Data.mu_back_proposal     = str2num(handles.edit48.String)                   ;
     Data.mu_proposal          = str2num(handles.edit40.String)                   ;
     
     Data.HMC_step_size        = 0.1                                              ;
     
     Data.demo                 = false                                            ;
     
     Data.x_accept_rate        = [0;0]                                            ;
     Data.mu_accept_rate       = [0;0]                                            ;
     Data.log_post             = -10^500                                          ;
     
     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Initial vslues %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     Data.D                    = 1/gamrnd(Data.D_alpha ,Data.D_beta )                  ;
     Data.mu                   = gamrnd(Data.mu_alpha ,Data.mu_beta ,1,length(Data.Wxyz(1,:)))                  ;
     Data.mu_back              = gamrnd(Data.mu_back_alpha ,Data.mu_back_beta ,1,length(Data.Wxyz(1,:)))        ;
     len                       = length(Data.Trace_partial)                                        ;
     Data.b                    = rand(1,len*str2num(handles.Number_particles.String))<Data.Q ;
     
     if  handles.checkbox9.Value==1
         Data.Save_on_off = true  ;
     else
         Data.Save_on_off = false ;
     end
     
     Data.concen_radious       = str2num(handles.concen_radious.String);
     
     for k=1:len
         sign_siz(k)           = length(Data.Trace_partial{k}) ;
         Data.x{k}             = randn(3*str2num(handles.Number_particles.String),sign_siz(k))*.1  ;
         Data.concentration{k} = zeros( 1 , sign_siz(k) , length(Data.concen_radious)  ) ;
     end
     
     
     
     % Precalculations to directly sample the loads
     Data.BB_size  =[];
     Data.BB_loads =[];
     for ll=1:min([7 , Data.Number_molecules])
         Data.BB_loads{ll}  = dec2bin(2^ll-1:-1:0)-'0';
         Data.BB_size(ll,:) = size(Data.BB_loads{ll});
     end
      
Data.percentage_dif = str2num(handles.edit52.String);
Data.save_size =str2num(handles.edit41.String);
Data.iter_b_mu =10;
     if  Data.Model_type==1               % Inter-arrival time traces      
         tic
         [ ~ ] = Gibbs_sampler_multi_focuses_inter_arrival_photons( Data , 20 , handles , 1 );
    
         timmer = toc;
     else                                 % Binned traces
         tic
         [ ~  ] = Gibbs_sampler_binned_single_focus_confocal_volume( Data , 20 , handles , 1 , sign_siz );
         
         timmer=toc;
     end
     
     Data.timmer=(timmer/19);
    
     save('results','Data','-v7.3','-nocompression');

     timmer=floor(str2num(handles.edit39.String)*(timmer/19));
     
     if  timmer>=3600
         timmer=floor(timmer/3600);
         estimate_time=['Start (' num2str(timmer) 'hr(s))'];
     else
         if timmer>=60
            timmer=floor(timmer/60);
            estimate_time=['Start (' num2str(timmer) 'min)'];
         else
             estimate_time=['Start (' num2str(timmer) 's)'];
         end
     end
   
    
    handles.Generate_Synthetic_signal.Enable    =  'on';
    handles.Measure_Background.Enable           =  'on';
    handles.Import_signal.Enable                =  'on';
    
    handles.pushbutton8.Enable                  =  'on';
    handles.pushbutton10.Enable                 =  'on';
    handles.pushbutton17.Enable                 =  'on';
    handles.pushbutton19.Enable                 =  'on';
    handles.pushbutton22.Enable                 =  'on';
    handles.pushbutton23.Enable                 =  'on';
    handles.pushbutton28.Enable                 =  'on';
    handles.pushbutton29.Enable                 =  'on';
    handles.pushbutton32.Enable                 =  'on';
    handles.pushbutton33.Enable                 =  'on';
    handles.pushbutton30.Enable                 =  'on';
    
    handles.pushbutton8.String                  = estimate_time;

    
    
    handles.edit35.Enable                       =  'on';
    handles.edit36.Enable                       =  'on';
    
    handles.checkbox9.Enable                    =  'on';
    
    handles.edit39.Enable                       =  'on';
    handles.edit40.Enable                       =  'on';
    handles.edit41.Enable                       =  'on';
    handles.edit48.Enable                       =  'on';
    handles.concen_radious.Enable               =  'on';
    
    handles.D_alpha_prior.Enable                =  'on';
    handles.D_beta_prior.Enable                 =  'on';
    
    handles.mu_alpha.Enable                     =  'on';
    handles.mu_beta.Enable                      =  'on';
    handles.edit46.Enable                       =  'on';
    handles.edit47.Enable                       =  'on';
    
    handles.Number_particles.Enable             =  'on';
    handles.alpha_load.Enable                   =  'on';
    
    handles.mu_prior_xy.Enable                  =  'on';
    handles.mu_prior_z.Enable                   =  'on';
    handles.var_prior_xy.Enable                 =  'on';
    handles.var_prior_z.Enable                  =  'on';
    
    

    cla(handles.axes8)
    cla(handles.axes15)
    cla(handles.axes16)
    cla(handles.axes18)
    cla(handles.axes19)
    cla(handles.axes20)
    cla(handles.axes26)
    cla(handles.axes27)
    
    cla(handles.axes28)
    cla(handles.axes31)
    cla(handles.axes32)







% --- Executes on button press in pushbutton18.
function pushbutton18_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

choice = questdlg({'All the files in the directory will be removed. Please save them if you did not!'...
                   },'Are you sure?','Yes','No','Yes');
    
if  strcmp(choice,'Yes')

     S = dir('*.mat');                   % Collect directories
     N = {S.name};                       % Collect Names of the text files
     for i=1:length(N)                   % A For loop for read data
         delete(N{i});           % Import data from the file
     end


     clear all;
     clc;
     close all;  
end







% --- Executes on button press in pushbutton19.
function pushbutton19_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

 clc;
    S = dir('*.mat');                   % Collect directories
    N = {S.name};                       % Collect Names of the text files
    for i=1:length(N)                   % A For loop for read data
        delete(N{i});           % Import data from the file
    end
    clear('S','N')
 
    handles.edit51.String                  = '-';
    handles.Delta_t.String                 = '-';
    handles.wx.String                      = '-';
    handles.wy.String                      = '-';
    handles.wz.String                      = '-';
    handles.edit65.String                  = '-';
    handles.edit66.String                  = '-';
    handles.edit67.String                  = '-';
    handles.Diff_synth.String              = '-';
    handles.mu_back.String                 = '-';
    handles.mu_synth.String                = '-';
    
    handles.D_alpha_prior.Enable           ='off';
    handles.D_beta_prior.Enable            ='off';
    
    handles.mu_alpha.Enable                ='off';
    handles.mu_beta.Enable                 ='off';
    handles.edit46.Enable                  ='off';
    handles.edit47.Enable                  ='off';
    
    handles.Number_particles.Enable        ='off';
    handles.alpha_load.Enable              ='off';
    
    handles.mu_prior_xy.Enable             ='off';
    handles.mu_prior_z.Enable              ='off';
    handles.var_prior_xy.Enable            ='off';
    handles.var_prior_z.Enable             ='off';
    
    
    handles.edit35.String                  = '0';
    handles.edit36.String                  = '0';
    handles.edit39.String                  = '1000';
    handles.edit40.String                  = '1000';
    handles.edit41.String                  = '10';
    handles.edit48.String                  = '1000';
    handles.edit52.String                  = '0.1';
    
    
    handles.concen_radious.Enable          ='off';

    
    handles.pushbutton8.Enable             ='off';
    handles.pushbutton10.Enable            ='off';
    handles.pushbutton11.Enable            ='off';
    handles.pushbutton17.Enable            ='off';
    handles.pushbutton16.Enable            ='off';
    handles.pushbutton19.Enable            ='off';
    handles.pushbutton20.Enable            ='off';
    handles.pushbutton22.Enable            ='off';
    handles.pushbutton23.Enable            ='off';
    handles.pushbutton24.Enable            ='off';
    handles.pushbutton25.Enable            ='off';
    handles.pushbutton26.Enable            ='off';
    handles.pushbutton28.Enable            ='off';
    handles.pushbutton29.Enable            ='off';
    handles.pushbutton30.Enable            ='off';
    handles.pushbutton31.Enable            ='off';
    
    handles.text36.Enable                  ='off';
    handles.text37.Enable                  ='off';
    
    handles.uitable5.Data                  =[];
    handles.uitable5.Enable                ='off';
    
    handles.edit35.Enable                  ='off';
    handles.edit36.Enable                  ='off';
    handles.edit39.Enable                  ='off';
    handles.edit40.Enable                  ='off';
    handles.edit41.Enable                  ='off';
    handles.edit44.Enable                  ='off';

    handles.edit48.Enable                  ='off';
    handles.edit52.Enable                  ='off';
    handles.edit53.Enable                  ='off';
    
    handles.checkbox1.Enable               ='off';
    handles.checkbox2.Enable               ='off';
    handles.checkbox3.Enable               ='off';
    handles.checkbox4.Enable               ='off';
    handles.checkbox7.Enable               ='off';
    handles.checkbox8.Enable               ='off';
    handles.checkbox9.Enable               ='off';
    
    handles.Generate_Synthetic_signal.Enable   ='on';
    handles.Measure_Background.Enable          ='on';
    handles.Import_signal.Enable               ='on';
    
    cla(handles.Original_signal)
    cla(handles.axes7)
    cla(handles.axes8)
    cla(handles.axes15)
    cla(handles.axes16)
    cla(handles.axes18)
    cla(handles.axes19)
    cla(handles.axes20)
    
    cla(handles.axes26)
    cla(handles.axes27)
    
    cla(handles.axes28)
    cla(handles.axes31)
    cla(handles.axes32)
    cla(handles.axes33)
    
    handles.pushbutton8.String  ='Start';
    
    clear all;
 
 
 
 
 


% --- Executes on button press in pushbutton20.
function pushbutton20_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


    handles.pushbutton8.Enable                   ='off';
    handles.pushbutton10.Enable                  ='off';
    handles.pushbutton11.Enable                  ='off';
    handles.pushbutton16.Enable                  ='off';
    handles.pushbutton17.Enable                  ='off';
    handles.pushbutton20.Enable                  ='off';
    handles.pushbutton22.Enable                  ='off';
    handles.pushbutton23.Enable                  ='off';
    handles.pushbutton29.Enable                  ='off';
    handles.pushbutton30.Enable                  ='off';
    handles.pushbutton31.Enable                  ='off';
    handles.pushbutton32.Enable                  ='off';
    handles.pushbutton33.Enable                  ='off';
    
    handles.checkbox1.Enable                     ='off';
    handles.checkbox2.Enable                     ='off';
    handles.checkbox3.Enable                     ='off';
    handles.checkbox4.Enable                     ='off';
    handles.checkbox7.Enable                     ='off';
    handles.checkbox8.Enable                     ='off';
    handles.checkbox9.Enable                     ='off';
    
    handles.Generate_Synthetic_signal.Enable     ='off';
    handles.Measure_Background.Enable            ='off';
    handles.Import_signal.Enable                 ='off';
    
    handles.edit35.Enable                        ='off';
    handles.edit36.Enable                        ='off';
    handles.edit39.Enable                        ='off';
    handles.edit40.Enable                        ='off';
    handles.edit41.Enable                        ='off';
    handles.edit44.Enable                        ='off';
    handles.edit46.Enable                        ='off';
    handles.edit47.Enable                        ='off';
    handles.edit48.Enable                        ='off';
    handles.edit53.Enable                        ='off';

    handles.D_alpha_prior.Enable                 ='off';
    handles.D_beta_prior.Enable                  ='off';
    handles.mu_alpha.Enable                      ='off';
    handles.mu_beta.Enable                       ='off';
    handles.Number_particles.Enable              ='off';
    handles.alpha_load.Enable                    ='off';
    handles.concen_radious.Enable                ='off';
    handles.mu_prior_xy.Enable                   ='off';
    handles.mu_prior_z.Enable                    ='off';
    handles.var_prior_xy.Enable                  ='off';
    handles.var_prior_z.Enable                   ='off';
    
    
     
    load('results.mat');
   
    Data.Save_on_off=handles.checkbox9.Value;
    
    answer={};

    opts.Interpreter = 'tex';
    answer = inputdlg({'Number of extra iterations'},...
                        'Please consider the Running time!',...
                        [1 60],{num2str(length(Data.D)-1)},opts);
                    
  if length(answer)==1
     while isempty(str2num(answer{1})) || str2num(answer{1})==0
           opts.Interpreter = 'tex';
           answer = inputdlg({'Number of extra iterations'},...
                              'Please choose a number greater than 0!',...
                              [1 60],{num2str(length(Data.D)-1)},opts);
     end
    
    
     handles.edit39.String = num2str(length(Data.D)-1+str2num(answer{1}));

     for k=1:length(Data.Trace_partial)
         sign_siz(k)   = length(Data.Trace_partial{k})   ; 
     end

     Data.percentage_dif = str2num(handles.edit52.String);
     Data.save_size =str2num(handles.edit41.String);
     Data.iter_b_mu =10;
     
     if   Data.Model_type==1
         [ Data ] = Gibbs_sampler_multi_focuses_inter_arrival_photons( Data , str2num(answer{1}) , handles , 1 );
     
         if  Data.single_confocal==false
                for k=1:length(Data.Trace_partial)
                    timing=cumsum(Data.Trace_partial{k}(1,:));
                    
                    burn_in=floor(size(Data.b,1)*40/100);
                    HJ=histcounts(sum(Data.b(burn_in:end,(k-1)*Data.Number_molecules+1:k*Data.Number_molecules),2),1:1:Data.Number_molecules+1);
                    max_num_active(k)=min(find(HJ==max(HJ)));
                    
                    for  hh=1:Data.Number_molecules
                         molecules(k,hh)=sum(Data.b(:,(k-1)*Data.Number_molecules+hh));
                    end
    
    
                    [~,AB]=sort(molecules(k,:),'descend');
                    Active_molecules=AB(1:max_num_active(k));
                    

                    begin_of=1;

                    ell    = char(hex2dec(strsplit('2113')));
                    learned=[];
                    learned_25=[];
                    learned_75=[];

                    numpa=Active_molecules;

                    for numpar=numpa
                        learned(1,:)=quantile(reshape(Data.x{k}(3*numpar-2,:,begin_of:end),...
                        size(Data.x{k}(1,:,begin_of:end),2),size(Data.x{k}(1,:,begin_of:end),3))',0.5);
                        learned(2,:)=quantile(reshape(Data.x{k}(3*numpar-1,:,begin_of:end),...
                        size(Data.x{k}(1,:,begin_of:end),2),size(Data.x{k}(1,:,begin_of:end),3))',0.5);
                        learned(3,:)=quantile(reshape(Data.x{k}(3*numpar  ,:,begin_of:end),...
                        size(Data.x{k}(1,:,begin_of:end),2),size(Data.x{k}(1,:,begin_of:end),3))',0.5);

                        learned_25(1,:)=quantile(reshape(Data.x{k}(3*numpar-2,:,begin_of:end),...
                        size(Data.x{k}(1,:,begin_of:end),2),size(Data.x{k}(1,:,begin_of:end),3))',0.025);
                        learned_25(2,:)=quantile(reshape(Data.x{k}(3*numpar-1,:,begin_of:end),...
                        size(Data.x{k}(1,:,begin_of:end),2),size(Data.x{k}(1,:,begin_of:end),3))',0.025);
                        learned_25(3,:)=quantile(reshape(Data.x{k}(3*numpar  ,:,begin_of:end),...
                        size(Data.x{k}(1,:,begin_of:end),2),size(Data.x{k}(1,:,begin_of:end),3))',0.025);

                        learned_75(1,:)=quantile(reshape(Data.x{k}(3*numpar-2,:,begin_of:end),...
                        size(Data.x{k}(1,:,begin_of:end),2),size(Data.x{k}(1,:,begin_of:end),3))',0.975);
                        learned_75(2,:)=quantile(reshape(Data.x{k}(3*numpar-1,:,begin_of:end),...
                        size(Data.x{k}(1,:,begin_of:end),2),size(Data.x{k}(1,:,begin_of:end),3))',0.975);
                        learned_75(3,:)=quantile(reshape(Data.x{k}(3*numpar  ,:,begin_of:end),...
                        size(Data.x{k}(1,:,begin_of:end),2),size(Data.x{k}(1,:,begin_of:end),3))',0.975);
                    
                    
                        plot(handles.axes28,timing,learned(1,:),'b')
                        hold(handles.axes28,'on')
                        plot(handles.axes28,timing,learned_25(1,:),'m')
                        plot(handles.axes28,timing,learned_75(1,:),'m')
                        
                        plot(handles.axes31,timing,learned(2,:),'b')
                        hold(handles.axes31,'on')
                        plot(handles.axes31,timing,learned_25(2,:),'m')
                        plot(handles.axes31,timing,learned_75(2,:),'m')
                        
                        plot(handles.axes32,timing,learned(3,:),'b')
                        hold(handles.axes32,'on')
                        plot(handles.axes32,timing,learned_25(3,:),'m')
                        plot(handles.axes32,timing,learned_75(3,:),'m')
                    end
                    
                    if isfield(Data,'X')
                       for mm=1:size(Data.X,1)
                           plot(handles.axes28,timing,Data.X_partial{k}(mm,:),'g')
                           plot(handles.axes31,timing,Data.Y_partial{k}(mm,:),'g')
                           plot(handles.axes32,timing,Data.Z_partial{k}(mm,:),'g')      
                           
                           ylim(handles.axes28,[-Data.Lxyz(1) Data.Lxyz(1)])
                           ylim(handles.axes31,[-Data.Lxyz(2) Data.Lxyz(2)])
                           ylim(handles.axes32,[-Data.Lxyz(3) Data.Lxyz(3)])
                        end
                    end
                end
                hold(handles.axes28,'off')
                hold(handles.axes31,'off')
                hold(handles.axes32,'off')
                
                handles.axes28.XTick = [];
                handles.axes31.XTick = [];
             
                xlabel(handles.axes32,'Time')
             
                ylabel(handles.axes28,'X (\mum)')
                ylabel(handles.axes31,'Y (\mum)')
                ylabel(handles.axes32,'Z (\mum)')
             
                xlim(handles.axes28,[min(timing) max(timing)])
                xlim(handles.axes31,[min(timing) max(timing)])
                xlim(handles.axes32,[min(timing) max(timing)])
         end
         
     else
         [ Data ] = Gibbs_sampler_binned_single_focus_confocal_volume( Data , str2num(answer{1}) , handles , 1   , sign_siz  );
     end
  
     save('results' , 'Data' ,'-v7.3','-nocompression')
      
      
      
      
     for jj=1:length(Data.Wxyz(1,:))
         plot(handles.axes16,1:1:str2num(handles.edit39.String)+1,Data.mu(:,jj),'color',[0, 0.4470, 0.7410])
         hold(handles.axes16,'on')
         histogram(handles.axes20,Data.mu(:,jj),'Normalization','pdf',...
             'Orientation','horizontal','facecolor',[0, 0.4470, 0.7410])
         hold(handles.axes20,'on')
         plot(handles.axes26,1:1:str2num(handles.edit39.String)+1,Data.mu_back(:,jj),'color',[0, 0.4470, 0.7410])
         hold(handles.axes26,'on')
         histogram(handles.axes27,Data.mu_back(:,jj),'Normalization','pdf',...
             'Orientation','horizontal','facecolor',[0, 0.4470, 0.7410])
         hold(handles.axes27,'on')
     end
     hold(handles.axes16,'off')
     hold(handles.axes20,'off')
     hold(handles.axes26,'off')
     hold(handles.axes27,'off')
     
     ylabel(handles.axes16,{'Molecular brightness';'(photons/s)'})
     xlabel(handles.axes16,'Iteration')
     xlim(handles.axes16,[0 str2num(handles.edit39.String)+1])
          
     handles.axes20.YTick = [];
     handles.axes20.XTick = [];
     handles.axes20.XAxisLocation = 'top';
     ylim(handles.axes20,[0 max(max(Data.mu))])
                 
     ylabel(handles.axes26,{'Background photon';'emission rates';'(photons/s)'})
     xlabel(handles.axes26,'Iteration')
     xlim(handles.axes26,[0 str2num(handles.edit39.String)+1])
     
     handles.axes27.YTick = [];
     handles.axes27.XTick = [];
     handles.axes27.XAxisLocation = 'top';
     ylim(handles.axes27,[0 max(max(Data.mu_back))])
    
             
     plot(handles.axes8,1:1:str2num(handles.edit39.String)+1,Data.D)
     xlabel(handles.axes8,['Iteration'])
     ylabel(handles.axes8,'Diff. coeff. (\mum^2/s)')
     xlim(handles.axes8,[0 str2num(handles.edit39.String)+1])
     ylim(handles.axes8,[0 max(Data.D)])
     set(handles.axes8,'yscale','log') 
    
    for k=1:length(Data.Trace_partial)
        plot(handles.axes15,1:1:str2num(handles.edit39.String)+1,...
        sum(Data.b(:,(k-1)*str2num(handles.Number_particles.String)+1:k*str2num(handles.Number_particles.String)),2))
        hold (handles.axes15,'on')
        
        histogram(handles.axes18,...
        sum(Data.b(:,(k-1)*str2num(handles.Number_particles.String)+1:k*str2num(handles.Number_particles.String)),2),...
                       'Normalization','Probability','Orientation','horizontal')
        hold (handles.axes18,'on')
    end
    hold (handles.axes15,'off')
    xlabel(handles.axes15,['Iteration'])
    ylabel(handles.axes15,'Number of active molecules')
    ylim(handles.axes15,[0 str2num(handles.Number_particles.String)])
    xlim(handles.axes15,[0 str2num(handles.edit39.String)+1])
    
    hold (handles.axes18,'off')
    handles.axes18.YTick = [];
    handles.axes18.XTick = [];
    handles.axes18.XAxisLocation = 'top';
    ylim(handles.axes18,[0 str2num(handles.Number_particles.String)])
    
    
    bnd = logspace(log10(min(Data.D))-1,log10(max(Data.D))+1,100);
    
    histogram(handles.axes19,Data.D,bnd,'Normalization','pdf','Orientation','horizontal')
    handles.axes19.XAxisLocation = 'top';
    ylim(handles.axes19,[0 max(Data.D)])
    handles.axes19.YTick = [];
    handles.axes19.XTick = [];
    handles.axes19.YAxisLocation = 'right';
    set(handles.axes19,'yscale','log') 
    
    
    
    
    
    
    
    
    
    
    
    
    drawnow
    
    handles.pushbutton8.Enable                   ='on';
    handles.pushbutton10.Enable                  ='on';
    handles.pushbutton17.Enable                  ='on';
    handles.pushbutton11.Enable                  ='on';
    handles.pushbutton16.Enable                  ='on';
    handles.pushbutton20.Enable                  ='on';
    handles.pushbutton22.Enable                  ='on';
    handles.edit46.Enable                        ='on';
    handles.edit47.Enable                        ='on';
    handles.pushbutton23.Enable                  ='on';
    handles.pushbutton29.Enable                  ='on';
    handles.pushbutton30.Enable                  ='on';
    handles.pushbutton31.Enable                  ='on';
    handles.pushbutton32.Enable                  ='on';
    handles.pushbutton33.Enable                  ='on';
    
    handles.checkbox1.Enable                     ='on';
    handles.checkbox2.Enable                     ='on';
    handles.checkbox3.Enable                     ='on';
    handles.checkbox4.Enable                     ='on';
    handles.checkbox7.Enable                     ='on';
    handles.checkbox8.Enable                     ='on';
    handles.checkbox9.Enable                     ='on';
    handles.Generate_Synthetic_signal.Enable     ='on';
    handles.Measure_Background.Enable            ='on';
    handles.Import_signal.Enable                 ='on';
    
    handles.edit35.Enable                        ='on';
    handles.edit36.Enable                        ='on';
    handles.edit39.Enable                        ='on';
    handles.edit40.Enable                        ='on';
    handles.edit41.Enable                        ='on';
    handles.edit44.Enable                        ='on';
    handles.edit53.Enable                        ='on';
    handles.edit46.Enable                        ='on';
    handles.edit47.Enable                        ='on';
    handles.edit48.Enable                        ='on';
    handles.D_alpha_prior.Enable                 ='on';
    handles.D_beta_prior.Enable                  ='on';
    handles.mu_alpha.Enable                      ='on';
    handles.mu_beta.Enable                       ='on';
    handles.Number_particles.Enable              ='on';
    handles.alpha_load.Enable                    ='on';
    handles.concen_radious.Enable                ='on';
    handles.mu_prior_xy.Enable                   ='on';
    handles.mu_prior_z.Enable                    ='on';
    handles.var_prior_xy.Enable                  ='on';
    handles.var_prior_z.Enable                   ='on';
    else
        
    handles.pushbutton8.Enable                   ='on';
    handles.pushbutton10.Enable                  ='on';
    handles.pushbutton17.Enable                  ='on';
    handles.pushbutton11.Enable                  ='on';
    handles.pushbutton16.Enable                  ='on';
    handles.pushbutton20.Enable                  ='on';
    handles.pushbutton22.Enable                  ='on';
    handles.edit46.Enable                        ='on';
    handles.edit47.Enable                        ='on';
    handles.pushbutton23.Enable                  ='on';
    handles.pushbutton29.Enable                  ='on';
    handles.pushbutton30.Enable                  ='on';
    handles.pushbutton31.Enable                  ='on';
    handles.pushbutton32.Enable                  ='on';
    handles.pushbutton33.Enable                  ='on';
    
    handles.checkbox1.Enable                     ='on';
    handles.checkbox2.Enable                     ='on';
    handles.checkbox3.Enable                     ='on';
    handles.checkbox4.Enable                     ='on';
    handles.checkbox7.Enable                     ='on';
    handles.checkbox8.Enable                     ='on';
    handles.checkbox9.Enable                     ='on';
    
    handles.Generate_Synthetic_signal.Enable     ='on';
    handles.Measure_Background.Enable            ='on';
    handles.Import_signal.Enable                 ='on';
    
    handles.edit35.Enable                        ='on';
    handles.edit36.Enable                        ='on';
    handles.edit39.Enable                        ='on';
    handles.edit40.Enable                        ='on';
    handles.edit41.Enable                        ='on';
    handles.edit44.Enable                        ='on';
    handles.edit53.Enable                        ='on';
    handles.edit46.Enable                        ='on';
    handles.edit47.Enable                        ='on';
    handles.edit48.Enable                        ='on';
    handles.D_alpha_prior.Enable                 ='on';
    handles.D_beta_prior.Enable                  ='on';
    handles.mu_alpha.Enable                      ='on';
    handles.mu_beta.Enable                       ='on';
    handles.Number_particles.Enable              ='on';
    handles.alpha_load.Enable                    ='on';
    handles.concen_radious.Enable                ='on';
    handles.mu_prior_xy.Enable                   ='on';
    handles.mu_prior_z.Enable                    ='on';
    handles.var_prior_xy.Enable                  ='on';
    handles.var_prior_z.Enable                   ='on';    
        
    end


function var_prior_z_Callback(hObject, eventdata, handles)
% hObject    handle to var_prior_z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of var_prior_z as text
%        str2double(get(hObject,'String')) returns contents of var_prior_z as a double


% --- Executes during object creation, after setting all properties.
function var_prior_z_CreateFcn(hObject, eventdata, handles)
% hObject    handle to var_prior_z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in concen_radious.
function concen_radious_Callback(hObject, eventdata, handles)
% hObject    handle to concen_radious (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns concen_radious contents as cell array
%        contents{get(hObject,'Value')} returns selected item from concen_radious


% --- Executes during object creation, after setting all properties.
function concen_radious_CreateFcn(hObject, eventdata, handles)
% hObject    handle to concen_radious (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



    
    
    
function edit47_Callback(hObject, eventdata, handles)
% hObject    handle to edit47 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit47 as text
%        str2double(get(hObject,'String')) returns contents of edit47 as a double


% --- Executes during object creation, after setting all properties.
function edit47_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit47 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit46_Callback(hObject, eventdata, handles)
% hObject    handle to edit46 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit46 as text
%        str2double(get(hObject,'String')) returns contents of edit46 as a double


% --- Executes during object creation, after setting all properties.
function edit46_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit46 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox7.
function checkbox7_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox7



function edit48_Callback(hObject, eventdata, handles)
% hObject    handle to edit48 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit48 as text
%        str2double(get(hObject,'String')) returns contents of edit48 as a double


% --- Executes during object creation, after setting all properties.
function edit48_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit48 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton23.
function pushbutton23_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


    
    handles.checkbox1.Enable                     ='off';
    handles.checkbox2.Enable                     ='off';
    handles.checkbox3.Enable                     ='off';
    handles.checkbox4.Enable                     ='off';
    
    
    handles.pushbutton11.Enable                  ='off';
    handles.pushbutton16.Enable                  ='off';
    
    handles.pushbutton20.Enable                  ='off';
     
    handles.pushbutton23.Enable                  ='off';
    handles.pushbutton24.Enable                  ='off';
    handles.pushbutton25.Enable                  ='off';
    handles.pushbutton26.Enable                  ='off';
    
    load('results.mat');
    
   if  Data.Automatic  == 1
       Data.Automatic =0;
       handles.pushbutton23.String                  =    'Automatic (OFF)' ;
       handles.edit39.Enable                        =    'on'              ;
       handles.edit41.Enable                        =    'on'              ;
       handles.pushbutton8.Enable                   =    'off'             ;
       handles.pushbutton17.Enable                  =    'on'              ;
       handles.edit52.Enable                        =    'off'             ;

   else
      
    choice = questdlg({['Automatic process will follows the convergence to ',...
                       'the stationary distribution of the diffusion coefficient. '...
                       'Computational time in this mode depends on many factors. '...
                       'So, this process could take ',...
                       'a while, depends on the imported signal. For the '...
                       'safty, results of the MCMC chain will save and show '...
                       'after every 10000 iterations. If you still want to '...
                       'continue, choose YES and click on the start button']},...
                       'Warning!','Yes','No','Yes');
    
    if  strcmp(choice,'Yes')
        handles.pushbutton8.String                   =    'Start'           ;
        Data.Automatic =1;
        handles.pushbutton23.String                  =    'Automatic (ON)'   ;
        handles.edit39.Enable                        =    'off'             ;
        handles.edit41.Enable                        =    'off'             ;
        handles.pushbutton8.Enable                   =    'on'              ;
        handles.pushbutton17.Enable                  =    'off'             ;
        handles.edit52.Enable                        =    'on'              ;
    else
        handles.edit39.Enable                        =    'on'              ;
        handles.edit41.Enable                        =    'on'              ;
        handles.pushbutton8.Enable                   =    'off'             ;
        handles.pushbutton17.Enable                  =    'on'              ;
        handles.edit52.Enable                        =    'off'             ;
        handles.edit46.Enable                        =    'on'             ;
        handles.edit47.Enable                        =    'on'             ;
        handles.edit48.Enable                        =    'on'             ;
    end 
    
   end


    handles.edit35.Enable                        ='on';
    handles.edit36.Enable                        ='on';
    handles.edit40.Enable                        ='on';
    handles.edit48.Enable                        ='on';
    handles.pushbutton10.Enable                  ='on';
    handles.pushbutton22.Enable                  ='on';
    handles.pushbutton23.Enable                  ='on';
    handles.pushbutton24.Enable                  ='on';
    handles.pushbutton25.Enable                  ='on';
    handles.pushbutton26.Enable                  ='on';
    
    handles.D_alpha_prior.Enable                 ='on';
    
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Initial vslues %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     
     len = length(Data.Trace_partial)                                     ;
     for k=1:len
         sign_siz(k)  = length(Data.Trace_partial{k})                    ; 
         Data.x{k}    = zeros(3*str2num(handles.Number_particles.String),sign_siz(k))+.1  ;
     end
     
     
     iter_b_mu        = 20         ;
     
     Data.D           = 1/gamrnd(str2num(handles.D_alpha_prior.String),str2num(handles.D_beta_prior.String)) ;
     Data.mu          = gamrnd(str2num(handles.mu_alpha.String),str2num(handles.mu_alpha.String),length(Data.Wxyz(1,:)),1);
     Data.mu_back     = gamrnd(str2num(handles.edit46.String),str2num(handles.edit47.String),length(Data.Wxyz(1,:)),1);
     
     
     Data.gamma_b     =  str2num(handles.alpha_load.String);
     Data.Q           =  1/(1+(str2num(handles.Number_particles.String)-1)/Data.gamma_b);

     Data.b           = rand(len,str2num(handles.Number_particles.String),1)<Q                              ;
     
     Data.concentration = zeros(len , 1000 ,max(sign_siz) , length(str2num(handles.concen_radious.String)) ) ;

   save('results','Data','-v7.3','-nocompression')
    
    
    


% --- Executes on button press in checkbox8.
function checkbox8_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox8


% --- Executes on button press in pushbutton25.
function pushbutton25_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton24.
function pushbutton24_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton26.
function pushbutton26_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





function edit51_Callback(hObject, eventdata, handles)
% hObject    handle to edit51 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit51 as text
%        str2double(get(hObject,'String')) returns contents of edit51 as a double


% --- Executes during object creation, after setting all properties.
function edit51_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit51 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit52_Callback(hObject, eventdata, handles)
% hObject    handle to edit52 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit52 as text
%        str2double(get(hObject,'String')) returns contents of edit52 as a double


% --- Executes during object creation, after setting all properties.
function edit52_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit52 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton29.
function pushbutton29_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    load('results.mat');
    
    trace_bin           = Data.Trace   ;
    
    
    minn = str2num(get(handles.edit35,'String')) ;
    maxx = str2num(get(handles.edit36,'String')) ;
    
    
     while isempty(maxx-minn) || maxx-minn<=0 || maxx<=0 || minn<=0 || maxx>length(trace_bin)

              opts.Interpreter = 'tex';
              answer = inputdlg({'Minimum Time step','Maximum Time step'},...
                       'Please choose reasonable vlues!',[1 60;1 60],...
                       {'1',num2str(length(Data.Trace))},opts);
                   
              minn = str2num(answer{1}) ;
              maxx = str2num(answer{2}) ;
    end

    handles.edit35.String  = num2str(minn);
    handles.edit36.String  = num2str(maxx);

    
    if  sum(str2num(char(handles.uitable5.Data)))==0
        Data.Trace_partial            = {Data.Trace(:,minn:maxx)}      ;
        if  length(str2num(handles.Diff_synth.String))>0
            Data.X_partial            = {Data.X(:,minn:maxx)}          ;
            Data.Y_partial            = {Data.Y(:,minn:maxx)}          ;
            Data.Z_partial            = {Data.Z(:,minn:maxx)}          ;
        end
        Data.minn                     = {minn}                         ;
        Data.maxx                     = {maxx}                         ;
           
        Size_signal                   = length(Data.Trace_partial)     ;
    else
        Size_signal                   = length(Data.Trace_partial)     ;
        partial                       = Data.Trace_partial             ;
        partial{Size_signal+1}        = Data.Trace(:,minn:maxx)        ;
        Data.Trace_partial            = partial                        ;
        if  length(str2num(handles.Diff_synth.String))>0
            X_partial                 = Data.X_partial                 ;
            Y_partial                 = Data.Y_partial                 ;
            Z_partial                 = Data.Z_partial                 ;
            X_partial{Size_signal+1}  = Data.X(:,minn:maxx)            ;
            Y_partial{Size_signal+1}  = Data.Y(:,minn:maxx)            ;
            Z_partial{Size_signal+1}  = Data.Z(:,minn:maxx)            ;
            Data.X                    = X_partial                      ;
            Data.Y                    = Y_partial                      ;
            Data.Z                    = Z_partial                      ;
        end
        MINIMUM_part                  = Data.minn                      ;
        MAXIMUM_part                  = Data.maxx                      ;
        MINIMUM_part{Size_signal+1}   = minn                           ;
        MAXIMUM_part{Size_signal+1}   = maxx                           ;
        
        Data.maxx                     = MINIMUM_part                   ;
        Data.minn                     = MAXIMUM_part                   ;
        Size_signal                   = length(Data.Trace_partial)     ;
    end
    
    handles.uitable5.Data{Size_signal,1} = num2str(minn);
    handles.uitable5.Data{Size_signal,2} = num2str(maxx);


    save('results','Data','-v7.3','-nocompression')

    if  length(Data.Trace_partial)>0
        handles.pushbutton23.Enable      = 'on';
        handles.pushbutton17.Enable      = 'on';
        handles.pushbutton30.Enable      = 'on';
        handles.D_alpha_prior.Enable     = 'on';
        handles.D_beta_prior.Enable      = 'on';
        handles.mu_alpha.Enable          = 'on';
        handles.mu_beta.Enable           = 'on';
        handles.edit46.Enable            = 'on';
        handles.edit47.Enable            = 'on';
        handles.Number_particles.Enable  = 'on';
        handles.alpha_load.Enable        = 'on';
        handles.mu_prior_xy.Enable       = 'on';
        handles.mu_prior_z.Enable        = 'on';
        handles.var_prior_xy.Enable      = 'on';
        handles.var_prior_z.Enable       = 'on';
        handles.edit39.Enable            = 'on';
        handles.edit40.Enable            = 'on';
        handles.edit41.Enable            = 'on';
        handles.edit48.Enable            = 'on';
        
        if length(Data.Wxyz(1,:))==1
            handles.concen_radious.Enable = 'on';
        end
    else
        handles.pushbutton23.Enable      = 'off';
        handles.pushbutton17.Enable      = 'off';
        handles.pushbutton30.Enable      = 'off';
        handles.D_alpha_prior.Enable     = 'off';
        handles.D_beta_prior.Enable      = 'off';
        handles.mu_alpha.Enable          = 'off';
        handles.mu_beta.Enable           = 'off';
        handles.edit46.Enable            = 'off';
        handles.edit47.Enable            = 'off';
        handles.Number_particles.Enable  = 'off';
        handles.alpha_load.Enable        = 'off';
        handles.mu_prior_xy.Enable       = 'off';
        handles.mu_prior_z.Enable        = 'off';
        handles.var_prior_xy.Enable      = 'off';
        handles.var_prior_z.Enable       = 'off';
        handles.edit39.Enable            = 'off';
        handles.edit40.Enable            = 'off';
        handles.edit41.Enable            = 'off';
        handles.edit48.Enable            = 'off';
    end

    
    
    

% --- Executes on button press in pushbutton30.
function pushbutton30_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    load('results.mat');

    num_signals=length(Data.Trace_partial);

    opts.Interpreter = 'tex';
    answer = inputdlg({'Which trace you wish to delete?'},...
                       'Delete trace',[1 60],...
                       {''},opts);
  
    while sum(find(str2num(answer{1})==[1:num_signals]))==0
          
          opts.Interpreter = 'tex';
          answer = inputdlg({['Please choose values between 1 to ',num2str(num_signals)]},...
                       'Delete trace',[1 60],...
                       {''},opts);
    end
    
    Data.Trace_partial(str2num(answer{1}))      = []          ;
    handles.uitable5.Data(str2num(answer{1}),:) = []          ;
    if  length(str2num(handles.Diff_synth.String))>0
        Data.X_partial(str2num(answer{1}))      = []          ;
        Data.Y_partial(str2num(answer{1}))      = []          ;
        Data.Z_partial(str2num(answer{1}))      = []          ;
    end
    Data.minn(str2num(answer{1}))               = []          ;
    Data.maxx(str2num(answer{1}))               = []          ;
    
    if   sum(cell2mat(handles.uitable5.Data))==0
        
        handles.pushbutton8.Enable       = 'off';
        handles.pushbutton20.Enable      = 'off';
        handles.pushbutton23.Enable      = 'off';
        handles.pushbutton17.Enable      = 'off';
        handles.pushbutton30.Enable      = 'off';
        handles.D_alpha_prior.Enable     = 'off';
        handles.D_beta_prior.Enable      = 'off';
        handles.mu_alpha.Enable          = 'off';
        handles.mu_beta.Enable           = 'off';
        handles.edit46.Enable            = 'off';
        handles.edit47.Enable            = 'off';
        handles.Number_particles.Enable  = 'off';
        handles.alpha_load.Enable        = 'off';
        handles.mu_prior_xy.Enable       = 'off';
        handles.mu_prior_z.Enable        = 'off';
        handles.var_prior_xy.Enable      = 'off';
        handles.var_prior_z.Enable       = 'off';
        handles.edit39.Enable            = 'off';
        handles.edit40.Enable            = 'off';
        handles.edit41.Enable            = 'off';
        handles.edit48.Enable            = 'off';
        handles.concen_radious.Enable    = 'off';
        handles.checkbox9.Enable         = 'off';
    end
        
    save('results','Data','-v7.3','-nocompression')



% --- Executes on button press in pushbutton32.
function pushbutton32_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hFig = figure('Menubar','none', 'Toolbar','none','numbertitle','off','name','MCT README');
set(hFig,'Units','Characters','Position',get(hFig,'Position').*[1 1 0 0.12]+[0 0 80 0]);
uicontrol(hFig, 'Style','edit',...
    'Min',0, 'Max',2, 'HorizontalAlignment','left', ...
    'Units','normalized', 'Position',[0 0 1 1], ...
    'String',fileread('README.txt'));
movegui(hFig,'center');



function edit53_Callback(hObject, eventdata, handles)
% hObject    handle to edit53 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit53 as text
%        str2double(get(hObject,'String')) returns contents of edit53 as a double


% --- Executes during object creation, after setting all properties.
function edit53_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit53 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton33.
function pushbutton33_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
open('Help.pdf')

% --- Executes when figure1 is resized.
function figure1_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit65_Callback(hObject, eventdata, handles)
% hObject    handle to edit65 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit65 as text
%        str2double(get(hObject,'String')) returns contents of edit65 as a double


% --- Executes during object creation, after setting all properties.
function edit65_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit65 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit66_Callback(hObject, eventdata, handles)
% hObject    handle to edit66 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit66 as text
%        str2double(get(hObject,'String')) returns contents of edit66 as a double


% --- Executes during object creation, after setting all properties.
function edit66_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit66 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit67_Callback(hObject, eventdata, handles)
% hObject    handle to edit67 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit67 as text
%        str2double(get(hObject,'String')) returns contents of edit67 as a double


% --- Executes during object creation, after setting all properties.
function edit67_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit67 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function wy_Callback(hObject, eventdata, handles)
% hObject    handle to wy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of wy as text
%        str2double(get(hObject,'String')) returns contents of wy as a double


% --- Executes during object creation, after setting all properties.
function wy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox9.
function checkbox9_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox9
