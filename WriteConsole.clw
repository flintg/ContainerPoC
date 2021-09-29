!---------------------------------------------------------------------------------------------------------
! Copyright (C) 2021 AccuFund, Inc. [https://accufund.com]
!---------------------------------------------------------------------------------------------------------
! This software is provided 'as-is', without any express or implied warranty. In no event will the authors 
! be held liable for any damages arising from the use of this software. Permission is granted to anyone to 
! use this software for any purpose, including commercial applications, subject to the following restrictions:
!   1. We reserve ownership of all intellectual property rights inherent in or relating to the provided source code.
!   2. We provide You with source code so that You can create Modifications and Applications. While You retain all 
!      rights to any original work authored by You as part of any Modifications, We continue to own all copyright 
!      and other intellectual property rights in the Software.
!   3. You may not redistribute the Software or Modifications as part of any Application that can be described 
!      as a development toolkit or library. Under no cirnumstances may you use the software for an application
!      that is intended for software or application development.
!   4. The origin of this software must not be misrepresented; you must not claim that you wrote the original software. 
!      If you use this software in a product, an acknowledgment in the product documentation would be appreciated 
!      but is not required.
!   5. This notice may not be removed or altered from any source distribution.
!   6. Any waivers or amendments shall be effective only if made in writing.
!   7. If any provision in this Agreement shall be determined to be invalid, such provision shall be deemed omitted; 
!      the remainder of this Agreement shall continue in full force and effect.
!---------------------------------------------------------------------------------------------------------

!---------------------------------------------------------------------------------------------------------
! Taken from ClarionHub post by brahn: 
!  [https://clarionhub.com/t/using-writeconsolea-from-a-clarion-application/1734]
!
! If compiling in Clarion 9.1:
!  * LIB mode has no additional requirements.
!  * DLL mode requires the Kernel32 entrypoint AttachConsole to be made available by custom .lib, and 
!      included in the project libraries.
!
! If compiling in Clarion 11:
!  * No additional requirements.
!---------------------------------------------------------------------------------------------------------
PROGRAM

!---------------------------------------------------------------------------------------------------------
! Declare some useful equates (some of these could be declared in other equate files under other names)
!---------------------------------------------------------------------------------------------------------
HANDLE    EQUATE(UNSIGNED)
DWORD     EQUATE(ULONG)
BOOL      EQUATE(BYTE)
VOID      EQUATE(LONG)
LPVOID    EQUATE(ULONG)
LPDWORD   EQUATE(ULONG)
ATTACH_PARENT_PROCESS EQUATE(-1)
STD_OUTPUT_HANDLE EQUATE(-11)

!---------------------------------------------------------------------------------------------------------
! Declare local procedures and map Windows APIs
!---------------------------------------------------------------------------------------------------------
  MAP
    MODULE('API')
      AttachConsole(DWORD dwProcessId),BYTE,PASCAL,RAW
      FreeConsole(),BYTE,PROC,PASCAL,RAW
      GetStdHandle(DWORD nStdHandle),LONG,PASCAL,RAW
      WriteConsoleA( |
        HANDLE  hConsoleOutput, |
        VOID    lpBuffer, |
        DWORD   nNumberOfCharsToWrite, |
        *LPDWORD lpNumberOfCharsWritten, |
        LPVOID  lpReserved),BYTE,PASCAL,RAW,PROC
    END
WriteLine PROCEDURE(STRING pMessage)
  END

!---------------------------------------------------------------------------------------------------------
! Declare a simple window with a button to act on the command line
!---------------------------------------------------------------------------------------------------------
Window    WINDOW('Test WriteConsole'),AT(,,101,43),GRAY,FONT('Microsoft Sans Serif',8)
            BUTTON('Write To Stdout'),AT(17,12),USE(?ButtonTest)
          END
  CODE
  
  !---------------------------------------------------------------------------------------------------------
  ! If /Q is present on the command line, just write a message and exit. Do not proceed to opening a window
  !---------------------------------------------------------------------------------------------------------
  IF COMMAND('/q')
    WriteLine('HelloWorld!')
    RETURN
  END
  
!---------------------------------------------------------------------------------------------------------
! Open the window named "Window"
!---------------------------------------------------------------------------------------------------------
  Open(Window)

!---------------------------------------------------------------------------------------------------------
! Initiate the accept loop to listen for events
!---------------------------------------------------------------------------------------------------------
  ACCEPT
    !---------------------------------------------------------------------------------------------------------
    ! When the ButtonTest button is pressed, write "Hi!" to the console
    !---------------------------------------------------------------------------------------------------------
    IF Event() = EVENT:Accepted AND Accepted() = ?ButtonTest
      WriteLine('Hi!')
    END
  END

!---------------------------------------------------------------------------------------------------------
!!!<summary>Writes a string to the console of the parent process</summary>
!!!<param name="pMessage">String to write to the console. Input is not sanitized before sending to the console.</param>
!!!<remarks>Two additional characters are added to the end of the string: 10,0 </remarks>
!---------------------------------------------------------------------------------------------------------
WriteLine PROCEDURE(STRING pMessage)
!---------------------------------------------------------------------------------------------------------
! Declare local variables
!  * conHandle is the handle to the console of the parent process
!  * outLen is the length of the string coming into the procedure, used to determine the length of the CSTRING
!  * bufferStr is a reference to a CSTRING that serves as a buffer that gets written to the console.
!---------------------------------------------------------------------------------------------------------
conHandle   HANDLE
outLen      LPDWORD
bufferStr   &CSTRING
  CODE
  !---------------------------------------------------------------------------------------------------------
  ! Create a new CSTRING to hold the incoming STRING, adding space for two additional characters at the end
  !---------------------------------------------------------------------------------------------------------
  bufferStr &= New(CSTRING(Len(pMessage)+2))
  !---------------------------------------------------------------------------------------------------------
  ! Append the characters 10 (NL or line feed) and 0 (null)
  !---------------------------------------------------------------------------------------------------------
  bufferStr = pMessage & '<10><0>'
  !---------------------------------------------------------------------------------------------------------
  ! Try to attach to the parent process' console
  !---------------------------------------------------------------------------------------------------------
  IF AttachConsole(ATTACH_PARENT_PROCESS)
    !---------------------------------------------------------------------------------------------------------
    ! * Get a handle to StdOut
    ! * Use the handle to write to the console
    ! * Free the console
    !---------------------------------------------------------------------------------------------------------
    conHandle = GetStdHandle(STD_OUTPUT_HANDLE)
    WriteConsoleA(conHandle,Address(bufferStr),LEN(bufferStr),outLen,0)
    FreeConsole()
  END
  !---------------------------------------------------------------------------------------------------------
  ! Dispose of the CSTRING
  !---------------------------------------------------------------------------------------------------------
  Dispose(bufferStr)
  RETURN
