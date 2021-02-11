; -----------------------------------------
; ЛР №x
; -----------------------------------------
; Архітектура комп'ютера
; Завдання: 
; ВУЗ: КНУУ "КПІ"
; Факультет: ФІОТ
; Курс: 1
; Група: ІТ-03
; -----------------------------------------
; Автори:	Букрєєв М.С.
;			Король К.В.
;			Федяй Б.В.
; Дата: dd/mm/2021
; -----------------------------------------

;					І. Заголовок програми
IDEAL
MODEL small
STACK 256
;					ІІ. Макроси
MACRO M_init		; Макрос для ініціалізації. Його початок
	mov ax, @data	; @data ідентифікатор, що створюються директивою MODEL
	mov ds, ax		; Завантаження початку сегменту даних в регістр DS
	mov es, ax		; Завантаження початку сегменту даних в регістр ES
	ENDM M_init		; Кінець макросу
;					ІІІ. Початок сегменту даних
DATASEG
exCode db 0
;					IV. Початок сегменту коду
CODESEG
Start:
	M_init	; Виклик макросу для ініціалізації
	; -----------------------------------------
	
	; -----------------------------------------
	mov ah, 4ch			; Завантаження числа 01h до регістру AH 
	mov al, [exCode]	; Завантаження значення exCode до регістру AL
	int 21h				; Виклик преривання 21h (AH = 4ch, AL = код виходу - команда виходу із програми)
	end Start