!-----------------------------------------------------------------------
! PoCEquates.inc - Include for Container PoC equates
!-----------------------------------------------------------------------
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
! Adapted from ClarionHub post by Brahn Partridge (1977–2021) 
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

  OMIT('_EndOfInclude', _PoCEquatesPresent_)
_PoCEquatesPresent_ EQUATE(1)

!----------------------------
! Windows API equates
!----------------------------
HANDLE                EQUATE(UNSIGNED)
DWORD                 EQUATE(ULONG)
BOOL                  EQUATE(BYTE)
VOID                  EQUATE(LONG)
LPVOID                EQUATE(ULONG)
LPDWORD               EQUATE(ULONG)
ATTACH_PARENT_PROCESS EQUATE(-1)
STD_OUTPUT_HANDLE     EQUATE(-11)

!----------------------------
! Time equates
!----------------------------
ONEDAY    EQUATE(8640000)   !Hundredths of seconds in one day
ONEHOUR   EQUATE(360000)    !Hundredths of seconds in one hour
ONEMINUTE EQUATE(6000)      !Hundredths of seconds in one minute
ONESECOND EQUATE(100)       !Hundredths of seconds in one second
MIDNIGHT  EQUATE(1)         !Midnight in Clarion standard time

SECONDSPERDAY EQUATE(86400) !Number of seconds per day = ONEDAY / ONESECOND
MINUTESPERDAY EQUATE(1440)  !Number of minutes per day = ONEDAY / ONEMINUTE
HOURSPERDAY   EQUATE(24)      !Number of hours per day = ONEDAY / ONEHOUR

!----------------------------
! Date equates
!----------------------------
EPOCH     EQUATE(61730) !Unix Epoch in Clarion standard date form = DATE(1,1,1970)

_EndOfInclude_