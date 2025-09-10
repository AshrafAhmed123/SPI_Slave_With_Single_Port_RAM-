vlib work
vlog SPI_Wrapper.v SPI_Wrapper_tb.v
vsim -voptargs=+acc work.SPI_Wrapper_tb
add wave *
add wave -position insertpoint  \
sim:/SPI_Wrapper_tb/DUT/rx_data \
sim:/SPI_Wrapper_tb/DUT/rx_valid \
sim:/SPI_Wrapper_tb/DUT/tx_data \
sim:/SPI_Wrapper_tb/DUT/tx_valid
add wave -position insertpoint  \
sim:/SPI_Wrapper_tb/DUT/Block_1/counter
add wave -position insertpoint  \
sim:/SPI_Wrapper_tb/DUT/Block_1/cs \
sim:/SPI_Wrapper_tb/DUT/Block_1/ns \
sim:/SPI_Wrapper_tb/DUT/Block_1/read_addr_recieved
add wave -position insertpoint  \
sim:/SPI_Wrapper_tb/DUT/Block_2/addr \
sim:/SPI_Wrapper_tb/DUT/Block_2/mem
run -all
#quit -sim