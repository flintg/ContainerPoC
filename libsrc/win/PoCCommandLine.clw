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
! Adapted from ClarionHub post by brahn: 
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

                     MEMBER()
                     
INCLUDE('PoCCommandLine.inc'), ONCE

                     MAP
  MODULE('API')
    PoCAttach(DWORD dwProcessId),BYTE,PASCAL,RAW,NAME('AttachConsole')
    PoCAlloc(),BYTE,PASCAL,RAW,NAME('AllocConsole')
    PoCFree(),BYTE,PROC,PASCAL,RAW,NAME('FreeConsole')
    PoCGet(DWORD nStdHandle),LONG,PASCAL,RAW,NAME('GetStdHandle')
    PoCWrite(HANDLE hConsoleOutput, VOID lpBuffer, DWORD nNumberOfCharsToWrite, *LPDWORD lpNumberOfCharsWritten, LPVOID lpReserved),BYTE,PROC,PASCAL,RAW,NAME('WriteConsoleA')
    PoCError(),LONG,PASCAL,NAME('GetLastError')
    PoCFormatMessage(DWORD,LONG,DWORD,DWORD,*CSTRING,DWORD,LONG),DWORD,PASCAL,RAW,NAME('FormatMessageA')
  END
                     END


!-----------------------------------------------------------------------
!!!<summary>Class constructor</summary>
!-----------------------------------------------------------------------
PoCCommandLine.Construct      PROCEDURE()!
curLastError DWORD
curFormattedError CSTRING(256)
  CODE
  SELF.ClassName = 'PoCCommandLine'
  IF PoCAttach(ATTACH_PARENT_PROCESS) <> 0
    MESSAGE('Attach succeeded')
    SELF.ActiveConsole = PoCGet(STD_OUTPUT_HANDLE)
  ELSE
    curLastError = PoCError()
    R# = PoCFormatMessage(FORMAT_MESSAGE_FROM_SYSTEM + FORMAT_MESSAGE_IGNORE_INSERTS, 0, curLastError, 0, curFormattedError, size(curFormattedError)-1, 0)
    MESSAGE('Could not attach to console: ' & curFormattedError)
  END

!-----------------------------------------------------------------------
!!!<summary>Class destructor</summary>
!-----------------------------------------------------------------------
PoCCommandLine.Destruct       PROCEDURE()!
  CODE
  IF SELF.ActiveConsole
    PoCFree()
  END
!-----------------------------------------------------------------------
!!!<summary>Write text to StdOut</summary>
!!!<param name="pMessage">Test to write to StdOut</param>
!-----------------------------------------------------------------------
PoCCommandLine.WriteLine      PROCEDURE(STRING pMessage)!,ULONG,PROC
curLen    LPDWORD
curBufStr CSTRING(LEN(pMessage)+2)
  CODE
  curBufStr = pMessage & '<10><0>'
  IF SELF.ActiveConsole
    PoCWrite(SELF.ActiveConsole,ADDRESS(curBufStr),LEN(curBufStr),curLen,0)
    MESSAGE('Did we get a message?')
  ELSE
    MESSAGE('No handle')
  END
  RETURN curLen