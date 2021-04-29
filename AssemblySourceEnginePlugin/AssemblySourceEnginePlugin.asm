; -------------------------------------------------------------------------
; Name: AssemblySourceEnginePlugin
; Description: Assembly version of VSP.
; Author: Ren
; URL: https://steamcommunity.com/id/RenXR/
; -------------------------------------------------------------------------

; General defines
.386					; Set processor model
.model flat, syscall	; Sets the calling and naming conventions
option casemap: none	; Always use the case sensitive option

; Includes
include \masm32\include\kernel32.inc
includelib \masm32\lib\kernel32.lib

; Public procedures
public CreateInterface

; Defines
TRUE = 1
FALSE = 0
NULL = 0

DLL_PROCESS_ATTACH = 1
DLL_THREAD_ATTACH = 2
DLL_THREAD_DETACH = 3
DLL_PROCESS_DETACH = 0

PLUGIN_CONTINUE = 0
PLUGIN_OVERRIDE = 1
PLUGIN_STOP = 2

; Data
.data
	; Plugin description
	PluginDescription db "Assembly VSP by Ren (STEAM_0:0:176325977)",00h

	; Named version of the plugin interface
	PluginInterfaceName db "ISERVERPLUGINCALLBACKS003",00h

	; InterfaceReg structure
	InterfaceReg_s struc
		m_CreateFn dd ?
		m_pName dd ?
		m_pNext dd ?
		s_pInterfaceRegs dd 0
	InterfaceReg_s ends

	; Plugin InterfaceReg variable
	PluginInterfaceReg InterfaceReg_s <offset PluginInterfaceGetter, offset PluginInterfaceName, 0>

	; Plugin class structure
	PluginClass struc
		vfptr dd ?
		m_iClientCommandIndex dd 0
	PluginClass ends

	; Plugin class vtable
	PluginClassVTable	dd PluginVTableLoad
						dd PluginVTableUnload
						dd PluginVTablePause
						dd PluginVTableUnPause
						dd PluginVTableGetPluginDescription
						dd PluginVTableLevelInit
						dd PluginVTableServerActivate
						dd PluginVTableGameFrame
						dd PluginVTableLevelShutdown
						dd PluginVTableClientActive
						dd PluginVTableClientDisconnect
						dd PluginVTableClientPutInServer
						dd PluginVTableSetCommandClient
						dd PluginVTableClientSettingsChanged
						dd PluginVTableClientConnect
						dd PluginVTableClientCommand
						dd PluginVTableNetworkIDValidated
						dd PluginVTableOnQueryCvarValueFinished
						dd PluginVTableOnEdictAllocated
						dd PluginVTableOnEdictFreed
						dd PluginVTableFireGameEvent
						dd PluginVTableGetCommandIndex

	; Plugin class variable
	g_PluginClass PluginClass <offset PluginClassVTable>

