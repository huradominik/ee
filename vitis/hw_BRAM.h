#ifndef HW_H
#define HW_H

typedef struct{
	unsigned int set;
	unsigned int LED;
}TLED;
typedef TLED *PLED;

typedef struct{
	union{
		unsigned int BUTT;
		struct{
			unsigned int BUTT_0 : 1;
			unsigned int BUTT_1 : 1;
			unsigned int xBUTT : 30;
		};
	};
}TBUTT;
typedef TBUTT *PBUTT;

typedef struct{
	unsigned int input;
	unsigned int output;
}Tff;
typedef Tff * Pff;

typedef struct{
	unsigned int gain;
	unsigned int row;
	unsigned int col;
	unsigned int result;
}TBRAM;
typedef TBRAM *PBRAM;



#endif
