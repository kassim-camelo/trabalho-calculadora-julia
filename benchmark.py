import time
start_time = time.perf_counter()
for i in range(1000000000):
    pass
time_end = time.perf_counter() - start_time
print(f"Contei até {i+1} em {time_end} segundos.")