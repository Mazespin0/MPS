.include "m16def.inc";
.def temp = r16;
.def sys = r17;
.def count = r18;
.def count_r = r19;
.def port_status = r20;
.def port_status_l = r21;
.def pin_c = r22;
.def pin_counter = r23;

.equ Bitrate = 9600;
.equ BAUD = 8000000 / (16 * Bitrate) - 1; //�������� � �����/���

.cseg;
.org 0;
	jmp _reset;

array: .DB "Button ", $00; //����������� �� ����� �� ������ ������ � ������

_reset:
	ldi temp, high(RAMEND);
	out SPH, temp;
	ldi temp, low(RAMEND);
	out SPL, temp;

	ldi temp, high(BAUD);
	out UBRRH, temp;
	ldi temp, low(BAUD);
	out UBRRL, temp;

	ldi temp, 0xFF;
	out DDRA, temp;

	ldi temp, (0 << RXCIE) | (0 << TXCIE) | (0 << UDRIE) | (0 << RXEN) | (1 << TXEN);
	out UCSRB, temp;
	ldi temp, (1 << URSEL) | (1 << UCSZ0) | (1 << UCSZ1);
	out UCSRC, temp;

	sei;


_main:
	ldi ZL, low(array * 2); //���������� � ����������� ���� Z ����� ������ ������ "������", �������� �� 2 ������ ��� � ������ �����, � � ��� �����
	ldi ZH, high(array * 2);

	clr port_status
	rcall _delay
	in port_status, PINA;
	cp port_status, port_status_l //���������� ����� ������ ����� � ����������
		breq _main; //���� ����� �� �������
		//���� ������ �� ���� ������
	ldi pin_counter, '0'; //������� ������, ���������� 0
	ldi pin_c, '1'; //��������� ������, ���������� 1
	mov port_status_l, port_status

	rjmp _pins_handler

_pins_handler:
	sbrs port_status, 0; // ��������� ��������� 1-� ������
				ldi pin_c, '0';
		rcall _puts //������� �� ���������
		// �� � ��� 8 ���
	sbrs port_status, 1;
				ldi pin_c, '0';
		rcall _puts

	sbrs port_status, 2;
				ldi pin_c, '0';
		rcall _puts

	sbrs port_status, 3;
				ldi pin_c, '0';
		rcall _puts

	sbrs port_status, 4;
				ldi pin_c, '0';
		rcall _puts

	sbrs port_status, 5;
				ldi pin_c, '0';
		rcall _puts

	sbrs port_status, 6;
				ldi pin_c, '0';
		rcall _puts

	sbrs port_status, 7;
				ldi pin_c, '0';
		rcall _puts

	ldi temp, ' ';
		rcall _uart;
	ldi temp, '\r'; //��������� ������ �� ��������� ������
		rcall _uart;


	rjmp _main;



_puts:
	ldi ZL, low(array * 2);
	ldi ZH, high(array * 2);

_puts_1:
	lpm	temp, Z+; // � ���� ������ ��������� ���������� ������ �� ������ "�������" � ��������������� ������������ ������ 
	cpi	temp, $00; // ��������� �� ����� �� �� ����� "�������"
		breq _puts_end;
	rcall _uart;
	rjmp _puts_1;
	

_puts_end:
	ldi temp, ' ';
		rcall _uart;
	mov temp, pin_counter;
		rcall _uart; // ������� ����� ������
	ldi temp, ' ';
		rcall _uart;
	ldi temp, '-';
		rcall _uart;
	ldi temp, ' ';
		rcall _uart;
	mov temp, pin_c; 
		rcall _uart; // ������� ��������� ���� ������
	ldi temp, ' ';
		rcall _uart;
	clr pin_c;
	ldi temp, ' ';
		rcall _uart;
	inc pin_counter; // �������������� ����� ������
	ldi pin_c, '1';
	ldi temp, '\r'; // ��������� ������
		rcall _uart;

	ret

_uart: // ����� � uart, ����������� ����������� �� ��������
	sbis UCSRA, UDRE;
			rjmp PC - 1;
	out UDR, temp;
	ret;
	

_delay:
          ldi  R17, $5F
WGLOOP0:  ldi  R18, $17
WGLOOP1:  ldi  R19, $79
WGLOOP2:  dec  R19
          brne WGLOOP2
          dec  R18
          brne WGLOOP1
          dec  R17
          brne WGLOOP0
		  ret;
