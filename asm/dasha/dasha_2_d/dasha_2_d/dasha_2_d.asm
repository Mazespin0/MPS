.include "m16def.inc"

ldi r16, low(RAMEND)  
out SPL, r16
ldi r16, high(RAMEND) 
out SPH, r16 

ldi r16, 0b00000011
out DDRD, r16 ; ��������� ������ � ������ �������� ����� D �� �����
ldi r16, 0b00000000
out PORTD, r16  ; ��������� �� ���� �������� ����� D � ���������� 0
ldi r16, 0b00000000
out DDRA, r16  ; ��������� �� ���� �������� ����� A �� ����
ldi r16, 0b11111111
out PORTA, r16 ; ��������� �� ���� �������� ����� D � ���������� 1

Program: ; ���:���������� ������� ������ � 0 �� 7 ��������


; �������� ������� �������
rcall Delay20 ; �������� � 20 �� 
sbis PINA, 0
rjmp st2 ; ���������� �������, ������� �� ����� st2
sbis PINA, 1
rjmp error
sbis PINA, 2
rjmp error
sbis PINA, 3
rjmp error
sbis PINA, 4
rjmp error
sbis PINA, 5
rjmp error
sbis PINA, 6
rjmp error
sbis PINA, 7
rjmp error
rjmp PC-16 ; ����������� �� 16 ������ �����
st2: ; �������� ������� �������
rcall Delay20 ; �������� � 20 �� 
sbis PINA, 0
rjmp error
sbis PINA, 1
rjmp st3 ; ���������� �������, ������� �� ����� st3
sbis PINA, 2
rjmp error
sbis PINA, 3
rjmp error
sbis PINA, 4
rjmp error
sbis PINA, 5
rjmp error
sbis PINA, 6
rjmp error
sbis PINA, 7
rjmp error
rjmp PC-16 ; ����������� �� 16 ������ �����
st3:; �������� �������� �������
rcall Delay20 ; �������� � 20 �� 
sbis PINA, 0
rjmp error
sbis PINA, 1
rjmp error
sbis PINA, 2
rjmp st4 ; ���������� �������, ������� �� ����� st4
sbis PINA, 3
rjmp error
sbis PINA, 4
rjmp error
sbis PINA, 5
rjmp error
sbis PINA, 6
rjmp error
sbis PINA, 7
rjmp error
rjmp PC-16 ; ����������� �� 16 ������ �����
st4:; �������� ��������� �������
rcall Delay20 ; �������� � 20 �� 
sbis PINA, 0
rjmp error
sbis PINA, 1
rjmp error
sbis PINA, 2
rjmp error
sbis PINA, 3
rjmp st5 ; ���������� �������, ������� �� ����� st5
sbis PINA, 4
rjmp error
sbis PINA, 5
rjmp error
sbis PINA, 6
rjmp error
sbis PINA, 7
rjmp error
rjmp PC-16 ; ����������� �� 16 ������ �����
st5:; �������� ������ �������
rcall Delay20 ; �������� � 20 �� 
sbis PINA, 0
rjmp error
sbis PINA, 1
rjmp error
sbis PINA, 2
rjmp error
sbis PINA, 3
rjmp error
sbis PINA, 4
rjmp st6 ; ���������� �������, ������� �� ����� st6
sbis PINA, 5
rjmp error
sbis PINA, 6
rjmp error
sbis PINA, 7
rjmp error
rjmp PC-16 ; ����������� �� 16 ������ �����
st6:; �������� ������� �������
rcall Delay20 ; �������� � 20 �� 
sbis PINA, 0
rjmp error
sbis PINA, 1
rjmp error
sbis PINA, 2
rjmp error
sbis PINA, 3
rjmp error
sbis PINA, 4
rjmp error
sbis PINA, 5
rjmp st7 ; ���������� �������, ������� �� ����� st7
sbis PINA, 6
rjmp error
sbis PINA, 7
rjmp error
rjmp PC-16 ; ����������� �� 16 ������ �����
st7:; �������� �������� �������
rcall Delay20 ; �������� � 20 �� 
sbis PINA, 0
rjmp error
sbis PINA, 1
rjmp error
sbis PINA, 2
rjmp error
sbis PINA, 3
rjmp error
sbis PINA, 4
rjmp error
sbis PINA, 5
rjmp error
sbis PINA, 6
rjmp st8 ; ���������� �������, ������� �� ����� st8
sbis PINA, 7
rjmp error
rjmp PC-16 ; ����������� �� 16 ������ �����
st8:; �������� �������� �������
rcall Delay20 ; �������� � 20 �� 
sbis PINA, 0
rjmp error
sbis PINA, 1
rjmp error
sbis PINA, 2
rjmp error
sbis PINA, 3
rjmp error
sbis PINA, 4
rjmp error
sbis PINA, 5
rjmp error
sbis PINA, 6
rjmp error
sbis PINA, 7
rjmp  _main_  ; ���� ��������� ������ ��� ������, ������� �� �����  _main_
rjmp PC-16 ; ����������� �� 16 ������ �����

rjmp Program 

error:
ldi r16, 0b00000010
out PORTD, r16 ; ��������� ���������� � ������� 1
rcall Delay ; ��������
ldi r16, 0b00000000
out PORTD, r16 ; ������� ���������� � ������� 1
rjmp Program 

 _main_:
ldi r16, 0b00000001
out PORTD, r16 ; ��������� ���������� � ������� 0
rcall Delay ; ��������
ldi r16, 0b00000000
out PORTD, r16 ; ������� ���������� � ������� 0
rjmp Program 

Delay20:
 ldi r19, 40
D20loop2:
 ldi r18, 100
D20loop1:
 ldi r17, 220
D20loop0:
 dec r17
 brne D20loop0
 dec r18
 brne D20loop1
 dec r19
 brne D20loop2
ret

Delay:
 ldi r19, 50
Dloop2:
 ldi r18, 255
Dloop1:
 ldi r17, 255
Dloop0:
 dec r17
 brne Dloop0
 dec r18
 brne Dloop1
 dec r19
 brne Dloop2
ret

