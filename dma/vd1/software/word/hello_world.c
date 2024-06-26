#include <stdio.h>
#include <system.h>
#include "altera_avalon_dma_regs.h"
#include "sys/alt_irq.h"

// pdata points to a global array stored in onchip_memory2_1
unsigned short pdata[16] = {0, 1, 2, 3, 4, 5, 6 , 7,
		8, 9, 10, 11, 12, 13, 14, 15};

// pdatal points to onchip_memory2_1
unsigned short* pdatal = (unsigned short*)(ONCHIP_MEMORY2_1_BASE);

// Interrupt handler of DMA
void DMA_ISR_Handler(void* isr_context){
  int i;

  // Read and print data in onchip_memory2_1
  printf("Received data:\n");
  for(i = 0; i < 16; i++) {
    printf("word %d %d\n", i, pdatal[i]);
  }

  // Clear DMA interrupt bit
  IOWR_ALTERA_AVALON_DMA_STATUS(DMA_0_BASE, 0);
}

// Initialize function of DMA
void DMA_Init(void) {
  // De-init DMA
  IOWR_ALTERA_AVALON_DMA_CONTROL(DMA_0_BASE, 0);

  // Source address is pdata
  IOWR_ALTERA_AVALON_DMA_RADDRESS(DMA_0_BASE, (int)pdata);

  // Destination address is pdatal
  IOWR_ALTERA_AVALON_DMA_WADDRESS(DMA_0_BASE, (int)pdatal);

  // Length is 8 (because each word is 2 halfwords, or 4 bytes)
  IOWR_ALTERA_AVALON_DMA_LENGTH(DMA_0_BASE, 16);

  // Configure and Start DMA
  // Word transfer
  IOWR_ALTERA_AVALON_DMA_CONTROL(DMA_0_BASE, ALTERA_AVALON_DMA_CONTROL_WORD_MSK |
                                             ALTERA_AVALON_DMA_CONTROL_LEEN_MSK |
                                             ALTERA_AVALON_DMA_CONTROL_I_EN_MSK |
                                             ALTERA_AVALON_DMA_CONTROL_GO_MSK);
}

// entry point main()
int main(void) {
  DMA_Init();
  alt_ic_isr_register(0, DMA_0_IRQ, DMA_ISR_Handler, (void*)0, (void*)0);
  while(1);
}