.code
	; Dynamic initialization
	DynamicInitialization proc near
		mov eax, PluginInterfaceReg.s_pInterfaceRegs
		mov PluginInterfaceReg.m_pNext, eax
		mov PluginInterfaceReg.s_pInterfaceRegs, offset PluginInterfaceReg
		retn
	DynamicInitialization endp
	; Dynamic finalization
	DynamicFinalization proc near
		retn
	DynamicFinalization endp
	; DllEntryPoint
	DllEntryPoint proc near stdcall hInstDLL:dword, fdwReason:dword, lpReserved:dword
	; Code
		cmp fdwReason, DLL_PROCESS_ATTACH
		je DllEntryPointProcessAttach
		cmp fdwReason, DLL_PROCESS_DETACH
		je DllEntryPointProcessDetach
	DllEntryPointReturn:
		mov eax, TRUE ; put TRUE in EAX to continue loading the DLL
		pop ebp
		retn 0Ch
	DllEntryPointProcessAttach:
		call DynamicInitialization
		jmp DllEntryPointReturn
	DllEntryPointProcessDetach:
		call DynamicFinalization
		jmp DllEntryPointReturn
	DllEntryPoint endp
	; CreateInterface
	CreateInterface proc near export pName:dword, pReturnCode:dword
	; Code
		push esi
		mov esi, PluginInterfaceReg.s_pInterfaceRegs
		push edi
		test esi, esi
		jz short CreateInterfaceLabel7
		mov edi, pName
	CreateInterfaceLabel1:
		mov ecx, [esi+4]
		mov eax, edi
	CreateInterfaceLabel2:
		mov dl, [ecx]
		cmp dl, [eax]
		jnz short CreateInterfaceLabel4
		test dl, dl
		jz short CreateInterfaceLabel3
		mov dl, [ecx+1]
		cmp dl, [eax+1]
		jnz short CreateInterfaceLabel4
		add ecx, 2
		add eax, 2
		test dl, dl
		jnz short CreateInterfaceLabel2
	CreateInterfaceLabel3:
		xor eax, eax
		jmp CreateInterfaceLabel5
	CreateInterfaceLabel4:
		sbb eax, eax
		or eax, 1
	CreateInterfaceLabel5:
		test eax, eax
		jz short CreateInterfaceLabel8
		mov esi, [esi+8]
		test esi, esi
		jnz short CreateInterfaceLabel1
	CreateInterfaceLabel7:
		mov eax, pReturnCode
		test eax, eax
		jz short CreateInterfaceLabel6
		mov dword ptr [eax], 1
	CreateInterfaceLabel6:
		pop edi
		xor eax, eax
		pop esi
		pop ebp
		retn
	CreateInterfaceLabel8:
		mov eax, pReturnCode
		test eax, eax
		jz short CreateInterfaceLabel9
		mov dword ptr [eax], 0
	CreateInterfaceLabel9:
		mov eax, [esi]
		pop edi
		pop esi
		pop ebp
		jmp eax
	CreateInterface endp
	; Plugin interface getter
	PluginInterfaceGetter proc near
		mov eax, offset g_PluginClass
		retn
	PluginInterfaceGetter endp
	; Plugin class VTable procedures
	; Load
	PluginVTableLoad proc near interfaceFactory:dword, gameServerFactory:dword
	; Code
		mov al, 1 ; 0=Unsuccessful; 1=Successful
		pop ebp
		retn 8
	PluginVTableLoad endp
	; Unload
	PluginVTableUnload proc near
		retn
	PluginVTableUnload endp
	; Pause
	PluginVTablePause proc near
		retn
	PluginVTablePause endp
	; UnPause
	PluginVTableUnPause proc near
		retn
	PluginVTableUnPause endp
	; GetPluginDescription
	PluginVTableGetPluginDescription proc near
		mov eax, offset PluginDescription
		retn
	PluginVTableGetPluginDescription endp
	; LevelInit
	PluginVTableLevelInit proc near pMapName:dword
	; Code
		pop ebp
		retn 4
	PluginVTableLevelInit endp
	; ServerActivate
	PluginVTableServerActivate proc near pEdictList:dword, edictCount:dword, clientMax:dword
	; Code
		pop ebp
		retn 0Ch
	PluginVTableServerActivate endp
	; GameFrame
	PluginVTableGameFrame proc near simulating:byte
	; Code
		pop ebp
		retn 4
	PluginVTableGameFrame endp
	; LevelShutdown
	PluginVTableLevelShutdown proc near
		retn
	PluginVTableLevelShutdown endp
	; ClientActive
	PluginVTableClientActive proc near pEntity:dword
	; Code
		pop ebp
		retn 4
	PluginVTableClientActive endp
	; ClientDisconnect
	PluginVTableClientDisconnect proc near pEntity:dword
	; Code
		pop ebp
		retn 4
	PluginVTableClientDisconnect endp
	; ClientPutInServer
	PluginVTableClientPutInServer proc near pEntity:dword, playername:dword
	; Code
		pop ebp
		retn 8
	PluginVTableClientPutInServer endp
	; SetCommandClient
	PluginVTableSetCommandClient proc near index:dword
	; Code
		mov eax, index
		mov (PluginClass ptr [ecx]).m_iClientCommandIndex, eax
		pop ebp
		retn 4
	PluginVTableSetCommandClient endp
	; ClientSettingsChanged
	PluginVTableClientSettingsChanged proc near pEdict:dword
	; Code
		pop ebp
		retn 4
	PluginVTableClientSettingsChanged endp
	; ClientConnect
	PluginVTableClientConnect proc near bAllowConnect:dword, pEntity:dword, pszName:dword, pszAddress:dword, reject:dword, maxrejectlen:dword
	; Code
		xor eax, eax ; Works faster than `mov eax, PLUGIN_CONTINUE`
		pop ebp
		retn 18h
	PluginVTableClientConnect endp
	; ClientCommand
	PluginVTableClientCommand proc near pEntity:dword, args:dword
	; Code
		xor eax, eax ; Works faster than `mov eax, PLUGIN_CONTINUE`
		pop ebp
		retn 8
	PluginVTableClientCommand endp
	; NetworkIDValidated
	PluginVTableNetworkIDValidated proc near pszUserName:dword, pszNetworkID:dword
	; Code
		xor eax, eax ; Works faster than `mov eax, PLUGIN_CONTINUE`
		pop ebp
		retn 8
	PluginVTableNetworkIDValidated endp
	; OnQueryCvarValueFinished
	PluginVTableOnQueryCvarValueFinished proc near iCookie:dword, pPlayerEntity:dword, eStatus:dword, pCvarName:dword, pCvarValue:dword
	; Code
		pop ebp
		retn 14h
	PluginVTableOnQueryCvarValueFinished endp
	; OnEdictAllocated
	PluginVTableOnEdictAllocated proc near edict:dword
	; Code
		pop ebp
		retn 4
	PluginVTableOnEdictAllocated endp
	; OnEdictFreed
	PluginVTableOnEdictFreed proc near edict:dword
	; Code
		pop ebp
		retn 4
	PluginVTableOnEdictFreed endp
	; FireGameEvent
	PluginVTableFireGameEvent proc near edict:dword
	; Code
		pop ebp
		retn 4
	PluginVTableFireGameEvent endp
	; GetCommandIndex
	PluginVTableGetCommandIndex proc near
		mov eax, (PluginClass ptr [ecx]).m_iClientCommandIndex
		retn
	PluginVTableGetCommandIndex endp
end DllEntryPoint