       IDENTIFICATION DIVISION.
       PROGRAM-ID. BANKING-SYSTEM.


       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT FD-RECORD ASSIGN TO 'C:\Cobol\BANK\record.dat'
           ORGANIZATION IS INDEXED
           ACCESS IS RANDOM
           RECORD KEY IS F-ACCNUM
           FILE STATUS IS WS-FILESTATUS.

           SELECT FD-DEPOSIT ASSIGN TO 'C:\Cobol\BANK\deposit.dat'
           ORGANIZATION IS INDEXED
           ACCESS IS RANDOM
           RECORD KEY IS FD-ACCNUM
           FILE STATUS IS WS-FILESTATUS.

           SELECT FD-WITHDRAW ASSIGN TO 'C:\Cobol\BANK\withdraw.dat'
           ORGANIZATION IS INDEXED
           ACCESS IS RANDOM
           RECORD KEY IS FW-ACCNUM
           FILE STATUS IS WS-FILESTATUS.

       DATA DIVISION.
       FILE SECTION.
       FD FD-RECORD.
       01 F-ACCOUNT.
           05 F-ACCNUM PIC 9(10).
           05 F-NAME.
               10 F-FNAME PIC X(10).
               10 F-LNAME PIC X(10).
           05 F-PASSCODE PIC 9(6).
           05 F-BALANCE PIC 9(7)V99.

       FD FD-DEPOSIT.
       01 FD-ACCOUNT.
           05 FD-ACCNUM PIC 9(10).
           05 FD-NAME.
               10 FD-FNAME PIC X(10).
               10 FD-LNAME PIC X(10).
           05 FD-PASSCODE PIC 9(6).

       FD FD-WITHDRAW.
       01 FW-ACCOUNT.
           05 FW-ACCNUM PIC 9(10).
           05 FW-NAME PIC X(20).
           05 FW-PASSCODE PIC 9(6).

       WORKING-STORAGE SECTION.

       01 WS-FILESTATUS PIC XX.
       01 WS-ACCOUNT.
           05 WS-ACCNUM PIC 9(10).
           05 WS-NAME.
               10 WS-FNAME PIC X(10).
               10 WS-LNAME PIC X(10).
           05 WS-PASSCODE PIC 9(6).
           05 WS-BALANCE PIC 9(7)V99.

       01 WS-OPERATION PIC 9.
       01 WS-FLAG PIC 9.
       01 WS-PASSCODE-TEMP PIC 9(6).
       01 WS-DEPOSIT PIC 9(7)V99.
       01 WS-WITHDRAW PIC 9(7)V99.

       PROCEDURE DIVISION.
       MAIN-MENU.
           INITIALIZE WS-ACCOUNT
           INITIALIZE F-ACCOUNT

           DISPLAY "BANQUE D'OR BANKING SYSTEM"
           DISPLAY "1 - Login"
           DISPLAY "2 - Create Account"
           DISPLAY "3 - Exit"
           DISPLAY "0 - VIEW Account, not for final"
           DISPLAY "> "
           ACCEPT WS-OPERATION

           IF WS-OPERATION = 1 THEN
               GO TO LOGIN-MENU
           ELSE IF WS-OPERATION = 2 THEN
               GO TO CREATE-ACCOUNT
           ELSE IF WS-OPERATION = 3 THEN
               STOP RUN
           ELSE IF WS-OPERATION = 0 THEN
               GO TO VIEW
           ELSE
               DISPLAY "Invalid input."
               GO TO MAIN-MENU
           END-IF.


       VIEW.
           ACCEPT F-ACCNUM


           OPEN INPUT FD-RECORD
               DISPLAY WS-FILESTATUS
               READ FD-RECORD RECORD INTO WS-ACCOUNT
                   KEY IS F-ACCNUM
                   INVALID KEY DISPLAY 'Invalid Key'
                   NOT INVALID KEY DISPLAY WS-ACCOUNT
               END-READ
           CLOSE FD-RECORD


           STOP RUN.


       CREATE-ACCOUNT.
           DISPLAY "=== CREATE ACCOUNT =========="
           DISPLAY "Account No.: "
           ACCEPT F-ACCNUM

           OPEN INPUT FD-RECORD
               IF WS-FILESTATUS = 00 THEN
                   READ FD-RECORD RECORD INTO WS-ACCOUNT
                       KEY IS F-ACCNUM
                       INVALID KEY MOVE 0 TO WS-FLAG
                       NOT INVALID KEY MOVE 1 TO WS-FLAG
                   END-READ
               END-IF
           CLOSE FD-RECORD

           IF WS-FLAG = 1 THEN
               DISPLAY "Account Number has been taken. Try again."
               GO TO CREATE-ACCOUNT
           END-IF


           DISPLAY "Name: "
           ACCEPT F-NAME
           DISPLAY "Passcode: "
           ACCEPT F-PASSCODE
           DISPLAY "Initial Deposit: "
           ACCEPT F-BALANCE

           OPEN I-O FD-RECORD.

           IF WS-FILESTATUS = 35 THEN
               OPEN OUTPUT FD-RECORD
           END-IF

           WRITE F-ACCOUNT

           DISPLAY "Account created successfully."
           CLOSE FD-RECORD
           GO TO MAIN-MENU.


       LOGIN-MENU.
           DISPLAY "=== LOGIN MENU ============="
           DISPLAY "Account No.: "
           ACCEPT F-ACCNUM
           DISPLAY "Passcode: "
           ACCEPT F-PASSCODE

           MOVE F-PASSCODE TO WS-PASSCODE-TEMP

           OPEN I-O FD-RECORD
           IF WS-FILESTATUS IS NOT EQUAL TO 35 THEN
               READ FD-RECORD INTO WS-ACCOUNT
                   KEY IS F-ACCNUM
                   INVALID KEY MOVE 0 TO WS-FLAG
                   NOT INVALID KEY MOVE 1 TO WS-FLAG
               END-READ
           ELSE
               DISPLAY "Account database is empty."
           END-IF

           IF WS-FLAG = 1 THEN
               IF WS-PASSCODE = WS-PASSCODE-TEMP THEN
                   GO TO ACCOUNT-MENU
               ELSE
                   DISPLAY "WRONG PASS"
               END-IF
           ELSE IF WS-FLAG = 0 THEN
               DISPLAY "Account does not exist."
               GO TO LOGIN-MENU
           END-IF.



       ACCOUNT-MENU.
           DISPLAY "=== WELCOME BACK " WS-NAME
           DISPLAY "1 - Deposit"
           DISPLAY "2 - Withdraw"
           DISPLAY "3 - Check Balance"
           DISPLAY "4 - Logout"
           DISPLAY "> "
           ACCEPT WS-OPERATION

           IF WS-OPERATION = 1 THEN
               GO TO DEPOSIT-PARA
           ELSE IF WS-OPERATION = 2 THEN
               GO TO WITHDRAW-PARA
           ELSE IF WS-OPERATION = 3 THEN
               GO TO BALANCE-PARA
           ELSE IF WS-OPERATION = 4 THEN
               CLOSE FD-RECORD
               GO TO MAIN-MENU
           ELSE
               DISPLAY "Invalid input."
               GO TO ACCOUNT-MENU
           END-IF.


       DEPOSIT-PARA.
           DISPLAY "=== DEPOSIT =========="
           DISPLAY "Amount to deposit: "
           ACCEPT WS-DEPOSIT

           COMPUTE WS-BALANCE = WS-BALANCE + WS-DEPOSIT

           REWRITE F-ACCOUNT FROM WS-ACCOUNT
               INVALID KEY DISPLAY 'Invalid Key'
               NOT INVALID KEY DISPLAY 'Record Updated'
           END-REWRITE

           DISPLAY "Amount added successfully."

           GO TO ACCOUNT-MENU.


       WITHDRAW-PARA.
           DISPLAY "=== WITHDRAW =========="
           DISPLAY "Amount to withdraw: "
           ACCEPT WS-WITHDRAW

           IF WS-WITHDRAW > 50000 THEN
               DISPLAY "Withdrawn amount limit reached. Try again."
               GO TO WITHDRAW-PARA
           END-IF

           COMPUTE WS-BALANCE = WS-BALANCE - WS-WITHDRAW

           REWRITE F-ACCOUNT FROM WS-ACCOUNT
               INVALID KEY DISPLAY 'Invalid Key'
               NOT INVALID KEY DISPLAY 'Record Updated'
           END-REWRITE

           DISPLAY "Amount withdrawn successfully."

           GO TO ACCOUNT-MENU.

       BALANCE-PARA.
           DISPLAY "=== BALANCE =========="
           DISPLAY "[" F-ACCNUM "] Balance: " F-BALANCE

           GO TO ACCOUNT-MENU.
