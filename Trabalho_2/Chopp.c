sbit LCD_RS at RA2_bit;
sbit LCD_EN at RA3_bit;
sbit LCD_D4 at RA4_bit;
sbit LCD_D5 at RA5_bit;
sbit LCD_D6 at RA6_bit;
sbit LCD_D7 at RA7_bit;
sbit LCD_RS_Direction at TRISA2_bit;
sbit LCD_EN_Direction at TRISA3_bit;
sbit LCD_D4_Direction at TRISA4_bit;
sbit LCD_D5_Direction at TRISA5_bit;
sbit LCD_D6_Direction at TRISA6_bit;
sbit LCD_D7_Direction at TRISA7_bit;

#define SELECT PORTB.F0  // Botao de selecao
#define FILL PORTB.F1  // Botao de acao
#define DEBOUNCE_TIME 50  // Tempo para evitar bounce
#define PRESS_TIME 100 // Tempo para evitar aperto acidental do botao de acao

unsigned char beverage = 0;  // Tipo de chopp
unsigned char size = 0;  // Tamanho do chopp

// Selecao da bebida
void selectBeverage() {
    // Alterna o tipo de chopp a cada vez que o botao de selecao e acionado
    beverage = (beverage + 1) % 4;
    Lcd_Cmd(_LCD_CLEAR);
    // Exibe a mensagem para o respectivo tipo de chopp e liga o LED
    switch (beverage) {
        case 1: Lcd_Out(1, 5, "Brahma"); PORTB = 0b00000100; break;
        case 2: Lcd_Out(1, 5, "Skol"); PORTB = 0b00001000; break;
        case 3: Lcd_Out(1, 5, "Heineken"); PORTB = 0b00010000; break;
        case 0: Lcd_Out(1, 5, "Antartica"); PORTB = 0b00100000; break;
    }
}

// Selecao do tamanho
void selectSize() {
    // Alterna o tamanho a cada vez que o botao de selecao e acionado
    size = (size + 1) % 3;
    Lcd_Cmd(_LCD_CLEAR);
    // Alterna o indicador ^ para o respectivo tamanho
    switch (size) {
        case 1: Lcd_Out(1, 6, "P  M  G"); Lcd_Out(2, 6, "^      "); break;
        case 2: Lcd_Out(1, 6, "P  M  G"); Lcd_Out(2, 6, "   ^   "); break;
        case 0: Lcd_Out(1, 6, "P  M  G"); Lcd_Out(2, 6, "      ^"); break;
    }
}

// Enchendo o copo
void fillTime(){
     // Leitura do tamanho escolhido, delay correspondente e abertura da torneira
    switch (size) {
        case 1: Lcd_Out(1, 5, "Enchendo"); PORTB.F6 = 1; Delay_ms(3000); PORTB.F6 = 0; break;
        case 2: Lcd_Out(1, 5, "Enchendo"); PORTB.F6 = 1; Delay_ms(5000); PORTB.F6 = 0; break;
        case 0: Lcd_Out(1, 5, "Enchendo"); PORTB.F6 = 1; Delay_ms(7000); PORTB.F6 = 0; break;
    }
}

void main() {
    TRISB.F0 = 1;  // Entrada botao de selecao
    TRISB.F1 = 1;  // Entrada botao de acao
    TRISB.F2 = 0;  // Saida LED bebida
    TRISB.F3 = 0;  // Saida LED bebida
    TRISB.F4 = 0;  // Saida LED bebida
    TRISB.F5 = 0;  // Saida LED bebida
    TRISB.F6 = 0;  // Saida LED copo enchendo
// Iniacializando o LCD e cumprimentando o usuario
    Lcd_Init();
    Lcd_Cmd(_LCD_CLEAR);
    Lcd_Cmd(_LCD_CURSOR_OFF);
    Lcd_Out(1, 4, "Bem-Vindo!");
    Delay_ms(5000);
// Tag para resetar o programa
begin:
    Lcd_Cmd(_LCD_CLEAR);
    Lcd_Out(1, 1, "Aperte o botão");
    Lcd_Out(2, 4, "de seleção");
    PORTB = 0x00;

    // Loop da selecao de bebida
    while (1) {
        // Interrupcao ao apertar o botao de acao (bebida selecionada)
        if (FILL == 1) {
            Delay_ms(PRESS_TIME); // Evitando bounce
            if (FILL == 1) {
                Lcd_Cmd(_LCD_CLEAR);
                Delay_ms(500);
                break;
            }
        }
        // Verifica a borda de subida no botao de selecao e executa o selectBeverage a cada aperto
        if (SELECT == 1) {
            Delay_ms(DEBOUNCE_TIME); // Evitando bounce
            if (SELECT == 1) {
                selectBeverage();
                while (SELECT == 1);
                Delay_ms(DEBOUNCE_TIME);
            }
        }
    }
    
    Lcd_Out(1, 3, "Selecione o");
    Lcd_Out(2, 5, "tamanho");

    // Loop da selecao do tamanho
    while (1) {
        // Interrupcao ao apertar o botao de acao (tamanho selecionado)
        if (FILL == 1) {
            Delay_ms(PRESS_TIME); // Evitando bounce
            if (FILL == 1) {
                break;
            }
        }
        // Verifica a borda de subida no botao de selecao e executa o selectSize a cada aperto
        if (SELECT == 1) {
            Delay_ms(DEBOUNCE_TIME); // Evitando bounce
            if (SELECT == 1) {
                selectSize();
                while (SELECT == 1);
                Delay_ms(DEBOUNCE_TIME);
            }
        }
    }
    // Abrindo a torneira
    Lcd_Cmd(_LCD_CLEAR);
    fillTime();
    Lcd_Cmd(_LCD_CLEAR);
    Lcd_Out(1, 3, "Copo cheio!");
    Delay_ms(3000);
    
    goto begin;

}