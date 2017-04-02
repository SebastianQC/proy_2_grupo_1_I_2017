module Marcos(
 	input wire rst, //reset
 	input wire video_on, // indica donde pintar
 	input wire [9:0] pixel_x, pixel_y, // posicion coordenadas x, y
 	output [3:0] ro,go,bo,
 	output [7:0] font1,
 	output [2:0] char1,
 	output fb
);

wire fhv1,fhv2, fhh1, fhh2, cajitafh, hv1, hv2, hh1, hh2, cajitah, tv1, tv2, th1, th2, cajitat;

    // BORDE DE PANTALLA    

// ********** BORDES VERTICALES DE PANTALLA ***********

    // PRIMER BORDE DE PANTALLA
	localparam BordePantallaxIzq =  0;
	localparam BordePantallaxDer = 10;
	localparam BordePantallay    =  0;
	localparam BordePantallayf   = 479;
	wire  BordeIzq_on;
	assign BordeIzq_on = ((pixel_x>=BordePantallaxIzq) && (pixel_x<=BordePantallaxDer) &&
        (pixel_y>=BordePantallay) && (pixel_y<=BordePantallayf));

	// SEGUNDO BORDE DE PANTALLA 
	localparam BordePantalla2xIzq=629;
	localparam BordePantalla2xDer=639;
	localparam BordePantalla2y  = 0;
	localparam BordePantalla2yf  = 479;
	wire  BordeDer_on;
	assign BordeDer_on = ((pixel_x>=BordePantalla2xIzq) && (pixel_x<=BordePantalla2xDer) &&
        (pixel_y>=BordePantalla2y) && (pixel_y<=BordePantalla2yf));

// ******************************************************	

// ********** BORDES HORIZONTALES DE PANTALLA ***********	

	// PRIMER BORDE DE PANTALLA
	localparam BordeSupIzqx=10;
	localparam BordeSupDerx=629;
	localparam BordeSupy = 0;
	localparam BordeSupyf = 10;
	wire  BordeSup_on;
	assign BordeSup_on = ((pixel_x>=BordeSupIzqx) && (pixel_x<=BordeSupDerx) &&
        (pixel_y>=BordeSupy) && (pixel_y<=BordeSupyf));
	
	// SEGUNDO BORDE DE PANTALLA
	localparam BordeInfIzqx=10;
	localparam BordeInfDerx=629;
	localparam BordeInfy = 469;
	localparam BordeInfyf = 479;
	wire  BordeInf_on;
	assign BordeInf_on = ((pixel_x>=BordeInfIzqx) && (pixel_x<=BordeInfDerx) &&
	(pixel_y>=BordeInfy) && (pixel_y<=BordeInfyf));
	
	//Cajita para fecha
	assign fhv1 = ((pixel_x>=160)&&(pixel_x<=175)&&(pixel_y>=32)&&(pixel_y<=127));
	assign fhv2 = ((pixel_x>=448)&&(pixel_x<=463)&&(pixel_y>=32)&&(pixel_y<=127));
	assign fhh1 = ((pixel_x>=160)&&(pixel_x<=463)&&(pixel_y>=32)&&(pixel_y<=47));
	assign fhh2 = ((pixel_x>=160)&&(pixel_x<=463)&&(pixel_y>=112)&&(pixel_y<=127));
	assign cajitafh = (fhv1|fhv2|fhh1|fhh2);
	
	//Cajita para hora
    assign hv1 = ((pixel_x>=128)&&(pixel_x<=144)&&(pixel_y>=192)&&(pixel_y<=287));
    assign hv2 = ((pixel_x>=480)&&(pixel_x<=496)&&(pixel_y>=192)&&(pixel_y<=287));
    assign hh1 = ((pixel_x>=128)&&(pixel_x<=496)&&(pixel_y>=192)&&(pixel_y<=207));
    assign hh2 = ((pixel_x>=128)&&(pixel_x<=496)&&(pixel_y>=272)&&(pixel_y<=287));
    assign cajitah = (hv1|hv2|hh1|hh2);
    
    //Cajita para timer
    assign tv1 = ((pixel_x>=160)&&(pixel_x<=175)&&(pixel_y>=336)&&(pixel_y<=431));
    assign tv2 = ((pixel_x>=448)&&(pixel_x<=463)&&(pixel_y>=336)&&(pixel_y<=431));
    assign th1 = ((pixel_x>=160)&&(pixel_x<=463)&&(pixel_y>=336)&&(pixel_y<=351));
    assign th2 = ((pixel_x>=160)&&(pixel_x<=463)&&(pixel_y>=416)&&(pixel_y<=431));
    assign cajitat = (tv1|tv2|th1|th2);

//letras
reg [1:0] char;
wire [3:0] row;
wire [5:0] rom;
reg [2:0] selec;
wire [2:0] bit;
wire [7:0] font;
wire fontb;

fontROM rom1(.clk(clk),
             .addr(rom),
             .sel_caracter(selec),
             .data(font));
wire fok,hok,h1ok,rok,tok,iok, varaok;
assign row = pixel_y[3:0];
assign bit = pixel_x[2:0];
assign rom = {char,row};
assign fontb=font[~bit];
assign fok=((pixel_x>=96)&&(pixel_x<=111)&&(pixel_y>=48)&&(pixel_y<=79));
assign hok=((pixel_x>=128)&&(pixel_x<=143)&&(pixel_y>=48)&&(pixel_y<=79));
assign font1=font;
assign fb=fontb;

	
// ***************Multiplexor de bordes*****************
reg [3:0]r;
reg [3:0]g;
reg [3:0]b;
/*always @*
begin
    if(fok)
    begin
    selec<=1'b0;
    char<=2'b01;
            if(fontb==1)
            begin
                r<=4'h0;
                g<=4'h0;
                b<=4'h1;
            end
            else
            begin
                r<=4'h0;
                g<=4'h0;
                b<=4'h1;
            end
      end
    else if(hok) 
    begin
    selec<=1'b1;
    char<=2'b10;
        if(fontb==1)
        begin
            r<=4'h0;
            g<=4'h0;
            b<=4'h1;
        end
        else
        begin
            r<=4'h0;
            g<=4'h0;
            b<=4'h1;
        end
    end
    else
    begin
        r<=4'h1;
        g<=4'h1;
        b<=4'h1;
    end
end*/
always @*
    if(rst|~video_on)
        begin
            r<=1;
            g<=1;
            b<=1;
        end
    else
        begin
            if(BordeIzq_on|BordeDer_on|BordeSup_on|BordeInf_on)
                begin
                    r<=4'h5;
                    g<=4'h0;
                    b<=4'h3;
                end
            else if(cajitafh)
                    begin
                       r<=4'h0;
                       g<=4'h0;
                       b<=4'h1;  
                    end
            else if(cajitah)
                    begin
                        r<=4'h0;
                        g<=4'h1;
                        b<=4'h0;  
                    end
            else if(cajitat)
                    begin
                        r<=4'h1;
                        g<=4'h0;
                        b<=4'h0;  
                    end
            else
                begin
                    r<=4'h1;
                    g<=4'h1;
                    b<=4'h1;
                end
        end

 assign ro=r;
 assign go=g;
 assign bo=b;
 assign char1=char;
endmodule

