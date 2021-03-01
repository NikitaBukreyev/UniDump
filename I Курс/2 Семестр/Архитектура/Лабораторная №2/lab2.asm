; -----------------------------------------
; ЛР №2
; -----------------------------------------
; Архітектура комп'ютера
; Завдання: основи розробки та налагодження
; ВУЗ: КНУУ "КПІ"
; Факультет: ФІОТ
; Курс: 1
; Група: ІТ-03
; Варіант: 1
; -----------------------------------------
; Автори:	Букрєєв М.С.
;			Король К.В.
;			Федяй Б.В.
; Дата: 11/02/2021
; -----------------------------------------

;					І. Заголовок програми
IDEAL
MODEL small
STACK 256
;					ІІ. Макроси та константи
MACRO M_init				; Макрос для ініціалізації. Його початок
	mov ax, @data			; @data ідентифікатор, що створюються директивою MODEL
	mov ds, ax				; Завантаження початку сегменту даних в регістр DS
	mov es, ax				; Завантаження початку сегменту даних в регістр ES
	ENDM M_init				; Кінець макросу
C_SCHEME equ 00010010b 		; Константа зі схемою кольору для кожного символу вікна
SQR_START equ 162			; Константа із числом, що вказує на координати початку малювання прямокутника (х=2, у=2)
;					ІІІ. Початок сегменту даних
DATASEG
exCode db 0
rect_line db 00h, C_SCHEME, 00h, C_SCHEME, 00h, C_SCHEME, 00h, C_SCHEME, 00h, C_SCHEME, 00h, C_SCHEME, 00h, C_SCHEME, 00h, C_SCHEME, 00h, C_SCHEME, 00h, C_SCHEME
		  db 00h, C_SCHEME, 00h, C_SCHEME, 00h, C_SCHEME, 00h, C_SCHEME, 00h, C_SCHEME, 00h, C_SCHEME, 00h, C_SCHEME, 00h, C_SCHEME, 00h, C_SCHEME, 00h, C_SCHEME
rect_line_length=$-rect_line
text_line db "H", C_SCHEME, "e", C_SCHEME, "y", C_SCHEME, ",", C_SCHEME, " ", C_SCHEME
		  db "h", C_SCHEME, "e", C_SCHEME, "y", C_SCHEME, ",", C_SCHEME, " ", C_SCHEME
		  db "h", C_SCHEME, "e", C_SCHEME, "y", C_SCHEME, "!", C_SCHEME
text_line_length=$-text_line
;					IV. Початок сегменту коду
CODESEG
Start:
	M_init				; Виклик макросу для ініціалізації
	cld					; Скидання прапорця напрямку (режим інкремента)
	mov ax, 0B800h		; Записуємо адресу сегменту відеопам'яті
	mov es, ax			; Встановлюємо ES на початок відеопам'яті
	mov dx, SQR_START	; Встановлюємо координати початку створення прямокутника
	; -----------------------------------------
	; Тут ми використовуємо цикл для того, щоб спочатку створити прямокутник без символів. Це допоможе зєкономити час та пам'ять для створення кожної лінії прямокутника окремо
	mov	bx, 10					; Встановлюємо кількість ітерацій циклу (кількість рядків у прямокутнику)
	LBL_SQR:					; Початок циклу
	mov di, dx					; Завантаження числа із DX до DI
	mov si, offset rect_line	; Пересилання адреси рядка із кольорами фону в регістр DX
	mov cx, rect_line_length	; Встановлення значення лічильника для команди rep
	rep movsb					; Запис до ES:(E)DI байту із адреси DS:(E)SI, CX разів
	add dx, 160					; Збільшуємо число 
	dec	bx						; Декримент BX
	jnz	LBL_SQR					; Повертаємось до початку циклу, якщо BX != 0
	
	mov dx, SQR_START+1*160+2*2	; Встановлюємо координати, за якими буде записуватись наш текст за формулою SQR_START+N*160+M*2, де N - квількість відступлених рядків, M - кількість відступлених елементів
	mov di, dx					; Завантаження числа із DX до DI
	mov si, offset text_line	; Пересилання адреси рядка із кольорами фону в регістр DX
	mov cx, text_line_length	; Встановлення значення лічильника для команди rep
	rep movsb					; Запис до ES:(E)DI байту із адреси DS:(E)SI, CX разів
	; -----------------------------------------
	mov ah, 01h		; Завантаження числа 01h до регістру AH 
	int 21h			; Виклик преривання 21h (01h - команда очікування натискання будь-якої клавіші)
	; -----------------------------------------
	mov ah, 4ch			; Завантаження числа 01h до регістру AH 
	mov al, [exCode]	; Завантаження значення exCode до регістру AL
	int 21h				; Виклик преривання 21h (AH = 4ch, AL = код виходу - команда виходу із програми)
	end Start