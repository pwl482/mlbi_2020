methylnet-embed perform_embedding -bce -v -j 12345 -hl embeddings/embed_hyperparameters_log.csv --n_latent 200 --learning_rate 0.1 --weight_decay 0.0001 --n_epochs 700 --kl_warm_up 0 --beta 1.0 --scheduler warm_restarts --t_max 10 --eta_min 1e-06 --t_mult 1.2 --n_workers 4 --loss_reduction sum --hidden_layer_encoder_topology 200,200,300 
methylnet-predict make_prediction -cat -v -j 54321 -hl predictions/predict_hyperparameters_log.csv --learning_rate_vae 0.1 --learning_rate_mlp 0.05 --weight_decay 0.0001 --n_epochs 200 --scheduler null --dropout_p 0.5 --n_workers 4 --loss_reduction sum --hidden_layer_topology 200,300,3000 
pymethyl-visualize transform_plot -i predictions/vae_mlp_methyl_arr.pkl -o visualizations/54321_disease_mlp_embed.html -c disease -nn 8
methylnet-predict classification_report
methylnet-visualize plot_training_curve -thr 2e6
