/*
 * timer.c
 *
 *  Created on: Oct 5, 2023
 */

#include "timer.h"
#include "leds.h"

#define PRESCALER_TO_MS		3999

void timer_init(TIM_TypeDef* timer)
{
	// enable RCC (power)
	if(timer == TIM2)
	{
		RCC->APB1ENR1 |= RCC_APB1ENR1_TIM2EN;
	}

	// stop timer (disable)
	timer->CR1 &= 0;
	// clear out timer state
	if(timer == TIM2)
	{
		RCC->APB1RSTR1 |= RCC_APB1RSTR1_TIM2RST;
		RCC->APB1RSTR1 &= ~RCC_APB1RSTR1_TIM2RST;
	}
	// clear counter (write 0)
	timer->CNT = 0;

	// enable timer interrupt internally
	timer->DIER |= 1;
	// enable timer interrupt in NVIC
	if(timer == TIM2)
	{
		NVIC_SetPriority(TIM2_IRQn, 0);
		NVIC_EnableIRQ(TIM2_IRQn);
	}

	// setup clock tree
	// set prescaler to divide
	timer->PSC = PRESCALER_TO_MS;

	// enable timer
	timer->CR1 |= 1;
}

void timer_reset(TIM_TypeDef* timer)
{
	// reset counters
	timer->CNT = 0;
}

void timer_set_ms(TIM_TypeDef* timer, uint16_t period_ms)
{
	timer->ARR = period_ms;
}
